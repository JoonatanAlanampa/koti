// SPDX-License-Identifier: GPL-2.0
/*
 * koti_kbd.c — a Linux input driver for koti's USB HID keyboard block.
 *
 * WHAT THIS ADDS, because koti already "has a keyboard". Until now keystrokes
 * reached Linux as CONSOLE CHARACTERS: src/usb_kbd.sv -> MMIO -> sw/usbkbd.c
 * in koti's M-mode SBI firmware -> SBI console_getchar -> hvc0. That works and
 * still works, but Linux never saw a keyboard — no /dev/input/*, no evdev, no
 * key events, and the keymap lived in the firmware where `loadkeys` could not
 * reach it. This registers a real input device, so userspace can read keys the
 * way it does on any other machine.
 *
 * ⛔ IT DOES NOT REPLACE THE CONSOLE PATH, and must not. hvc0 is a serial-style
 * console; input devices do not feed it. If this driver took the keystrokes,
 * the login prompt would stop accepting them until koti has a framebuffer
 * console Linux knows about — which it does not, because the HDMI text is
 * drawn by the FIRMWARE writing the VGA text buffer. So both consumers run:
 * the firmware reads register +0x00 and feeds hvc0, this reads +0x08 and feeds
 * evdev. That is what a PC does too — one keypress reaches the console AND
 * /dev/input/eventN.
 *
 * ⚠️ NEVER READ +0x00 FROM HERE. Both registers POP, each from its own read
 * pointer. Reading the firmware's register would eat the character your login
 * prompt was waiting for, and the symptom would be a keyboard that types into
 * applications but not into the shell.
 *
 * TAP SEMANTICS, and it is a hardware property rather than a shortcut. The
 * gateware queues PRESSES only: it diffs each HID report against the previous
 * one and enqueues keys that were not down before. Nothing reports a release.
 * So each queued keystroke is delivered as a press immediately followed by a
 * release. Consequences, all deliberate:
 *   - keys can never stick, which is the failure that would matter most;
 *   - there is no key-hold and no autorepeat (EV_REP is left off rather than
 *     enabled and lying — the input layer would happily invent a repeat for a
 *     key it thinks is still down);
 *   - chords of non-modifier keys do not exist.
 * This is the same expressiveness the console path already has. Real down/up
 * would mean queueing releases in src/usb_kbd.sv.
 *
 * MODIFIERS ARE A LEVEL, NOT A QUEUED EVENT. The gateware exposes them live in
 * register +0x04 and never queues them, so this reads them at the moment it
 * takes a keystroke and brackets the key with modifier presses and releases.
 * ⚠️ For a fast typist the level can have moved between the key going down and
 * this driver reading it — the gateware's own header says so. The fix would be
 * to widen the FIFO, not to poll harder.
 *
 * Copyright (c) 2026 Joonatan Alanampa
 */

#include <linux/input.h>
#include <linux/interrupt.h>
#include <linux/io.h>
#include <linux/mod_devicetable.h>
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/slab.h>

#define KOTI_KBD_DATA   0x08   /* R: {ovf, avail, usage[7:0]} — POPS. Ours. */
#define KOTI_KBD_STAT   0x04   /* R: {conerr, typ[1:0], modifiers[7:0]} */

#define KOTI_KBD_AVAIL  BIT(8)
#define KOTI_KBD_OVF    BIT(9)
#define KOTI_KBD_USAGE  0xFF

/* HID boot-protocol modifier bits, in the order the spec defines them. */
static const unsigned short koti_mod_keys[8] = {
	KEY_LEFTCTRL, KEY_LEFTSHIFT, KEY_LEFTALT, KEY_LEFTMETA,
	KEY_RIGHTCTRL, KEY_RIGHTSHIFT, KEY_RIGHTALT, KEY_RIGHTMETA,
};

/*
 * HID usage -> Linux keycode. This is the standard mapping (the same table
 * drivers/hid/hid-input.c calls hid_keyboard[]), truncated after the keys a
 * boot-protocol keyboard can produce.
 *
 * ⚠️ It is NOT a keymap and must not be confused with one. It says which
 * PHYSICAL KEY was pressed; which character that produces is Linux's business
 * now, which is the entire point of this driver — `loadkeys fi` finally means
 * something. The Finnish layout in sw/usbkbd.c stays where it is because the
 * FIRMWARE still has to turn usages into characters for hvc0.
 */
static const unsigned short koti_usage_to_key[] = {
	  0,   0,   0,   0,  30,  48,  46,  32,  18,  33,  34,  35,  23,  36,
	 37,  38,  50,  49,  24,  25,  16,  19,  31,  20,  22,  47,  17,  45,
	 21,  44,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  28,   1,
	 14,  15,  57,  12,  13,  26,  27,  43,  43,  39,  40,  41,  51,  52,
	 53,  58,  59,  60,  61,  62,  63,  64,  65,  66,  67,  68,  87,  88,
	 99,  70, 119, 110, 102, 104, 111, 107, 109, 106, 105, 108, 103,  69,
	 98,  55,  74,  78,  96,  79,  80,  81,  75,  76,  77,  71,  72,  73,
	 82,  83,  86, 127, 116, 117,
};

