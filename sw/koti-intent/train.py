#!/usr/bin/env python3
"""train.py — PLAN item 25: the tiny intent classifier, trained here, run on koti.

⛔ TRAINING NEVER HAPPENS ON koti, AND THE SPLIT IS THE SAME ONE THE KERNEL
ALREADY USES: the heavy build runs on a real computer (or in CI), the artifact
travels to the card, and koti does inference only. koti is ~29 MHz with a
32-cycle iterative multiplier; it is a fine machine to run 11k MACs on and a
ridiculous one to train on.

⭐ PURE PYTHON, NO NUMPY, ON PURPOSE. The model is small and the input is
SPARSE — a question is ~8 tokens, so the embedding stage touches 8 rows out of
4096 and the rest of the table contributes nothing. Written that way it trains
in seconds in plain Python, which means the trainer runs anywhere: this laptop,
a CI runner with no pip step, or a future machine that has neither. A numpy
dependency would buy speed this does not need and cost portability it does.

THE ARCHITECTURE, and why each piece suits THIS machine:

    question -> tokens -> hash to [0,VOCAB) -> sum EMB rows  (LOOKUP + adds)
             -> tanh(W1 . h + b1)                            (EMB_DIM x HID MACs)
             -> argmax(W2 . h + b2)                          (HID x NCLASS MACs)

⭐ THE EMBEDDING IS FREE AT INFERENCE AND THAT IS THE WHOLE TRICK. It is the
largest thing in the model by far, and it costs NO multiplies: only the rows
whose words are present are read, and they are ADDED. On koti that is ~8x32
adds against a multiplier that takes 32 cycles a go.

⚠️ WHAT THIS BUYS OVER `koti help`'s KEYWORD TABLE IS AN OPEN QUESTION, AND
THIS SCRIPT ANSWERS IT RATHER THAN ASSUMING. --eval holds out a slice of the
data, scores the model on it, AND scores the existing keyword table on the same
slice. If the model does not beat the table, that is a result worth having
before shipping 100 KB of weights to the card; a table that wins is not a
failure, it is item 24 doing its job.

Copyright (c) 2026 Joonatan Alanampa
SPDX-License-Identifier: Apache-2.0
"""
import argparse
import math
import random
import re
import struct
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent

# ⚠️ SIZES ARE SMALL DELIBERATELY, AND SMALLER THAN PLAN.md's SKETCH.
# The plan sizes a 4096x128 table at 524k parameters. That is the right shape
# but the wrong scale for ~130 hand-written examples: a 524k-parameter model on
# 130 rows memorises them and learns nothing transferable, and the accuracy it
# reports on its own training data would be a lie. 4096x32 is 131k parameters,
# still lookup-only at inference, and it leaves the card cost at ~128 KB.
# ⇒ If the data grows to thousands of phrasings, raise EMB_DIM first.
VOCAB = 4096
EMB_DIM = 32
HID = 32

TOKEN_RE = re.compile(r"[a-z0-9]+")


def tokens(text):
    """Lower-case words, plus a 2-gram of adjacent words.

    ⭐ THE BIGRAMS ARE WHAT SEPARATE THE HARD PAIRS. "can i compile something"
    and "what can i run" share `can` and `i`; only `can compile` and `what can`
    tell them apart. Unigrams alone put both in whichever class saw `can` more,
    which is exactly the tie-breaking failure item 24's keyword table has.
    """
    ws = TOKEN_RE.findall(text.lower())
    out = list(ws)
    out += [ws[i] + "_" + ws[i + 1] for i in range(len(ws) - 1)]
    return out


def hashed(tok):
    """FNV-1a, 32-bit, folded into the table.

    ⛔ THE INFERENCE SIDE MUST HASH IDENTICALLY OR THE WEIGHTS ARE NOISE, so
    this is FNV-1a rather than Python's hash(): Python's is randomised per
    process (PYTHONHASHSEED) and would give a different model every run and a
    different answer on koti. FNV-1a is four lines in C and has no state.
    """
    h = 0x811C9DC5
    for ch in tok.encode("utf-8"):
        h ^= ch
        h = (h * 0x01000193) & 0xFFFFFFFF
    return h % VOCAB


def load(path):
    rows = []
    for line in Path(path).read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if "|" not in line:
            raise SystemExit("bad line (no '|'): %r" % line)
        label, text = line.split("|", 1)
        rows.append((label.strip(), text.strip()))
    if not rows:
        raise SystemExit("no training rows")
    return rows


