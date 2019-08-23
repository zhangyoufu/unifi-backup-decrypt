#!/bin/sh

# Authors:
# 2017 Youfu Zhang
# 2019 Balint Reczey <balint.reczey@canonical.com>

set -e

usage() {
    echo "Usage: $0 < Unifi Controller backup file > < output directory >"
}

if [ -z "$2" -o ! -f "$1" ]; then
    usage
    exit 1
fi

INPUT="$1"
OUTPUT="$2"

mkdir -p "${OUTPUT}"

TMP_ZIP1=$(mktemp --suffix=.zip)
TMP_ZIP2=$(mktemp --suffix=.zip)

trap "rm -f ${TMP_ZIP1} ${TMP_ZIP2}" EXIT

openssl enc -d -in "${INPUT}" -out "${TMP_ZIP1}" -aes-128-cbc -K 626379616e676b6d6c756f686d617273 -iv 75626e74656e74657270726973656170 -nosalt -nopad
yes | zip -FF "${TMP_ZIP1}" --out "${TMP_ZIP2}" > /dev/null 2>&1
unzip -q "${TMP_ZIP2}" -d "${OUTPUT}"

case "$(cat ${OUTPUT}/format)" in
    bson)
        cd "${OUTPUT}"
        for i in db db_stat; do
            gunzip -k -c $i.gz | python3 -c 'import sys; import bson; import bson.json_util; [print(bson.json_util.dumps(chunk)) for chunk in bson.decode_file_iter(sys.stdin.buffer)]' > $i.json
        done
    ;;
    *)
        echo "WARNING: Unknown database format, not converting database to JSON" >&2
        exit 1
esac
