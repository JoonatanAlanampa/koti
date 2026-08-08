// SPDX-License-Identifier: GPL-2.0
/*
 * koticon.c — a TEXT-MODE console driver for koti's 40x30 character buffer,
 * so that Linux owns the screen instead of borrowing it from the firmware.
 *
 * PLAN.md item 9b. The input twin is koti_kbd.c (item 9): that turns keystrokes
 * into /dev/input events, and this is what gives those events somewhere to go.
 * `drivers/tty/vt/keyboard.c` is the ONLY thing in the kernel that turns input
 * events into console characters — it applies the keymap, which is what
 * `loadkeys` changes — and it feeds VTs, not `hvc0`. No VT existed on koti
 * because a VT needs a console driver to draw on, so the two halves are
 * useless apart.
 *
 * ⭐ TEXT MODE, NOT A FRAMEBUFFER, AND THAT IS THE WHOLE REASON THIS IS SMALL.
 * `fbcon` wants a linear pixel buffer to rasterise glyphs into; koti has no
 * such thing and building one would be new gateware. But koti's charbuf is
 * literally character cells in memory — 40x30 bytes, one ASCII code each —
 * which is exactly what the old `vgacon` drove. So this writes characters and
 * lets `src/vga_text.sv` and its font ROM do the rendering that already works.
 * ⛔ Do not call koti's video a framebuffer. It is not one, and reaching for
 * fbdev/DRM here would be a large project with no payoff.
 *
 * ══════════════════════════════════════════════════════════════════════════
 * ⭐ THE OWNERSHIP HANDOVER IS SOLVED BY NOT HAVING ONE.
 *
 * PLAN.md warned that this is an ownership problem and "the part that will
 * bite": the SBI firmware's `console_putchar` writes the UART *and* the
 * charbuf (sw/console.c), so if Linux also drew into that buffer the two would
 * scribble over each other, and stopping the firmware would need a protocol
 * between the kernel and M-mode that does not exist.
 *
 * It does not need one. The video hardware reads the charbuf at whatever word
 * address the `VGA_BASE` register holds — the base is a REGISTER, not a
 * constant. So this driver allocates its OWN buffer and points the hardware at
 * it. The firmware keeps writing its buffer at 0x0100_8000, harmlessly, into
 * memory nobody is displaying; Linux owns the screen from the instant that
 * register is written, with no negotiation, no new SBI call, and no change to
 * the firmware at all. Handing the screen back would be one register write.
 *
 * ⚠️ IT WRITES `VGA_BASE` AND NOTHING ELSE. `VGA_CTRL` also carries `uart_b0`,
 * which moves the UART to `uo[6]` and pairs with the SW3 DIP switch; a
 * read-modify-write of that register from here could silently move the serial
 * console, which on a bring-up bench looks like the machine dying. The
 * firmware has already enabled video by the time Linux runs.
 *
 * ⭐ COHERENCY IS FREE, AND FOR A REASON THAT WAS ARGUED ELSEWHERE. The video
 * DMA reads this buffer out of SDRAM while the CPU writes it, so a write-BACK
 * cache could hold text that never reached the screen. koti's D-cache is
 * WRITE-THROUGH precisely so that cannot happen (see src/dcache.sv), which is
 * why this driver needs no flushing, no uncached mapping and no dma_sync.
 * ⚠️ If the D-cache ever becomes write-back, this file breaks silently — text
 * would appear late or not at all — and so does the firmware's console.
 * ══════════════════════════════════════════════════════════════════════════
 *
 * WHAT IT DELIBERATELY DOES NOT DO:
 *   * colour. koti's colours are two GLOBAL registers, not per-cell attributes,
 *     so a cell carries an 8-bit character and nothing else. Attributes from
 *     the VT are dropped rather than approximated.
 *   * a hardware cursor. There is none, so the cursor is drawn in software by
 *     overwriting a cell with '_' and restoring the character underneath.
 *   * hardware scrolling. There is no scroll register, so con_scroll moves the
 *     VT's buffer and repaints the charbuf in software — see the comment there
 *     for why returning false instead does NOT work.
 */

#include <linux/console.h>
#include <linux/minmax.h>
#include <linux/consolemap.h>
#include <linux/init.h>
#include <linux/io.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/platform_device.h>
#include <linux/screen_info.h>
#include <linux/slab.h>
#include <linux/vt_buffer.h>	/* scr_memmovew / scr_memsetw */
#include <linux/vt_kern.h>

#define KOTI_COLS	40
#define KOTI_ROWS	30
#define KOTI_CELLS	(KOTI_COLS * KOTI_ROWS)

/* VGA register block, offsets as in sw/koti.h. Only BASE is written. */
#define KOTI_VGA_BASE	0x04

static u8 __iomem *koti_regs;
static u8 *koti_cb;		/* our charbuf; the hardware reads this */

/* Software-cursor state. Declared here rather than beside con_cursor because
 * every cell-writing path has to be able to invalidate it — see the comment on
 * koticon_cursor() for why a saved character goes stale. */
