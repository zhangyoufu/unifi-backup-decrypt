#!/bin/sh

# Authors:
# 2019 Balint Reczey <balint.reczey@canonical.com>

set -e

usage() {
    echo "Usage: $0 <input directory> < generated Unifi Controller backup file >"
    echo ""
    echo "Pack extracted controller configuration to .unf file."
    echo "*.json files are converted to respective gzip compressed BSON files."
}

if [ -z "$2" -o ! -d "$1" ]; then
    usage
    exit 1
fi

INPUT_DIR="$1"
OUTPUT_UNF="$(realpath $2)"

cd "${INPUT_DIR}"

case "$(cat format)" in
    bson)
        for i in db db_stat; do
            if [ -f $i.json ]; then
                python3 -c 'import sys; import bson; import bson.json_util; [ sys.stdout.buffer.write(bson.BSON.encode(bson.json_util.loads(line))) for line in sys.stdin.readlines()]' < $i.json | gzip > $i.gz
            fi
        done
    ;;
    *)
        echo "WARNING: Unknown database format, not converting database to BSON" >&2
esac

zip --exclude '*.json' -q -r - . | openssl enc -e -in - -out "${OUTPUT_UNF}" -aes-128-cbc -K 626379616e676b6d6c756f686d617273 -iv 75626e74656e74657270726973656170 -nosalt
