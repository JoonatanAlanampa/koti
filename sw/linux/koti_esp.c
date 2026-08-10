// SPDX-License-Identifier: GPL-2.0
/*
 * koti_esp.c — a serial driver for src/esp_uart.sv, koti's link to the
 * onboard ESP32. This is what turns an MMIO register block into
 * /dev/ttyKOTI0, and it is the layer everything else in PLAN item 11 stands
 * on: a line discipline (SLIP or PPP) can only be attached to a tty, and a
 * userspace AT-command client can only open a device node.
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
#include <linux/io.h>
#include <linux/kfifo.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/platform_device.h>
#include <linux/serial_core.h>
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