struct koti_kbd {
	void __iomem *base;
	struct input_dev *input;
	struct device *dev;
};

/*
 * Drain the queue. Level-triggered: the gateware holds the PLIC line high
 * while port 2 is non-empty, so reading until `avail` clears is what lowers
 * it. Anything that returns early here would re-enter immediately and spin.
 */
static void koti_kbd_drain(struct koti_kbd *kbd)
{
	int guard = 64;   /* the FIFO is 8 deep; this only bounds a stuck read */

	while (guard--) {
		u32 v = readl(kbd->base + KOTI_KBD_DATA);
		u32 mods, usage;
		int i;

		if (v & KOTI_KBD_OVF)
			dev_warn_ratelimited(kbd->dev,
				"keystrokes lost: this driver fell more than 8 behind\n");

		if (!(v & KOTI_KBD_AVAIL))
			return;

		usage = v & KOTI_KBD_USAGE;
		if (usage >= ARRAY_SIZE(koti_usage_to_key) ||
		    !koti_usage_to_key[usage]) {
			dev_dbg(kbd->dev, "unmapped HID usage 0x%02x\n", usage);
			continue;
		}

		/* Read the modifier LEVEL now and bracket the key with it, so
		 * userspace sees a shifted key as shift-down, key, shift-up.
		 */
		mods = readl(kbd->base + KOTI_KBD_STAT) & 0xFF;

		for (i = 0; i < 8; i++)
			if (mods & BIT(i))
				input_report_key(kbd->input, koti_mod_keys[i], 1);

		input_report_key(kbd->input, koti_usage_to_key[usage], 1);
		input_sync(kbd->input);
		input_report_key(kbd->input, koti_usage_to_key[usage], 0);

		for (i = 0; i < 8; i++)
			if (mods & BIT(i))
				input_report_key(kbd->input, koti_mod_keys[i], 0);

		input_sync(kbd->input);
	}

	dev_err_ratelimited(kbd->dev, "queue would not drain; giving up this pass\n");
}

static irqreturn_t koti_kbd_isr(int irq, void *data)
{
	koti_kbd_drain(data);
	return IRQ_HANDLED;
}

static int koti_kbd_probe(struct platform_device *pdev)
{
	struct koti_kbd *kbd;
	struct input_dev *input;
	int irq, err, i;

	kbd = devm_kzalloc(&pdev->dev, sizeof(*kbd), GFP_KERNEL);
	if (!kbd)
		return -ENOMEM;
	kbd->dev = &pdev->dev;

	kbd->base = devm_platform_ioremap_resource(pdev, 0);
	if (IS_ERR(kbd->base))
		return PTR_ERR(kbd->base);

	irq = platform_get_irq(pdev, 0);
	if (irq < 0)
		return irq;

	input = devm_input_allocate_device(&pdev->dev);
	if (!input)
		return -ENOMEM;

	input->name = "Koti USB HID keyboard";
	input->phys = "koti/input0";
	input->id.bustype = BUS_HOST;
	kbd->input = input;

	/* EV_REP is deliberately NOT set — see the header. The hardware never
	 * says a key is still down, so an autorepeat would be invented.
	 */
	__set_bit(EV_KEY, input->evbit);
	for (i = 0; i < ARRAY_SIZE(koti_usage_to_key); i++)
		if (koti_usage_to_key[i])
			__set_bit(koti_usage_to_key[i], input->keybit);
	for (i = 0; i < 8; i++)
		__set_bit(koti_mod_keys[i], input->keybit);

	err = input_register_device(input);
	if (err)
		return err;

	/* Drain anything queued before we asked for the interrupt. The line is
	 * level-triggered, so a queue that is already non-empty would otherwise
	 * fire immediately — harmless, but it would also mean the first
	 * keystrokes after boot arrived in a burst attributed to whatever
	 * modifiers happened to be held at probe time.
	 */
	koti_kbd_drain(kbd);

	err = devm_request_irq(&pdev->dev, irq, koti_kbd_isr, 0,
			       dev_name(&pdev->dev), kbd);
	if (err)
		return err;

	dev_info(&pdev->dev, "koti keyboard on irq %d; hvc0 keeps its own port\n",
		 irq);
	return 0;
}

static const struct of_device_id koti_kbd_of_match[] = {
	{ .compatible = "koti,usb-kbd-1.0" },
	{ }
};
MODULE_DEVICE_TABLE(of, koti_kbd_of_match);

static struct platform_driver koti_kbd_driver = {
	.probe = koti_kbd_probe,
	.driver = {
		.name = "koti-kbd",
		.of_match_table = koti_kbd_of_match,
	},
};
module_platform_driver(koti_kbd_driver);

MODULE_DESCRIPTION("Koti-1 USB HID keyboard input driver");
MODULE_AUTHOR("Joonatan Alanampa");
MODULE_LICENSE("GPL");
