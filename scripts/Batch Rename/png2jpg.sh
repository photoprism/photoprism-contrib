#!/bin/bash

# This script changes the file extension of all JPEG images that incorrectly
# match the "*.PNG" file name pattern from ".PNG" to ".JPG".
# It scans the current directory and all subdirectories.

find . -type f -iname "*.PNG" -print0 | while IFS= read -r -d '' file; do
  if file --brief --mime-type -- "$file" | grep -q '^image/jpeg$'; then
    echo "Renaming \"$file\"..."
    mv -- "$file" "${file%.*}.JPG" ;
  fi
done
