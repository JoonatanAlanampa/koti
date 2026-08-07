// SPDX-License-Identifier: GPL-2.0
/*
 * koti_sd.c — a block driver for koti's microSD controller.
 *
 * WHY A CUSTOM DRIVER AT ALL. koti's SD controller is not an SDHCI, not an
 * MMC host, and not anything mainline has a driver for: it is src/sd_ctrl.sv,
 * four MMIO registers over a vendored SPI-mode engine. Mainline no more
 * recognises it than it recognises koti's PS/2 word. That was known and
 * planned for — PLAN.md item 8 says the same about USB — so this is a small
 * driver rather than a disappointment.
 *
 * READ AND WRITE since 2026-08-07. The disk was read-only for one day, and not
 * by choice: the engine had CMD17 and no CMD24, so the HARDWARE could not write
 * a block at all. CMD24 was added upstream in console and re-vendored, and the
 * write path below is the software half.
 *
 * ⚠️ A WRITE IS NOT A READ WITH THE ARROWS REVERSED. After taking the data the
 * card erases and programs, holding MISO low for milliseconds, and only then
 * answers. The engine waits for that and signals completion at the same instant
 * it drops `busy` — so a write here takes far longer than a read and the
 * timeout is sized for it.
 *
 * NO INTERRUPT. sd_ctrl has no IRQ line, so a transfer is polled. That is why
 * the tag set asks for BLK_MQ_F_BLOCKING: without it ->queue_rq runs where it
 * may not sleep, and a ~400 us poll would be spent spinning with preemption
 * off. With it, cond_resched() lets the machine do something else — which on a
 * single-core 25 MHz RV32 is not a luxury.
 *
 * CAPACITY COMES FROM THE DEVICETREE. The engine never reads the card's CSD,
 * so the driver cannot ask how big the card is. `koti,sectors` says. Getting it
 * WRONG IS SAFE IN ONE DIRECTION ONLY: too small merely hides the tail of the
 * card, while too large lets the partition scanner read past the end, where the
 * engine returns an error and the block layer reports IO errors on a card that
 * is perfectly healthy.
 *
 * Copyright (c) 2026 Joonatan Alanampa
 */
#include <linux/blk-mq.h>
#include <linux/blkdev.h>
#include <linux/delay.h>
#include <linux/io.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/platform_device.h>

/* Register map — must match src/sd_ctrl.sv and sw/koti.h. */
#define KOTI_SD_CTRL	0x00	/* w: bit0 init, bit1 read, bit2 write */
#define KOTI_SD_LBA	0x04
#define KOTI_SD_DATA	0x08	/* r: next word, pointer++; w: rewind */
#define KOTI_SD_WDATA	0x10	/* w: push a word into the write buffer */
#define KOTI_SD_WREWIND	0x14	/* w: rewind the fill pointer */

#define KOTI_SD_READY	BIT(0)
#define KOTI_SD_BUSY	BIT(1)
#define KOTI_SD_ERR	BIT(2)
#define KOTI_SD_DONE	BIT(3)	/* sticky: the buffer holds a full block */

#define KOTI_SD_START_INIT	BIT(0)
#define KOTI_SD_START_RD	BIT(1)
#define KOTI_SD_START_WR	BIT(2)

#define KOTI_SD_SECTOR		512
#define KOTI_SD_WORDS		(KOTI_SD_SECTOR / 4)

/* A block read is ~400 us at 12.5 MHz; a write can legitimately take a hundred
 * milliseconds on a cheap card, because the card erases and programs before it
 * answers. One second covers both and is still BOUNDED, which is the point: a
 * card that stops answering must produce an IO error, not a machine that never
 * returns.
 */
#define KOTI_SD_IO_TIMEOUT_MS	1000
#define KOTI_SD_INIT_TIMEOUT_MS	2000

struct koti_sd {
	void __iomem		*base;
	struct gendisk		*disk;
	struct blk_mq_tag_set	tag_set;
	sector_t		sectors;
	struct mutex		lock;	/* one transfer at a time */
};

static int koti_sd_wait(struct koti_sd *sd, u32 mask, unsigned int ms)
{
	unsigned long deadline = jiffies + msecs_to_jiffies(ms);

	for (;;) {
		u32 st = readl(sd->base + KOTI_SD_CTRL);

		if (st & mask)
			return 0;
		if (time_after(jiffies, deadline))
			return -ETIMEDOUT;
		cond_resched();
	}
}

/*
 * ⚠️ POLL SD_DONE, NEVER SD_BUSY OR SD_READY. The engine signals the two
 * operations differently: init clears `ready` and sets it again at the end,
 * while a read leaves `ready` HIGH throughout and only raises `busy` — and
 * `busy` has not risen yet when the start write returns. `done` is sticky, set
 * when the block is fully in the buffer and cleared when a new transfer
 * starts. One bit, one meaning. This is written down in src/sd_ctrl.sv too,
 * because it has already been got wrong once.
 */
