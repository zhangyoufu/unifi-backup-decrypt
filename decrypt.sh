#!/bin/bash
INPUT=$1
OUTPUT=${INPUT%.unf}.zip
openssl enc -d -in "${INPUT}" -out "${OUTPUT}.tmp" -aes-128-cbc -K 626379616e676b6d6c756f686d617273 -iv 75626e74656e74657270726973656170 -nosalt -nopad
yes | zip -FF "${OUTPUT}.tmp" --out "${OUTPUT}"
rm "${OUTPUT}.tmp"
