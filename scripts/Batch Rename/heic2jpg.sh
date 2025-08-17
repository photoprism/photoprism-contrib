#!/bin/bash

# This script changes the file extension of all JPEG images that incorrectly
# match the "IMG_*.HEIC" file name pattern from ".HEIC" to ".JPG".
# It scans the current directory and all subdirectories.

find . -iname "IMG_*.HEIC" -print0 | while IFS= read -r -d $'' file; do
  if file "$file" | grep -q "JPEG"; then
    echo "Renaming \"$file\"..."
    mv "$file" "${file%.*}.JPG" ;
  fi
done
