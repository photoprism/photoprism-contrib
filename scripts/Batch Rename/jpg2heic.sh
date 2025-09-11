#!/bin/bash

set -euo pipefail

# This script changes the file extension of all HEIC images that incorrectly
# match the "*.JPEG" or "*.JPG" file name pattern to ".HEIC".
# It scans the current directory and all subdirectories.

find . -type d -name "@eaDir" -prune -o -type f \( -iname "*.JPEG" -or -iname "*.JPG" \) -print0 | while IFS= read -r -d '' file; do
  if file --brief --mime-type -- "$file" | grep -q '^image/heic$'; then
    heic_name="${file%.*}.HEIC"
    echo "Renaming \"$file\" to \"$heic_name\"..."
    mv -n -- "$file" "$heic_name"
  fi
done
