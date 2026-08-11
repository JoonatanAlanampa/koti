// SPDX-License-Identifier: GPL-2.0
/*
 * koti_esp.c — a serial driver for src/esp_uart.sv, koti's link to the
 * onboard ESP32. This is what turns an MMIO register block into
 * /dev/ttyKOTI0, and it is the layer everything else in PLAN item 11 stands
 * on: a line discipline (SLIP or PPP) can only be attached to a tty, and the
 * userspace client that drives the far end can only open a device node.
 *
 * ⚠️ THAT CLIENT IS usr/bin/koti-net AND IT DOES NOT SPEAK AT COMMANDS. The
 * ESP32 on this board holds stock MicroPython 1.14, measured — not ESP-AT, as
 * PLAN.md used to assume. Nothing in this driver depends on which it is; the
 * note is here because "AT-command client" is what this comment said, and it
 * is the sort of aside that a later reader takes for a fact about the board.
 *
 * ⛔ MAINLINE BINDS TO NOTHING HERE, and calling the DT node `ns16550a` to
 * make it would be a lie that ends in 8250.c poking registers that do not
 * exist. koti's blocks are koti's: the keyboard needed koti_kbd.c, the card
 * needed koti_sd.c, the screen needed koticon.c, and this needs this.
 *
 * WHAT THE HARDWARE GIVES US, and why the driver looks the way it does:
 *   - a 64-byte RX FIFO with a level, and a level-sensitive PLIC interrupt
 *   - a 64-byte TX FIFO with a level, and an OPT-IN "there is room" interrupt
 *     sharing the same line
 *   - no modem control lines at all: no CTS, no RTS, no DCD, no ring
 *   - a FIXED baud rate, set by the DIV parameter at synthesis
 *
 * ⚠️ THE BAUD RATE IS IN THE BITSTREAM. set_termios cannot change it, because
 * changing it means a place-and-route. Asking for anything other than 115200
 * gets 115200 and a one-line complaint, rather than a port that silently
 * disagrees with the far end — which presents as garbage that looks like bad
 * wiring.
 *
 * ⚠️ THE DRIVER MUST NOT TOUCH THE STRAPS. Bits 0 and 1 of the control
 * register are esp_en and esp_gpio0, which decide whether the ESP32 is out of
 * reset — and the ESP32's GPIOs are the microSD bus. Every write here is a
 * read-modify-write that preserves them. A driver that clobbered the control
 * register on open would wake the chip that shares six wires with the card
 * this machine boots from.
 *
 * Copyright (c) 2026 Joonatan Alanampa
 */

#include <linux/console.h>
#include <linux/delay.h>
#include <linux/io.h>
#include <linux/kfifo.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/platform_device.h>
#include <linux/serial_core.h>
/* sysfs_streq(), for the esp_power attribute. Explicit because which header
 * happens to drag in string.h has changed across releases, and finding out
 * costs a full kernel build in CI. */
#include <linux/string.h>
#include <linux/tty_flip.h>

#define KOTI_ESP_DATA	0x00	/* w: tx byte.  r: pops the rx FIFO */
#define KOTI_ESP_STAT	0x04	/* r: no side effects except clearing ovf */
#define KOTI_ESP_CTRL	0x08	/* rw: bit0 esp_en, bit1 gpio0, bit2 tx irq */
#define KOTI_ESP_COUNT	0x0c	/* r: bytes ever received, free-running */

#define STAT_TX_BUSY	BIT(0)
#define STAT_RX_AVAIL	BIT(1)
#define STAT_RX_OVF	BIT(2)
#define STAT_RX_LEVEL(s)	(((s) >> 3) & 0x7f)
#define STAT_TX_LEVEL(s)	(((s) >> 10) & 0x7f)

#define CTRL_ESP_EN	BIT(0)
#define CTRL_ESP_GPIO0	BIT(1)
#define CTRL_TX_IRQ	BIT(2)
#define CTRL_STRAPS	(CTRL_ESP_EN | CTRL_ESP_GPIO0)

#define KOTI_ESP_FIFO	64
#define KOTI_ESP_BAUD	115200

#define KOTI_ESP_NR	1
#define KOTI_ESP_MAJOR	0	/* dynamic */

static struct uart_port koti_esp_port;

