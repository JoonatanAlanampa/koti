// SPDX-License-Identifier: GPL-2.0
/*
 * koti_i2c.c — koti's I2C bus, which is two bits in a register.
 *
 * PLAN item 28. src/i2c_bit.sv gives Linux one 32-bit word: two open-drain
 * drive bits going out, two pin levels coming back. Everything that makes that
 * a bus — START, STOP, the nine clocks of a byte, the acknowledge, the
 * repeated START a register read needs, recovery from a slave left mid-byte —
 * is `i2c-algo-bit`, which has been in the kernel since 1995 and runs the
 * bit-banged busses of a very large number of graphics cards.
 *
 * ⭐ SO THIS FILE IS FOUR CALLBACKS AND A PROBE, AND THAT IS THE POINT. The
 * protocol lives on the side of the machine where a bug costs a file copy
 * rather than a `fujprog -j flash` with the board on the bench — see the
 * header of src/i2c_bit.sv for the whole argument. What is left here is the
 * two things only koti knows: where the register is, and that it is
 * open-drain.
 *
 * ⛔ THE SHADOW COPY IS LOAD-BEARING. Bits [1:0] of the register read the PIN,
 * not the drive, so a read-modify-write to change one line would latch the far
 * end's pull-down into our own drive register and never release it. The two
 * `bool`s below are the drive state; nothing here ever reads the register to
 * decide what to write. That is not an optimisation, it is the difference
 * between a working bus and one that wedges the first time a slave
 * acknowledges — which is the ninth clock of the very first byte.
 *
 * WHAT IS ON THE BUS. The DS3231 module at 0x68, driven by mainline
 * rtc-ds1307.c (compatible "maxim,ds3231"), and — on the common ZS-042 board —
 * an AT24C32 EEPROM at 0x57 that nothing here claims. `i2cdetect -y 0` from
 * the rootfs shows both; busybox already ships it, so no userspace change was
 * needed to be able to look.
 *
 * Copyright (c) 2026 Joonatan Alanampa
 */
/* Spelled out rather than leaned on: BIT(), IS_ERR() and strscpy() all arrive
 * transitively through i2c.h today, and a driver that compiles only because of
 * somebody else's include is one header cleanup away from not compiling. This
 * one cannot be built on this machine at all — the host toolchain is bare-metal
 * newlib — so its first compile is a ten-minute CI round trip.
 */
#include <linux/bits.h>
#include <linux/err.h>
#include <linux/i2c.h>
#include <linux/i2c-algo-bit.h>
#include <linux/io.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/platform_device.h>
#include <linux/string.h>

/* The one register. See src/i2c_bit.sv. */
#define KOTI_I2C_LINES		0x00
#define KOTI_I2C_SCL_PIN	BIT(0)	/* read: the pad. write: 1 = release */
#define KOTI_I2C_SDA_PIN	BIT(1)
#define KOTI_I2C_SCL_DRV	BIT(2)	/* read-back of what was written */
#define KOTI_I2C_SDA_DRV	BIT(3)
#define KOTI_I2C_SQW_PIN	BIT(4)	/* DS3231 INT/SQW, unused today */
#define KOTI_I2C_SIG_SHIFT	8
#define KOTI_I2C_SIG		0x693263	/* ASCII "i2c" */

/*
 * Half a bit period, in microseconds. 5 us is i2c-algo-bit's documented
 * minimum for standard mode and would cap the bus at 100 kHz — but nothing
 * here gets anywhere near that ceiling, because every edge is an MMIO store
 * from a 25 MHz core and the real rate lands well below it. That is fine and
 * not a compromise: I2C has no minimum clock rate, and the DS3231 is static
 * CMOS with no bus timeout, so a slow master is a correct one.
 *
 * ⚠️ Do not "tune" this down. The delay is not what makes the bus slow.
 */
#define KOTI_I2C_UDELAY		5

struct koti_i2c {
	void __iomem		*base;
	struct i2c_adapter	adap;
	struct i2c_algo_bit_data bit;
	/*
	 * Per instance, not a file-scope static. koti has exactly one of these
	 * busses and always will, but a shared mutable struct that is correct
	 * only while that stays true is the kind of thing that is discovered
	 * years later by the second instance.
	 */
	struct i2c_bus_recovery_info rinfo;
	/* The drive state. Never read back from the register — see the header. */
	bool			scl_hi;
	bool			sda_hi;
};

