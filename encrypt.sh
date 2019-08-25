#!/bin/sh

# Authors:
# 2019 Balint Reczey <balint.reczey@canonical.com>
# 2019 Youfu Zhang

set -e

usage() {
    echo "Usage: $0 <input .zip file> <output .unf file>"
}

if [ -z "$2" -o ! -f "$1" ]; then
    usage
    exit 1
fi

INPUT_ZIP=$1
OUTPUT_UNF=$2

openssl enc -e -in "${INPUT_ZIP}" -out "${OUTPUT_UNF}" -aes-128-cbc -K 626379616e676b6d6c756f686d617273 -iv 75626e74656e74657270726973656170