static bool cur_on;
static unsigned int cur_off;		/* cell index the cursor is drawn at */
static u8 cur_under;			/* the character it is covering */

#define KOTI_CURSOR_GLYPH '_'

/*
 * The hardware takes a WORD address: project.sv latches `vga_base` from
 * `d_wdata[25:2]`. The register is written with a BYTE address and the shift
 * happens in hardware, which is why this passes the physical address as-is.
 */
static void koticon_point_hardware_at(unsigned long phys)
{
	iowrite32(phys, koti_regs + KOTI_VGA_BASE);
}

static const char *koticon_startup(void)
{
	return "koti 40x30 text";
}

static void koticon_init(struct vc_data *vc, bool init)
{
	vc->vc_can_do_color = false;

	if (init) {
		vc->vc_cols = KOTI_COLS;
		vc->vc_rows = KOTI_ROWS;
	} else {
		vc_resize(vc, KOTI_COLS, KOTI_ROWS);
	}
}

static void koticon_deinit(struct vc_data *vc)
{
}

/*
 * A run of `count` cells starting at (y, x), which may wrap onto the following
 * rows — the VT layer flattened this to a linear run in 6.11.
 */
static void koticon_clear(struct vc_data *vc, unsigned int y, unsigned int x,
			  unsigned int count)
{
	unsigned int off = y * KOTI_COLS + x;

	if (off >= KOTI_CELLS)
		return;
	if (off + count > KOTI_CELLS)
		count = KOTI_CELLS - off;

	/* Lift the cursor before touching cells: if it sat inside this run, the
	 * character saved under it is about to become wrong. */
	if (cur_on && cur_off >= off && cur_off < off + count)
		cur_on = false;

	memset(koti_cb + off, ' ', count);
}

/*
 * The VT's cells are 16 bits: character in the low byte, attribute in the
 * high one. koti stores 8-bit characters and colours globally, so the
 * attribute is dropped here rather than approximated somewhere else.
 */
static void koticon_putc(struct vc_data *vc, u16 ca, unsigned int y,
			 unsigned int x)
{
	unsigned int off = y * KOTI_COLS + x;

	if (y >= KOTI_ROWS || x >= KOTI_COLS)
		return;
	if (cur_on && cur_off == off)
		cur_on = false;		/* what it saved is stale now */
	koti_cb[off] = ca & 0xff;
}

static void koticon_putcs(struct vc_data *vc, const u16 *s, unsigned int count,
			  unsigned int ypos, unsigned int xpos)
{
	unsigned int off = ypos * KOTI_COLS + xpos;

	if (off >= KOTI_CELLS)
		return;
	if (off + count > KOTI_CELLS)
		count = KOTI_CELLS - off;

	if (cur_on && cur_off >= off && cur_off < off + count)
		cur_on = false;

	while (count--)
		koti_cb[off++] = *s++ & 0xff;
}

/*
 * A SOFTWARE CURSOR, because the hardware has none and a shell without one is
 * unusable — you cannot see where you are typing.
 *
 * koti's cells carry a character and nothing else: no attribute bits, so there
 * is no "invert this cell" to ask for. The cursor is therefore drawn by
 * OVERWRITING the cell with '_' and putting the original character back when
 * it moves. That means remembering both where it is and what was underneath,
 * which is what `cur_*` below are for.
 *
 * ⚠️ The saved character can go stale: the VT can rewrite the cell under the
 * cursor without moving it (scrolling being the obvious case). Restoring
 * blindly would then paste an old character over new text. So the restore is
 * conditional — it only puts back what it saved if the cell still holds the
 * cursor glyph it drew. If anything else is there, the screen has moved on and
 * the saved byte is discarded.
 */
static void koticon_cursor_erase(void)
{
	if (!cur_on)
		return;
	if (cur_off < KOTI_CELLS && koti_cb[cur_off] == KOTI_CURSOR_GLYPH)
		koti_cb[cur_off] = cur_under;
	cur_on = false;
}

static void koticon_cursor(struct vc_data *vc, bool enable)
{
	unsigned int off;

	koticon_cursor_erase();

	if (!enable)
		return;

	off = vc->state.y * KOTI_COLS + vc->state.x;
	if (off >= KOTI_CELLS)
		return;

	cur_off = off;
	cur_under = koti_cb[off];
	koti_cb[off] = KOTI_CURSOR_GLYPH;
	cur_on = true;
}

/*
 * ⛔ RETURNING false HERE DOES NOT MEAN "the VT will scroll for me". That was
 * this driver's first assumption and it put a login prompt and a kernel message
 * on the SAME LINE of a real monitor:
 *
 *     buildroot login: _otd fs, running e2fsck
 *
 * vt.c's con_scroll() falls back to `scr_memmovew` on the VT's OWN buffer at
 * vc_origin and then returns — it never asks the driver to repaint. For vgacon
 * that is fine, because vc_origin points INTO the video memory, so moving the
 * VT buffer IS moving the screen. koticon's buffer is a separate page that the
 * raster reads by physical address, so the VT scrolled a buffer nobody
 * displays while the screen stayed exactly as it was, and every subsequent
 * line was written over the bottom row.
 *
 * So this does what fbcon's SCROLL_REDRAW case does: move and clear the VT's
 * buffer itself, repaint the affected rows into the charbuf, and return TRUE
 * to say it is handled. Returning true is what makes vt.c skip its fallback,
 * which is why the buffer maintenance below is not optional.
 *
 * Repainting the whole scrolled region rather than tracking damage is a choice
 * the size makes easy: 40x30 is 1200 bytes, so a full region repaint is a
 * memcpy-sized cost on a screen that scrolls at reading speed.
 */