static void koti_i2c_apply(struct koti_i2c *ki)
{
	writel((ki->scl_hi ? KOTI_I2C_SCL_PIN : 0) |
	       (ki->sda_hi ? KOTI_I2C_SDA_PIN : 0),
	       ki->base + KOTI_I2C_LINES);
}

/*
 * `state` is the LEVEL the caller wants on the wire, and 1 means "let it go
 * high", never "drive it high". The hardware cannot drive high at all, which
 * is what makes it safe to be wrong about this — but the naming matters,
 * because a reader who thinks these push the line is a reader who will later
 * "fix" the hardware to match.
 */
static void koti_i2c_setscl(void *data, int state)
{
	struct koti_i2c *ki = data;

	ki->scl_hi = !!state;
	koti_i2c_apply(ki);
}

static void koti_i2c_setsda(void *data, int state)
{
	struct koti_i2c *ki = data;

	ki->sda_hi = !!state;
	koti_i2c_apply(ki);
}

static int koti_i2c_getscl(void *data)
{
	struct koti_i2c *ki = data;

	return !!(readl(ki->base + KOTI_I2C_LINES) & KOTI_I2C_SCL_PIN);
}

static int koti_i2c_getsda(void *data)
{
	struct koti_i2c *ki = data;

	return !!(readl(ki->base + KOTI_I2C_LINES) & KOTI_I2C_SDA_PIN);
}

/*
 * Bus recovery, and it is the datasheet's own procedure rather than a generic
 * gesture. DS3231 datasheet, "Address Map":
 *
 *   "If a microcontroller connected to the DS3231 resets because of a loss of
 *    VCC or other event, it is possible that the microcontroller and DS3231
 *    I2C communications could become unsynchronized... the DS3231 I2C
 *    interface may be placed into a known state by toggling SCL until SDA is
 *    observed to be at a high level. At that point the microcontroller should
 *    pull SDA low while SCL is high, generating a START condition."
 *
 * That is exactly what i2c_generic_scl_recovery() does. It matters on koti
 * specifically: the FPGA's reset does not reset the RTC, so a reboot in the
 * middle of a register read leaves a slave still clocking out a byte and
 * holding SDA down. Without this the bus would come up dead and stay dead
 * until the RTC lost power — which, with a battery on it, is never.
 */
/*
 * The recovery callbacks take the adapter, not our private pointer, so they
 * are thin wrappers over the bit-banging ones above rather than duplicates.
 */
static void koti_i2c_rec_setscl(struct i2c_adapter *adap, int state)
{
	struct i2c_algo_bit_data *bit = adap->algo_data;

	koti_i2c_setscl(bit->data, state);
}

static void koti_i2c_rec_setsda(struct i2c_adapter *adap, int state)
{
	struct i2c_algo_bit_data *bit = adap->algo_data;

	koti_i2c_setsda(bit->data, state);
}

static int koti_i2c_rec_getscl(struct i2c_adapter *adap)
{
	struct i2c_algo_bit_data *bit = adap->algo_data;

	return koti_i2c_getscl(bit->data);
}

static int koti_i2c_rec_getsda(struct i2c_adapter *adap)
{
	struct i2c_algo_bit_data *bit = adap->algo_data;

	return koti_i2c_getsda(bit->data);
}