/*
 * Preserve the straps. See the warning at the top: bits 0-1 decide whether a
 * chip that shares the microSD bus is running, and they are not this driver's
 * to change.
 */
static void koti_esp_set_txirq(struct uart_port *port, bool on)
{
	u32 ctrl = readl(port->membase + KOTI_ESP_CTRL) & CTRL_STRAPS;

	if (on)
		ctrl |= CTRL_TX_IRQ;
	writel(ctrl, port->membase + KOTI_ESP_CTRL);
}

static unsigned int koti_esp_tx_empty(struct uart_port *port)
{
	u32 stat = readl(port->membase + KOTI_ESP_STAT);

	return (stat & STAT_TX_BUSY) ? 0 : TIOCSER_TEMT;
}

/*
 * There are no modem lines on this link — four wires and two of them are
 * ground and power on the ESP32's side. Reporting carrier, DSR and CTS as
 * permanently asserted is what lets pppd and getty open the port instead of
 * waiting for a carrier that no wire can ever provide.
 */
static unsigned int koti_esp_get_mctrl(struct uart_port *port)
{
	return TIOCM_CAR | TIOCM_DSR | TIOCM_CTS;
}

static void koti_esp_set_mctrl(struct uart_port *port, unsigned int mctrl) { }

static void koti_esp_stop_tx(struct uart_port *port)
{
	koti_esp_set_txirq(port, false);
}

static void koti_esp_stop_rx(struct uart_port *port)
{
	/*
	 * There is no way to mask the receiver in the gateware, and adding one
	 * would be worse than this: the FIFO would still fill and overrun
	 * silently. The interrupt handler simply drops what arrives while the
	 * port is shut down, which is what stop_rx means to the layer above.
	 */
}

/* Push as much as the FIFO will take. Returns with the tx interrupt armed
 * only if there is still something left to send — see the comment in
 * esp_uart.sv about why an always-on "there is room" interrupt would starve
 * userspace.
 */
static void koti_esp_tx_chars(struct uart_port *port)
{
	/*
	 * ⚠️ THE CALLER DECLARES `ch`. uart_port_tx() takes it as the NAME of a
	 * variable it assigns into — `(ch) = __port->x_char;` inside the macro —
	 * not as a value. Omitting it fails with "'ch' undeclared" pointing at
	 * the macro expansion, which reads like a kernel header problem and is
	 * not. Every in-tree user does the same.
	 */
	u8 ch;

	/*
	 * uart_port_tx() is the 6.x helper: it handles the x_char case, the
	 * stopped case, pops from the kfifo while the condition holds, and
	 * calls ops->stop_tx() when it runs dry — which is our clear-the-
	 * interrupt path. Hand-rolling this loop is how drivers end up with
	 * subtly wrong x_char or wakeup behaviour.
	 */
	uart_port_tx(port, ch,
		     STAT_TX_LEVEL(readl(port->membase + KOTI_ESP_STAT))
			     < KOTI_ESP_FIFO,
		     writel(ch, port->membase + KOTI_ESP_DATA));

	/*
	 * If the loop stopped because the HARDWARE filled rather than because
	 * we ran out of data, ask to be woken when there is room. Without this
	 * the remainder of a frame sits in the kfifo for ever: nothing else
	 * will call us back, since the only other caller is this interrupt.
	 */
	if (!kfifo_is_empty(&port->state->port.xmit_fifo))
		koti_esp_set_txirq(port, true);
}

static void koti_esp_start_tx(struct uart_port *port)
{
	koti_esp_tx_chars(port);
}

/*
 * Drain the whole FIFO in one visit. The level is read ONCE and used as a
 * count: asking "is there another byte" per byte would double the MMIO
 * traffic on a 25 MHz machine, and the level exists precisely so it does not
 * have to.
 */
static void koti_esp_rx_chars(struct uart_port *port)
{
	u32 stat = readl(port->membase + KOTI_ESP_STAT);
	unsigned int n = STAT_RX_LEVEL(stat);

	if (stat & STAT_RX_OVF) {
		/*
		 * The FIFO refused bytes. Recording it is the whole reason the
		 * flag exists: a link that quietly loses a byte presents as a
		 * protocol that mysteriously fails checksums.
		 */
		port->icount.overrun++;
		dev_warn_ratelimited(port->dev, "receive overrun\n");
	}

	while (n--) {
		u32 v = readl(port->membase + KOTI_ESP_DATA);

		port->icount.rx++;
		if (!uart_handle_sysrq_char(port, v & 0xff))
			tty_insert_flip_char(&port->state->port, v & 0xff,
					     TTY_NORMAL);
	}

	tty_flip_buffer_push(&port->state->port);
}