static bool koticon_scroll(struct vc_data *vc, unsigned int top,
			   unsigned int bottom, enum con_scroll dir,
			   unsigned int lines)
{
	unsigned int rows = bottom - top;
	u16 *base = (u16 *)vc->vc_origin;
	unsigned int r, c, cols = min_t(unsigned int, vc->vc_cols, KOTI_COLS);

	/* Odd shapes go back to the VT: its fallback keeps its own buffer
	 * correct, and a screen that is not ours to scroll is not ours to
	 * repaint either. */
	if (!lines || lines >= rows || bottom > KOTI_ROWS)
		return false;

	/* The cursor is about to be somewhere else entirely. */
	cur_on = false;

	if (dir == SM_UP) {
		scr_memmovew(base + top * vc->vc_cols,
			     base + (top + lines) * vc->vc_cols,
			     (rows - lines) * vc->vc_size_row);
		scr_memsetw(base + (bottom - lines) * vc->vc_cols,
			    vc->vc_video_erase_char,
			    lines * vc->vc_size_row);
	} else {
		scr_memmovew(base + (top + lines) * vc->vc_cols,
			     base + top * vc->vc_cols,
			     (rows - lines) * vc->vc_size_row);
		scr_memsetw(base + top * vc->vc_cols,
			    vc->vc_video_erase_char,
			    lines * vc->vc_size_row);
	}

	for (r = top; r < bottom; r++) {
		const u16 *src = base + r * vc->vc_cols;
		u8 *dst = koti_cb + r * KOTI_COLS;

		for (c = 0; c < cols; c++)
			dst[c] = src[c] & 0xff;
	}

	return true;
}

/* true = "the console layer should repaint the whole screen for me". */
static bool koticon_switch(struct vc_data *vc)
{
	return true;
}

static bool koticon_blank(struct vc_data *vc, enum vesa_blank_mode blank,
			  bool mode_switch)
{
	if (blank == VESA_NO_BLANKING)
		return false;		/* repaint from the VT's buffer */

	cur_on = false;
	memset(koti_cb, ' ', KOTI_CELLS);
	return true;
}

static const struct consw koti_con = {
	.owner		= THIS_MODULE,
	.con_startup	= koticon_startup,
	.con_init	= koticon_init,
	.con_deinit	= koticon_deinit,
	.con_clear	= koticon_clear,
	.con_putc	= koticon_putc,
	.con_putcs	= koticon_putcs,
	.con_cursor	= koticon_cursor,
	.con_scroll	= koticon_scroll,
	.con_switch	= koticon_switch,
	.con_blank	= koticon_blank,
};

static int koticon_probe(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	unsigned long phys;
	int ret;

	koti_regs = devm_platform_ioremap_resource(pdev, 0);
	if (IS_ERR(koti_regs))
		return PTR_ERR(koti_regs);

	/*
	 * A whole page for 1200 bytes, because the hardware reads this by
	 * physical address and it must not move or be swapped. get_zeroed_page
	 * gives page alignment, which more than satisfies the register's
	 * word-address granularity.
	 */
	koti_cb = (u8 *)get_zeroed_page(GFP_KERNEL);
	if (!koti_cb)
		return -ENOMEM;

	memset(koti_cb, ' ', KOTI_CELLS);
	phys = virt_to_phys(koti_cb);

	console_lock();
	ret = do_take_over_console(&koti_con, 0, MAX_NR_CONSOLES - 1, 1);
	console_unlock();
	if (ret) {
		free_page((unsigned long)koti_cb);
		koti_cb = NULL;
		return dev_err_probe(dev, ret, "could not take over the console\n");
	}

	/*
	 * Point the raster at our buffer LAST. Until this write the firmware's
	 * charbuf is still on screen, so a failure above leaves the boot log
	 * visible rather than a blank display.
	 */
	koticon_point_hardware_at(phys);

	dev_info(dev, "koti text console %ux%u at pa %pa; the firmware keeps its own buffer\n",
		 KOTI_COLS, KOTI_ROWS, &phys);
	return 0;
}

static const struct of_device_id koticon_of_match[] = {
	{ .compatible = "koti,vga-text" },
	{ }
};
MODULE_DEVICE_TABLE(of, koticon_of_match);

static struct platform_driver koticon_driver = {
	.probe	= koticon_probe,
	.driver	= {
		.name		= "koticon",
		.of_match_table	= koticon_of_match,
		.suppress_bind_attrs = true,
	},
};
builtin_platform_driver(koticon_driver);
