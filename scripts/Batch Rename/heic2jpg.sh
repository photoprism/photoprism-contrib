#!/bin/bash

set -euo pipefail

# This script changes the file extension of all JPEG images that incorrectly
# match the "*.HEIC" file name pattern from ".HEIC" to ".JPG".
# It scans the current directory and all subdirectories.

find . -type f -iname "*.HEIC" -print0 | while IFS= read -r -d '' file; do
  if file --brief --mime-type -- "$file" | grep -q '^image/jpeg$'; then
    jpg_name="${file%.*}.JPG"
    echo "Renaming \"$file\" to \"$jpg_name\"..."
    mv -n -- "$file" "$jpg_name"
  fi
done