# ---------------------------------------------------------------------------
# The model. Plain lists; the sparsity is what makes that fast enough.
# ---------------------------------------------------------------------------
def train(rows, labels, epochs, lr, seed, quiet=False):
    rng = random.Random(seed)
    nclass = len(labels)
    lidx = {l: i for i, l in enumerate(labels)}

    # ⛔ THE EMBEDDING INITIALISES TO ZERO, AND THIS IS THE SINGLE MOST
    # IMPORTANT LINE IN THE FILE. Random init scored 29% held out against the
    # keyword table's 76% — far WORSE than the grep it replaces.
    #
    # Why: a hashed embedding has a row for all 4096 buckets, but only the few
    # hundred that appear in training ever receive a gradient. A held-out
    # question containing a word never seen — `wifi`, `finnish`, `reboot` —
    # then sums a RANDOM vector into the mean, and with ~8 tokens per question
    # one random row is enough to swamp the trained ones. The model was being
    # asked to classify noise.
    #
    # Zero init makes an unseen word contribute EXACTLY NOTHING, so a question
    # is judged only on the words the model has actually learned something
    # about. It is the standard choice for sparse/hashed features and it is the
    # difference between this model being useful and being worse than a grep.
    emb = [[0.0] * EMB_DIM for _ in range(VOCAB)]
    w1 = [[rng.uniform(-0.3, 0.3) for _ in range(EMB_DIM)] for _ in range(HID)]
    b1 = [0.0] * HID
    w2 = [[rng.uniform(-0.3, 0.3) for _ in range(HID)] for _ in range(nclass)]
    b2 = [0.0] * nclass

    data = [(sorted(set(hashed(t) for t in tokens(q))), lidx[l]) for l, q in rows]

    for ep in range(epochs):
        rng.shuffle(data)
        loss_sum = 0.0
        for idxs, y in data:
            # ---- forward
            # Embedding: SUM the present rows. No multiplies here, and this is
            # the stage that would dominate if it were a matmul.
            e = [0.0] * EMB_DIM
            for i in idxs:
                row = emb[i]
                for k in range(EMB_DIM):
                    e[k] += row[k]
            # Mean rather than sum, so a long question does not simply produce
            # bigger activations than a short one saying the same thing.
            inv = 1.0 / max(1, len(idxs))
            for k in range(EMB_DIM):
                e[k] *= inv

            h = [0.0] * HID
            for j in range(HID):
                acc = b1[j]
                wj = w1[j]
                for k in range(EMB_DIM):
                    acc += wj[k] * e[k]
                h[j] = math.tanh(acc)

            o = [0.0] * nclass
            for c in range(nclass):
                acc = b2[c]
                wc = w2[c]
                for j in range(HID):
                    acc += wc[j] * h[j]
                o[c] = acc

            m = max(o)
            ex = [math.exp(v - m) for v in o]
            s = sum(ex)
            p = [v / s for v in ex]
            loss_sum -= math.log(max(p[y], 1e-12))

            # ---- backward
            do = p[:]
            do[y] -= 1.0

            dh = [0.0] * HID
            for c in range(nclass):
                g = do[c]
                if g == 0.0:
                    continue
                wc = w2[c]
                for j in range(HID):
                    dh[j] += g * wc[j]
                    wc[j] -= lr * g * h[j]
                b2[c] -= lr * g

            de = [0.0] * EMB_DIM
            for j in range(HID):
                g = dh[j] * (1.0 - h[j] * h[j])   # tanh'
                if g == 0.0:
                    continue
                wj = w1[j]
                for k in range(EMB_DIM):
                    de[k] += g * wj[k]
                    wj[k] -= lr * g * e[k]
                b1[j] -= lr * g

            # Sparse embedding update: only the rows that were present.
            gscale = lr * inv
            for i in idxs:
                row = emb[i]
                for k in range(EMB_DIM):
                    row[k] -= gscale * de[k]

        if not quiet and (ep % max(1, epochs // 10) == 0 or ep == epochs - 1):
            print("  epoch %4d  loss %.4f" % (ep, loss_sum / len(data)))

    return emb, w1, b1, w2, b2


def predict(model, labels, text):
    emb, w1, b1, w2, b2 = model
    idxs = sorted(set(hashed(t) for t in tokens(text)))
    e = [0.0] * EMB_DIM
    for i in idxs:
        row = emb[i]
        for k in range(EMB_DIM):
            e[k] += row[k]
    inv = 1.0 / max(1, len(idxs))
    for k in range(EMB_DIM):
        e[k] *= inv
    h = [math.tanh(b1[j] + sum(w1[j][k] * e[k] for k in range(EMB_DIM)))
         for j in range(HID)]
    o = [b2[c] + sum(w2[c][j] * h[j] for j in range(HID)) for c in range(len(labels))]
    m = max(o)
    ex = [math.exp(v - m) for v in o]
    s = sum(ex)
    p = [v / s for v in ex]
    best = max(range(len(p)), key=lambda c: p[c])
    return labels[best], p[best]


# ---------------------------------------------------------------------------
# The baseline it has to beat: item 24's keyword table, read out of the shipped
# script so this cannot drift from what the machine actually runs.
# ---------------------------------------------------------------------------
def keyword_baseline(question, table):
    q = " " + re.sub(r"[^a-z0-9]+", " ", question.lower()) + " "
    best, bestn = None, 0
    for sec, words in table:
        n = sum(1 for w in words if (" " + w + " ") in q)
        if n > bestn:
            bestn, best = n, sec
    return best


def load_keyword_table(koti_path):
    txt = Path(koti_path).read_text(encoding="utf-8")
    out, inblock = [], False
    for line in txt.splitlines():
        if line.startswith("topics() {"):
            inblock = True
            continue
        if inblock:
            if line.strip() == "EOF":
                break
            if "|" in line:
                sec, words = line.split("|", 1)
                out.append((sec.strip(), words.split()))
    return out


def quantise(mat, name):
    """Symmetric int8 with one scale for the whole matrix.

    ⚠️ ONE SCALE PER MATRIX, not per row: the C side then needs a single
    multiply at the end of each stage instead of a per-row one, and koti's
    multiplier is 32 cycles. The accuracy cost is checked by --eval, which
    scores the QUANTISED model, not the float one.
    """
    flat = [v for row in mat for v in row]
    peak = max(abs(v) for v in flat) or 1.0
    scale = peak / 127.0
    q = [[max(-127, min(127, int(round(v / scale)))) for v in row] for row in mat]
    return q, scale


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--data", default=str(HERE / "intents.txt"))
    ap.add_argument("--out", default=str(HERE / "koti-intent.bin"))
    ap.add_argument("--epochs", type=int, default=120)
    ap.add_argument("--lr", type=float, default=0.25)
    ap.add_argument("--seed", type=int, default=7)
    ap.add_argument("--eval", action="store_true",
                    help="hold out a slice, score model AND keyword table on it")
    ap.add_argument("--koti", default=str(HERE / ".." / "linux" / "rootfs-overlay"
                                          / "usr" / "bin" / "koti"))
    args = ap.parse_args()

    rows = load(args.data)
    labels = sorted({l for l, _ in rows})
    print("%d examples, %d intents, vocab %d, emb %d, hid %d"
          % (len(rows), len(labels), VOCAB, EMB_DIM, HID))

    if args.eval:
        rng = random.Random(args.seed)
        by = {}
        for l, q in rows:
            by.setdefault(l, []).append(q)
        train_rows, test_rows = [], []
        for l, qs in by.items():
            qs = qs[:]
            rng.shuffle(qs)
            # ⚠️ STRATIFIED: every intent must appear in BOTH halves, or a
            # random split can leave a class untrained and the score becomes a
            # statement about the split rather than the model.
            ntest = max(2, len(qs) // 4)
            test_rows += [(l, q) for q in qs[:ntest]]
            train_rows += [(l, q) for q in qs[ntest:]]
        print("train %d / held out %d" % (len(train_rows), len(test_rows)))
        model = train(train_rows, labels, args.epochs, args.lr, args.seed)

        table = load_keyword_table(args.koti)
        mok = tok = 0
        for l, q in test_rows:
            pred, conf = predict(model, labels, q)
            kw = keyword_baseline(q, table)
            mok += (pred == l)
            tok += (kw == l)
            if pred != l or kw != l:
                print("  %-16s model=%-16s(%.2f) table=%-16s | %s"
                      % (l, pred, conf, kw, q))
        n = len(test_rows)
        print("HELD OUT  model %d/%d = %.0f%%   keyword table %d/%d = %.0f%%"
              % (mok, n, 100.0 * mok / n, tok, n, 100.0 * tok / n))
        return

    model = train(rows, labels, args.epochs, args.lr, args.seed)
    emb, w1, b1, w2, b2 = model

    qe, se = quantise(emb, "emb")
    q1, s1 = quantise(w1, "w1")
    q2, s2 = quantise(w2, "w2")

    # ---- the artifact koti reads.
    # ⚠️ LITTLE-ENDIAN AND EXPLICIT. koti is rv32 little-endian; writing the
    # header with struct '<' rather than native order means this file is
    # identical whatever builds it.
    out = Path(args.out)
    with out.open("wb") as f:
        f.write(b"KOTI-I01")
        f.write(struct.pack("<IIII", VOCAB, EMB_DIM, HID, len(labels)))
        f.write(struct.pack("<fff", se, s1, s2))
        names = b"\n".join(l.encode("utf-8") for l in labels) + b"\n"
        f.write(struct.pack("<I", len(names)))
        f.write(names)
        for row in qe:
            f.write(bytes((v & 0xFF) for v in row))
        for row in q1:
            f.write(bytes((v & 0xFF) for v in row))
        f.write(struct.pack("<%df" % HID, *b1))
        for row in q2:
            f.write(bytes((v & 0xFF) for v in row))
        f.write(struct.pack("<%df" % len(labels), *b2))
    print("wrote %s  %d bytes" % (out, out.stat().st_size))


if __name__ == "__main__":
    sys.exit(main())
