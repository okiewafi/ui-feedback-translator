#!/usr/bin/env python3
"""Validator for ui-feedback-translator.

Usage:
    validate.py --spec <spec.md> --images <img1> [<img2> ...]

Checks (v1):
  1. spec.md exists and declares `anchor: WxH` on the first content line.
  2. spec.md contains the required sections: design tokens, components,
     edge-state checklist.
  3. Every image's pixel dimensions match the anchor (pt), allowing the
     image to be rendered at @1x/@2x/@3x scale of the anchor.

Exit code 0 = all pass, 1 = any failure. Prints one line per check.
"""

import argparse
import re
import struct
import sys
import zlib


def read_png_size(path):
    with open(path, "rb") as f:
        data = f.read(33)
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        return None
    # IHDR chunk: width/height are the first 8 bytes after length+type
    w, h = struct.unpack(">II", data[16:24])
    return w, h


def read_jpeg_size(path):
    with open(path, "rb") as f:
        data = f.read()
    if data[:2] != b"\xff\xd8":
        return None
    i = 2
    while i < len(data):
        if data[i] != 0xFF:
            i += 1
            continue
        marker = data[i + 1]
        if marker in (0xD8, 0xD9) or 0xD0 <= marker <= 0xD7:
            i += 2
            continue
        if i + 4 > len(data):
            return None
        length = struct.unpack(">H", data[i + 2 : i + 4])[0]
        if 0xC0 <= marker <= 0xC3:  # SOF markers carry dimensions
            h, w = struct.unpack(">HH", data[i + 5 : i + 9])
            return w, h
        i += 2 + length
    return None


def image_size(path):
    size = read_png_size(path)
    if size:
        return size
    return read_jpeg_size(path)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--spec", required=True)
    ap.add_argument("--images", nargs="+", required=True)
    args = ap.parse_args()

    failures = []

    def check(ok, msg):
        print(("PASS " if ok else "FAIL ") + msg)
        if not ok:
            failures.append(msg)

    # 1. spec exists + anchor
    try:
        with open(args.spec, encoding="utf-8") as f:
            spec = f.read()
    except OSError:
        check(False, f"spec not found: {args.spec}")
        return 1

    m = re.search(r"^anchor:\s*(\d+)\s*x\s*(\d+)\s*$", spec, re.M)
    check(bool(m), "spec declares anchor (first line `anchor: WxH`)")
    anchor = (int(m.group(1)), int(m.group(2))) if m else None

    # 2. required sections
    for section in ("design tokens", "components", "edge-state checklist"):
        check(
            section in spec.lower(),
            f"spec contains section: {section}",
        )

    # 3. image dimensions vs anchor (allow @1x/@2x/@3x renders)
    if anchor:
        aw, ah = anchor
        for img in args.images:
            try:
                size = image_size(img)
            except OSError:
                check(False, f"cannot read image: {img}")
                continue
            if not size:
                check(False, f"unsupported image format: {img}")
                continue
            w, h = size
            ok = any(
                (w, h) == (aw * s, ah * s) for s in (1, 2, 3)
            )
            check(
                ok,
                f"{img}: {w}x{h}px matches anchor {aw}x{ah}pt @1x/@2x/@3x",
            )

    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
