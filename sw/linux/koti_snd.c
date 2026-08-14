// SPDX-License-Identifier: GPL-2.0
/*
 * koti_snd.c — the terminal bell, on koti's own sound block.
 *
 * WHY AN INPUT DRIVER AND NOT A SOUND DRIVER. Linux does not ring the bell
 * through ALSA. `kd_mksound()` in drivers/tty/vt/keyboard.c walks the input
 * handlers and sends EV_SND/SND_TONE to anything that claims that capability —
 * which is why the PC speaker is drivers/input/misc/pcspkr.c and not a sound
 * card. Binding here is what makes `printf '\a'`, a failed tab-completion, and
 * every program that writes a BEL audible, with no userspace at all involved
 * and nothing to configure. An ALSA device is PLAN item 21's third tier and a
 * much bigger job; this is the tier that makes the machine feel different.
 *
 * WHAT THE HARDWARE IS. src/audio_r2r.sv + vendor/audio.sv: four voices, one
 * 32-bit register each, mixed to eight bits and sigma-delta modulated onto the
 * board's 4-bit R2R ladder, which IS the 3.5 mm jack.
 *
 *   [15:0]  freq   phase increment; Hz = freq * clk / 512 / 65536
 *   [19:16] volume 0-15, 0 silent
 *   [21:20] wave   0 square, 1 triangle, 2 noise, 3 off
 *
 * ⛔ THIS DRIVER OWNS VOICE 0 AND NOTHING ELSE. Voices 1-3 are deliberately
 * left alone so `koti play` can use them from userspace through /dev/mem: a
 * bell that arrives during a tune then interrupts neither. Sharing one voice
 * between the kernel and a shell script would make each one's silence the
 * other's bug.
 *
 * ⛔ NO INTERRUPT, AND NOTHING TO SERVICE. The synth runs free once written —
 * a voice sounds until it is silenced. So there is no timer here either: the
 * VT layer already calls back with value 0 when the bell's duration expires,
 * which is precisely the "stop" this hardware needs and the only one it needs.
 *
 * Copyright (c) 2026 Joonatan Alanampa
 */
#include <linux/input.h>
#include <linux/io.h>
#include <linux/math64.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/platform_device.h>

#define KOTI_SND_VOICE0		0x00
#define KOTI_SND_FREQ_MASK	0xffffu
#define KOTI_SND_VOL_SHIFT	16
#define KOTI_SND_WAVE_SHIFT	20

/* vendor/audio.sv: one audio sample every SAMPLE_DIV clocks, 16-bit phase. */
#define KOTI_SND_SAMPLE_DIV	512u
#define KOTI_SND_PHASE_BITS	16

/*
 * ⛔ 6 OF 15, NOT 15, AND NOT 8 EITHER. The ladder swings toward 3.3 V logic
 * levels into a jack a powered speaker expects LINE LEVEL from, and the
 * speakers this was built for have no volume control — so nothing downstream
 * can undo a default that is too loud. 0644 so it is adjustable while the
 * machine runs, without a rebuild:
 *
 *     echo 4 > /sys/module/koti_snd/parameters/volume
 *
 * S99koti sets it from /mnt/koti-volume at boot, so the choice survives a
 * power cycle in the one place on this machine that does — the card.
 */
static unsigned int volume = 6;
module_param(volume, uint, 0644);
MODULE_PARM_DESC(volume, "bell volume, 0-15 (default 6)");

struct koti_snd {
	void __iomem	*base;
	u32		clk_hz;
};

/*
 * ⚠️ 64-BIT MATH ON A 32-BIT MACHINE, DELIBERATELY. inc = hz << 16 * 512 / clk;
 * at 20 kHz that numerator is 6.7e11, so a u32 intermediate silently wraps and
 * a high-pitched bell comes out as a low one. div_u64 is the cheap correct
 * answer and this path runs once per bell, not once per sample.
 */
static u32 koti_snd_inc(struct koti_snd *snd, unsigned int hz)
{
	u64 num = (u64)hz << KOTI_SND_PHASE_BITS;

	num *= KOTI_SND_SAMPLE_DIV;
	num = div_u64(num, snd->clk_hz);

	/* A phase increment of zero is silence, and one that wraps the 16-bit
	 * accumulator is an alias — a "20 kHz" bell that comes out as a growl.
	 * Refuse both by clamping; the caller's alternative is a wrong note.
	 */
	if (num > KOTI_SND_FREQ_MASK)
		num = KOTI_SND_FREQ_MASK;

	return (u32)num;
}

static int koti_snd_event(struct input_dev *dev, unsigned int type,
			  unsigned int code, int value)
{
	struct koti_snd *snd = input_get_drvdata(dev);
	unsigned int hz;
	u32 reg;

	if (type != EV_SND)
		return -EINVAL;

	switch (code) {
	case SND_BELL:
		hz = value ? 1000 : 0;
		break;
	case SND_TONE:
		hz = value;
		break;
	default:
		return -EINVAL;
	}

	if (!hz) {
		/* Volume 0 is silence whatever the other fields say, and it
		 * leaves the DAC at mid-scale rather than stepping it, so the
		 * end of a bell is not itself a click.
		 */
		writel(0, snd->base + KOTI_SND_VOICE0);
		return 0;
	}

	reg = koti_snd_inc(snd, hz)
	    | ((volume & 0xf) << KOTI_SND_VOL_SHIFT)
	    | (0u << KOTI_SND_WAVE_SHIFT);		/* square: a bell is */
	writel(reg, snd->base + KOTI_SND_VOICE0);
	return 0;
}

static int koti_snd_probe(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	struct input_dev *input;
	struct koti_snd *snd;

	snd = devm_kzalloc(dev, sizeof(*snd), GFP_KERNEL);
	if (!snd)
		return -ENOMEM;

	snd->base = devm_platform_ioremap_resource(pdev, 0);
	if (IS_ERR(snd->base))
		return PTR_ERR(snd->base);

	snd->clk_hz = 25000000;
	of_property_read_u32(dev->of_node, "clock-frequency", &snd->clk_hz);
	if (!snd->clk_hz)
		return -EINVAL;

	input = devm_input_allocate_device(dev);
	if (!input)
		return -ENOMEM;

	input->name = "koti sound";
	input->phys = "koti/audio0";
	input->id.bustype = BUS_HOST;
	input->dev.parent = dev;
	input->evbit[0] = BIT_MASK(EV_SND);
	input->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
	input->event = koti_snd_event;
	input_set_drvdata(input, snd);

	/* Silence before anything can ring it: the fabric registers survive a
	 * warm reset of the CPU, so a machine rebooted mid-bell would come up
	 * with a voice still sounding and no software that knows why.
	 */
	writel(0, snd->base + KOTI_SND_VOICE0);

	return input_register_device(input);
}

static const struct of_device_id koti_snd_of_match[] = {
	{ .compatible = "koti,audio-1.0" },
	{ }
};
MODULE_DEVICE_TABLE(of, koti_snd_of_match);

static struct platform_driver koti_snd_driver = {
	.probe = koti_snd_probe,
	.driver = {
		.name = "koti-snd",
		.of_match_table = koti_snd_of_match,
	},
};
module_platform_driver(koti_snd_driver);

MODULE_DESCRIPTION("koti sound block: the terminal bell on the ULX3S jack");
MODULE_AUTHOR("Joonatan Alanampa");
MODULE_LICENSE("GPL");
