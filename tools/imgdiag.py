#!/usr/bin/env python

"""
Diagnose image file integrity.
This script supports a lot of image formats, not only JPEG image,
but depends on pillow (PIL).
And also slower than jpgdiag because of loading whole images.

Requirements:
Python >= 3.5
Pillow (PIL would be also ok but not recommended)
Usage:
python3 imgdiag.py jpeg,jpg,png,bmp . # check
"""

import os
from PIL import Image
from glob import glob
import argparse

try:
    import tqdm
except:
    tqdm = None


def loop_controller(iterable):
    if tqdm is not None:
        return tqdm.tqdm(iterable)
    else:
        return iterable


parser = argparse.ArgumentParser(prog='imgdiag')
parser.add_argument('path')
parser.add_argument('-e', '--exts', nargs='+')
parser.add_argument('-d', '--deletion', action='store_true')
args = parser.parse_args()

imgfiles = list()
for e in args.exts:
    imgfiles.extend(glob("{}/**/*.{}".format(args.path, e),
                         recursive=True))

count = 0

for f in loop_controller(imgfiles):
    try:
        Image.open(f)
    except IOError:
        if tqdm is None:
            print('{} is corrupted.'.format(f))

        if args.d:
            os.unlink(f)

        count += 1

print('done. ({} files were corrupted)'.format(count))