static int koti_sd_read_sector(struct koti_sd *sd, sector_t lba, void *dst)
{
	u32 *out = dst;
	int i, ret;

	writel((u32)lba, sd->base + KOTI_SD_LBA);
	writel(KOTI_SD_START_RD, sd->base + KOTI_SD_CTRL);

	ret = koti_sd_wait(sd, KOTI_SD_DONE, KOTI_SD_IO_TIMEOUT_MS);
	if (ret)
		return ret;
	if (readl(sd->base + KOTI_SD_CTRL) & KOTI_SD_ERR)
		return -EIO;

	writel(0, sd->base + KOTI_SD_DATA);	/* rewind the buffer pointer */
	for (i = 0; i < KOTI_SD_WORDS; i++)
		out[i] = readl(sd->base + KOTI_SD_DATA);

	return 0;
}

static int koti_sd_write_sector(struct koti_sd *sd, sector_t lba, void *src)
{
	const u32 *in = src;
	int i, ret;

	/* Fill first, start second. The controller latches nothing until the
	 * start write, so the order is not a race — but rewinding first is what
	 * makes a retry after an error land at word 0 rather than wherever the
	 * failed attempt stopped.
	 */
	writel(0, sd->base + KOTI_SD_WREWIND);
	for (i = 0; i < KOTI_SD_WORDS; i++)
		writel(in[i], sd->base + KOTI_SD_WDATA);

	writel((u32)lba, sd->base + KOTI_SD_LBA);
	writel(KOTI_SD_START_WR, sd->base + KOTI_SD_CTRL);

	ret = koti_sd_wait(sd, KOTI_SD_DONE, KOTI_SD_IO_TIMEOUT_MS);
	if (ret)
		return ret;
	/* The engine sets ERR when the card's data-response token said the block
	 * was rejected. Not checking it would report success for a write that
	 * never landed, which is the one failure a filesystem cannot survive.
	 */
	if (readl(sd->base + KOTI_SD_CTRL) & KOTI_SD_ERR)
		return -EIO;

	return 0;
}

static blk_status_t koti_sd_queue_rq(struct blk_mq_hw_ctx *hctx,
				     const struct blk_mq_queue_data *bd)
{
	struct request *rq = bd->rq;
	struct koti_sd *sd = rq->q->queuedata;
	struct req_iterator iter;
	struct bio_vec bv;
	sector_t lba = blk_rq_pos(rq);
	blk_status_t sts = BLK_STS_OK;
	int err;

	blk_mq_start_request(rq);

	/* A flush is a no-op that must still be answered: there is no write
	 * cache anywhere between here and the card, because every write waits
	 * for the card to finish programming before it returns. Failing it
	 * would make the filesystem think its data is at risk; ignoring it
	 * would hang the request.
	 */
	if (req_op(rq) == REQ_OP_FLUSH) {
		blk_mq_end_request(rq, BLK_STS_OK);
		return BLK_STS_OK;
	}

	if (req_op(rq) != REQ_OP_READ && req_op(rq) != REQ_OP_WRITE) {
		blk_mq_end_request(rq, BLK_STS_IOERR);
		return BLK_STS_OK;
	}

	mutex_lock(&sd->lock);
	rq_for_each_segment(bv, rq, iter) {
		void *buf = bvec_kmap_local(&bv);
		unsigned int off;

		/* A bio segment can span several sectors, and the controller
		 * transfers exactly one 512-byte block per command.
		 */
		for (off = 0; off < bv.bv_len; off += KOTI_SD_SECTOR) {
			if (lba >= sd->sectors) {
				sts = BLK_STS_IOERR;
				break;
			}
			err = (req_op(rq) == REQ_OP_WRITE)
				? koti_sd_write_sector(sd, lba, buf + off)
				: koti_sd_read_sector(sd, lba, buf + off);
			if (err) {
				sts = BLK_STS_IOERR;
				break;
			}
			lba++;
		}
		kunmap_local(buf);
		if (sts != BLK_STS_OK)
			break;
	}
	mutex_unlock(&sd->lock);

	blk_mq_end_request(rq, sts);
	return BLK_STS_OK;
}

static const struct blk_mq_ops koti_sd_mq_ops = {
	.queue_rq = koti_sd_queue_rq,
};

/* File scope, deliberately. gendisk keeps this POINTER for the lifetime of the
 * disk, so a compound literal inside probe() would leave it dangling the moment
 * probe returned — and the corruption would surface much later, somewhere else.
 */
static const struct block_device_operations koti_sd_fops = {
	.owner = THIS_MODULE,
};