static irqreturn_t koti_esp_irq(int irq, void *dev_id)
{
	struct uart_port *port = dev_id;
	u32 stat;

	uart_port_lock(port);

	stat = readl(port->membase + KOTI_ESP_STAT);
	if (stat & STAT_RX_AVAIL)
		koti_esp_rx_chars(port);

	/*
	 * The transmit half shares the line, so a wake for either reason lands
	 * here. Refilling unconditionally is safe and saves reading the control
	 * register to find out which it was.
	 */
	koti_esp_tx_chars(port);

	uart_port_unlock(port);
	return IRQ_HANDLED;
}

static int koti_esp_startup(struct uart_port *port)
{
	int ret;

	ret = request_irq(port->irq, koti_esp_irq, 0, "koti_esp", port);
	if (ret)
		return ret;

	/* Leave the straps exactly as they are; only our own bit is ours. */
	koti_esp_set_txirq(port, false);
	return 0;
}

static void koti_esp_shutdown(struct uart_port *port)
{
	koti_esp_set_txirq(port, false);
	free_irq(port->irq, port);
}

static void koti_esp_set_termios(struct uart_port *port,
				 struct ktermios *termios,
				 const struct ktermios *old)
{
	unsigned long flags;

	/*
	 * ⚠️ THE BAUD RATE LIVES IN THE BITSTREAM. esp_uart.sv's DIV parameter
	 * is fixed at synthesis, so this cannot honour a request; it reports
	 * the truth instead. Silently accepting 9600 and running at 115200
	 * would present as garbage on both ends and read like bad wiring.
	 */
	if (tty_termios_baud_rate(termios) != KOTI_ESP_BAUD) {
		dev_info_once(port->dev,
			      "baud is fixed at %d by the gateware; ignoring the request\n",
			      KOTI_ESP_BAUD);
		tty_termios_encode_baud_rate(termios, KOTI_ESP_BAUD,
					     KOTI_ESP_BAUD);
	}

	/* 8N1 is what the hardware does; nothing else is selectable. */
	termios->c_cflag &= ~(CSIZE | PARENB | CSTOPB | CRTSCTS);
	termios->c_cflag |= CS8 | CLOCAL;

	uart_port_lock_irqsave(port, &flags);
	uart_update_timeout(port, termios->c_cflag, KOTI_ESP_BAUD);
	uart_port_unlock_irqrestore(port, flags);
}

static const char *koti_esp_type(struct uart_port *port)
{
	return "koti_esp";
}

static void koti_esp_config_port(struct uart_port *port, int flags)
{
	if (flags & UART_CONFIG_TYPE)
		port->type = PORT_UNKNOWN;
}

static int koti_esp_verify_port(struct uart_port *port,
				struct serial_struct *ser)
{
	return -EINVAL;		/* nothing here is reconfigurable */
}

static void koti_esp_release_port(struct uart_port *port) { }
static int koti_esp_request_port(struct uart_port *port) { return 0; }

static const struct uart_ops koti_esp_ops = {
	.tx_empty	= koti_esp_tx_empty,
	.set_mctrl	= koti_esp_set_mctrl,
	.get_mctrl	= koti_esp_get_mctrl,
	.stop_tx	= koti_esp_stop_tx,
	.start_tx	= koti_esp_start_tx,
	.stop_rx	= koti_esp_stop_rx,
	.startup	= koti_esp_startup,
	.shutdown	= koti_esp_shutdown,
	.set_termios	= koti_esp_set_termios,
	.type		= koti_esp_type,
	.release_port	= koti_esp_release_port,
	.request_port	= koti_esp_request_port,
	.config_port	= koti_esp_config_port,
	.verify_port	= koti_esp_verify_port,
};