static int koti_i2c_probe(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	struct koti_i2c *ki;
	u32 reg;
	int ret;

	ki = devm_kzalloc(dev, sizeof(*ki), GFP_KERNEL);
	if (!ki)
		return -ENOMEM;

	ki->base = devm_platform_ioremap_resource(pdev, 0);
	if (IS_ERR(ki->base))
		return PTR_ERR(ki->base);

	/*
	 * ⭐ THE SIGNATURE CHECK, AND IT ANSWERS THE ONE QUESTION A BRING-UP
	 * SESSION ACTUALLY HAS. An MMIO window koti does not decode is not read
	 * as zero — the access falls through to the flash half of the map and
	 * returns whatever is stored there. So "is the I2C block in this
	 * bitstream" cannot be answered by looking for a plausible value; it
	 * needs a value nothing else would produce. src/i2c_bit.sv returns
	 * ASCII "i2c" in the top 24 bits.
	 *
	 * ⚠️ It should be impossible to fail: the devicetree that creates this
	 * device lives in the M-mode firmware, which is baked into the same
	 * bitstream as the block. The check costs one read at boot and turns
	 * that reasoning into an assertion, which is worth more than the
	 * reasoning.
	 */
	reg = readl(ki->base + KOTI_I2C_LINES);
	if ((reg >> KOTI_I2C_SIG_SHIFT) != KOTI_I2C_SIG) {
		dev_err(dev,
			"no I2C block here: read %08x, expected the \"i2c\" signature %06x in the top 24 bits\n",
			reg, KOTI_I2C_SIG);
		return -ENODEV;
	}

	/*
	 * Release both lines before anything else can touch them. The fabric
	 * register already resets released, so this is about the OTHER reset:
	 * a warm reboot of the CPU leaves the block's registers alone, and a
	 * machine rebooted mid-transfer would come up still holding SCL down.
	 */
	ki->scl_hi = true;
	ki->sda_hi = true;
	koti_i2c_apply(ki);

	ki->bit.data = ki;
	ki->bit.setsda = koti_i2c_setsda;
	ki->bit.setscl = koti_i2c_setscl;
	ki->bit.getsda = koti_i2c_getsda;
	ki->bit.getscl = koti_i2c_getscl;
	ki->bit.udelay = KOTI_I2C_UDELAY;
	ki->bit.timeout = HZ / 10;
	/*
	 * ⛔ NOT atomic-capable. `can_do_atomic` would let the kernel use this
	 * bus with interrupts off — from a panic handler or a reboot notifier —
	 * and these callbacks call udelay() in a loop for milliseconds. koti has
	 * nothing on this bus that a dying kernel needs to write, so claiming it
	 * would buy a hang in the one situation where the machine is already in
	 * trouble.
	 */
	ki->bit.can_do_atomic = false;

	ki->rinfo.recover_bus = i2c_generic_scl_recovery;
	ki->rinfo.set_scl = koti_i2c_rec_setscl;
	ki->rinfo.get_scl = koti_i2c_rec_getscl;
	ki->rinfo.set_sda = koti_i2c_rec_setsda;
	ki->rinfo.get_sda = koti_i2c_rec_getsda;

	ki->adap.owner = THIS_MODULE;
	ki->adap.algo_data = &ki->bit;
	ki->adap.dev.parent = dev;
	/*
	 * ⚠️ WITHOUT of_node THE RTC NEVER APPEARS. The i2c core walks the
	 * adapter's devicetree children to instantiate slaves, so an adapter
	 * that registers perfectly and forgets this line gives a working bus
	 * with nothing on it — and the only symptom is a missing /dev/rtc0.
	 */
	ki->adap.dev.of_node = dev->of_node;
	ki->adap.bus_recovery_info = &ki->rinfo;
	strscpy(ki->adap.name, "koti i2c", sizeof(ki->adap.name));

	platform_set_drvdata(pdev, ki);

	ret = i2c_bit_add_bus(&ki->adap);
	if (ret)
		return dev_err_probe(dev, ret, "cannot register the I2C bus\n");

	dev_info(dev, "bit-banged I2C on %s\n", dev_name(&ki->adap.dev));
	return 0;
}

static void koti_i2c_remove(struct platform_device *pdev)
{
	struct koti_i2c *ki = platform_get_drvdata(pdev);

	i2c_del_adapter(&ki->adap);
	/* Leave the bus idle, not held. */
	ki->scl_hi = true;
	ki->sda_hi = true;
	koti_i2c_apply(ki);
}

static const struct of_device_id koti_i2c_of_match[] = {
	{ .compatible = "koti,i2c-bit-1.0" },
	{ }
};
MODULE_DEVICE_TABLE(of, koti_i2c_of_match);

static struct platform_driver koti_i2c_driver = {
	.probe = koti_i2c_probe,
	.remove = koti_i2c_remove,
	.driver = {
		.name = "koti-i2c",
		.of_match_table = koti_i2c_of_match,
	},
};
module_platform_driver(koti_i2c_driver);

MODULE_DESCRIPTION("koti I2C: two open-drain bits, and i2c-algo-bit on top");
MODULE_AUTHOR("Joonatan Alanampa");
MODULE_LICENSE("GPL");
