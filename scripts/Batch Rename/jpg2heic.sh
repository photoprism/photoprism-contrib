#!/bin/bash

# This script changes the file extension of all HEIC images that incorrectly
# match the "*.JPEG" or "*.JPG" file name pattern to ".HEIC".
# It scans the current directory and all subdirectories.

find . -type f \( -iname "*.JPEG" -or -iname "*.JPG" \) -print0 | while IFS= read -r -d '' file; do
  if file --brief --mime-type -- "$file" | grep -q '^image/heic$'; then
    echo "Renaming \"$file\"..."
    mv -- "$file" "${file%.*}.HEIC" ;
  fi
done