/* ---- the straps, as one sysfs power state ------------------------------- */
/*
 * ⛔ WHY THIS IS ONE ATTRIBUTE AND NOT TWO BOOLEANS NAMED AFTER THE TWO BITS.
 * The strap bits are not independent, and the obvious interface is a trap:
 *
 *   - GPIO0's level AT THE INSTANT RESET IS RELEASED is what selects between
 *     booting the ESP32's own flash and entering its serial download mode.
 *     It is a sampled strap, not a running control.
 *   - The control register resets to 0 and ulx3s.lpf pulls `wifi_gpio0` DOWN,
 *     so GPIO0 starts LOW.
 *
 * ⇒ `echo 1 > esp_en` — the first thing anybody would ever type — releases
 * reset with GPIO0 low and boots the chip into serial download mode, where it
 * says nothing at 115200 and is indistinguishable from a dead link, a wrong
 * pin site or a broken receiver. Naming the states instead of the bits is what
 * stops that from being the default outcome of the obvious command.
 *
 * ⚠️ EVERY TRANSITION GOES THROUGH RESET, including run -> download. Writing
 * GPIO0 while the chip is already out of reset changes nothing, because the
 * strap was sampled seconds ago; a person who typed `download` and got a
 * running MicroPython would conclude the attribute does not work.
 *
 * The order — GPIO0 first, settle, then ENABLE — and the fact that it is worth
 * settling at all are sw/esptest.c's, which is the version that was taken to
 * the bench.
 *
 * ⚠️ This is the ONLY way to wake the ESP32 from Linux, and waking it is not a
 * neutral act: its GPIOs are the microSD bus this machine boots from. That is
 * why nothing does it implicitly — not open(), not probe(), not the console.
 */
#define KOTI_ESP_SETTLE_MS	10

static void koti_esp_set_straps(struct uart_port *port, u32 straps)
{
	unsigned long flags;
	u32 ctrl;

	/*
	 * Preserve the transmit-interrupt bit for the same reason
	 * koti_esp_set_txirq() preserves the straps: clearing it under a
	 * driver that is mid-transmit strands the rest of the buffer in the
	 * kfifo for ever, since the only thing that would refill the hardware
	 * FIFO is the interrupt this bit arms.
	 */
	uart_port_lock_irqsave(port, &flags);
	ctrl = readl(port->membase + KOTI_ESP_CTRL) & CTRL_TX_IRQ;
	writel(ctrl | straps, port->membase + KOTI_ESP_CTRL);
	uart_port_unlock_irqrestore(port, flags);
}

static ssize_t esp_power_show(struct device *dev,
			      struct device_attribute *attr, char *buf)
{
	struct uart_port *port = dev_get_drvdata(dev);
	u32 ctrl = readl(port->membase + KOTI_ESP_CTRL);
	const char *state;

	if (!(ctrl & CTRL_ESP_EN))
		state = "off";
	else if (ctrl & CTRL_ESP_GPIO0)
		state = "run";
	else
		state = "download";

	return sysfs_emit(buf, "%s\n", state);
}

static ssize_t esp_power_store(struct device *dev,
			       struct device_attribute *attr,
			       const char *buf, size_t count)
{
	struct uart_port *port = dev_get_drvdata(dev);
	u32 gpio0;

	if (sysfs_streq(buf, "off")) {
		koti_esp_set_straps(port, 0);
		dev_info(dev, "ESP32 held in reset\n");
		return count;
	} else if (sysfs_streq(buf, "run")) {
		gpio0 = CTRL_ESP_GPIO0;
	} else if (sysfs_streq(buf, "download")) {
		gpio0 = 0;
	} else {
		return -EINVAL;
	}

	/* Through reset, always — see the block comment above. */
	koti_esp_set_straps(port, 0);
	msleep(KOTI_ESP_SETTLE_MS);
	koti_esp_set_straps(port, gpio0);
	msleep(KOTI_ESP_SETTLE_MS);
	koti_esp_set_straps(port, gpio0 | CTRL_ESP_EN);

	/*
	 * Loud on purpose. This is the moment a second driver appears on the
	 * microSD bus; if the card misbehaves in the next minute, this line in
	 * dmesg is the first thing that should be suspected.
	 */
	dev_info(dev, "ESP32 released from reset in %s mode — it now shares the microSD bus\n",
		 gpio0 ? "normal boot" : "serial download");
	return count;
}
static DEVICE_ATTR_RW(esp_power);

/*
 * A free-running count of bytes ever received, straight from the gateware.
 * It answers "is anything arriving at all" without opening the port, popping a
 * byte, or disturbing whatever else is reading — which is exactly the question
 * asked when a link looks dead, and the instrument sw/esptest.c used to answer
 * it at the bench.
 */