static int koti_sd_probe(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	struct queue_limits lim = {
		.logical_block_size	= KOTI_SD_SECTOR,
		.physical_block_size	= KOTI_SD_SECTOR,
		/* One block per command, so there is nothing to gain from
		 * letting the block layer build large requests.
		 */
		.max_hw_sectors		= 8,
		.max_segments		= 1,
	};
	struct koti_sd *sd;
	u32 sectors;
	int ret;

	sd = devm_kzalloc(dev, sizeof(*sd), GFP_KERNEL);
	if (!sd)
		return -ENOMEM;
	mutex_init(&sd->lock);

	sd->base = devm_platform_ioremap_resource(pdev, 0);
	if (IS_ERR(sd->base))
		return PTR_ERR(sd->base);

	ret = of_property_read_u32(dev->of_node, "koti,sectors", &sectors);
	if (ret) {
		dev_err(dev, "missing koti,sectors — the engine cannot read the card's CSD, so its size has to be declared\n");
		return ret;
	}
	sd->sectors = sectors;

	/* The firmware has already initialised the card to load the kernel, so
	 * this normally completes at once. Re-running it is idempotent and
	 * costs a few milliseconds, and it means the driver does not depend on
	 * what the firmware happened to leave behind.
	 */
	writel(KOTI_SD_START_INIT, sd->base + KOTI_SD_CTRL);
	ret = koti_sd_wait(sd, KOTI_SD_READY | KOTI_SD_ERR,
			   KOTI_SD_INIT_TIMEOUT_MS);
	if (ret || (readl(sd->base + KOTI_SD_CTRL) & KOTI_SD_ERR)) {
		dev_err(dev, "no card, or it never answered\n");
		return -ENODEV;
	}

	sd->tag_set.ops = &koti_sd_mq_ops;
	sd->tag_set.nr_hw_queues = 1;
	sd->tag_set.queue_depth = 4;
	sd->tag_set.numa_node = NUMA_NO_NODE;
	/* BLOCKING because the transfer is polled and must be allowed to
	 * cond_resched(); see the header.
	 */
	sd->tag_set.flags = BLK_MQ_F_BLOCKING;
	sd->tag_set.cmd_size = 0;
	sd->tag_set.driver_data = sd;

	ret = blk_mq_alloc_tag_set(&sd->tag_set);
	if (ret)
		return ret;

	sd->disk = blk_mq_alloc_disk(&sd->tag_set, &lim, sd);
	if (IS_ERR(sd->disk)) {
		ret = PTR_ERR(sd->disk);
		goto out_tag_set;
	}

	/*
	 * major/first_minor/minors are deliberately LEFT AT ZERO, which
	 * blk_mq_alloc_disk() already guarantees.
	 *
	 * ⚠️ Setting `minors` alongside a zero major is a hard error, not a
	 * hint: device_add_disk() takes the `major == 0` branch, hits
	 * `WARN_ON(disk->minors)` at block/genhd.c:439 and returns -EINVAL. The
	 * first version of this driver set minors = 8 "to leave room for a
	 * partition table" and probe failed with a backtrace on real hardware.
	 *
	 * Reserving minors is not how partitions work any more anyway: with a
	 * dynamic major the kernel allocates an extended minor for the disk and
	 * another for each partition as it finds them, so kotisd1 and kotisd2
	 * appear without anything being reserved up front.
	 */
	sd->disk->fops = &koti_sd_fops;
	sd->disk->private_data = sd;
	snprintf(sd->disk->disk_name, DISK_NAME_LEN, "kotisd");
	set_capacity(sd->disk, sd->sectors);

	ret = add_disk(sd->disk);
	if (ret)
		goto out_disk;

	platform_set_drvdata(pdev, sd);
	dev_info(dev, "%u sectors (%u MiB), read-write\n",
		 sectors, sectors / 2048);
	return 0;

out_disk:
	put_disk(sd->disk);
out_tag_set:
	blk_mq_free_tag_set(&sd->tag_set);
	return ret;
}

static void koti_sd_remove(struct platform_device *pdev)
{
	struct koti_sd *sd = platform_get_drvdata(pdev);

	del_gendisk(sd->disk);
	put_disk(sd->disk);
	blk_mq_free_tag_set(&sd->tag_set);
}

static const struct of_device_id koti_sd_of_match[] = {
	{ .compatible = "koti,sd-1" },
	{ }
};
MODULE_DEVICE_TABLE(of, koti_sd_of_match);

static struct platform_driver koti_sd_driver = {
	.probe = koti_sd_probe,
	.remove = koti_sd_remove,
	.driver = {
		.name = "koti-sd",
		.of_match_table = koti_sd_of_match,
	},
};
module_platform_driver(koti_sd_driver);

MODULE_DESCRIPTION("Koti-1 microSD block driver");
MODULE_AUTHOR("Joonatan Alanampa");
MODULE_LICENSE("GPL");