static ssize_t esp_rx_count_show(struct device *dev,
				 struct device_attribute *attr, char *buf)
{
	struct uart_port *port = dev_get_drvdata(dev);

	return sysfs_emit(buf, "%u\n", readl(port->membase + KOTI_ESP_COUNT));
}
static DEVICE_ATTR_RO(esp_rx_count);

static struct attribute *koti_esp_attrs[] = {
	&dev_attr_esp_power.attr,
	&dev_attr_esp_rx_count.attr,
	NULL,
};
ATTRIBUTE_GROUPS(koti_esp);

static struct uart_driver koti_esp_uart_driver = {
	.owner		= THIS_MODULE,
	.driver_name	= "koti_esp",
	.dev_name	= "ttyKOTI",
	.major		= KOTI_ESP_MAJOR,
	.minor		= 0,
	.nr		= KOTI_ESP_NR,
};

static int koti_esp_probe(struct platform_device *pdev)
{
	struct uart_port *port = &koti_esp_port;
	struct resource *res;
	int irq, ret;

	port->membase = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
	if (IS_ERR(port->membase))
		return PTR_ERR(port->membase);

	irq = platform_get_irq(pdev, 0);
	if (irq < 0)
		return irq;

	port->dev	= &pdev->dev;
	port->mapbase	= res->start;
	port->irq	= irq;
	port->iotype	= UPIO_MEM;
	port->flags	= UPF_BOOT_AUTOCONF;
	port->ops	= &koti_esp_ops;
	port->fifosize	= KOTI_ESP_FIFO;
	port->line	= 0;
	port->type	= PORT_UNKNOWN;
	port->uartclk	= KOTI_ESP_BAUD * 16;

	/* What the sysfs attributes below reach the hardware through. */
	platform_set_drvdata(pdev, port);

	ret = uart_add_one_port(&koti_esp_uart_driver, port);
	if (ret)
		return ret;

	/*
	 * Say the thing a person needs to know, once, in the boot log: the port
	 * exists and the ESP32 on the other end of it is still held in reset.
	 * Somebody reading "ttyKOTI0" in dmesg will otherwise assume there is a
	 * device listening.
	 */
	dev_info(&pdev->dev,
		 "koti ESP32 link on irq %d, %d baud, %d-byte FIFOs; ESP32 is %s\n",
		 irq, KOTI_ESP_BAUD, KOTI_ESP_FIFO,
		 (readl(port->membase + KOTI_ESP_CTRL) & CTRL_ESP_EN)
			? "RUNNING" : "held in reset");
	return 0;
}

static void koti_esp_remove(struct platform_device *pdev)
{
	uart_remove_one_port(&koti_esp_uart_driver, &koti_esp_port);
}

static const struct of_device_id koti_esp_of_match[] = {
	{ .compatible = "koti,esp-uart-1.0" },
	{ }
};
MODULE_DEVICE_TABLE(of, koti_esp_of_match);

static struct platform_driver koti_esp_platform_driver = {
	.probe	= koti_esp_probe,
	.remove	= koti_esp_remove,
	.driver	= {
		.name		= "koti_esp",
		.of_match_table	= koti_esp_of_match,
		/*
		 * driver->dev_groups, not device_add_group() in probe: the core
		 * adds these only after probe() has returned success, so the
		 * drvdata the attributes dereference is always set, and it
		 * removes them for us on unbind.
		 */
		.dev_groups	= koti_esp_groups,
	},
};

static int __init koti_esp_init(void)
{
	int ret = uart_register_driver(&koti_esp_uart_driver);

	if (ret)
		return ret;

	ret = platform_driver_register(&koti_esp_platform_driver);
	if (ret)
		uart_unregister_driver(&koti_esp_uart_driver);
	return ret;
}

static void __exit koti_esp_exit(void)
{
	platform_driver_unregister(&koti_esp_platform_driver);
	uart_unregister_driver(&koti_esp_uart_driver);
}

module_init(koti_esp_init);
module_exit(koti_esp_exit);

MODULE_DESCRIPTION("Koti-1 ESP32 serial link");
MODULE_AUTHOR("Joonatan Alanampa");
MODULE_LICENSE("GPL");
