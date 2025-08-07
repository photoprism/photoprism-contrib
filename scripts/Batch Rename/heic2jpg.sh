#!/bin/bash

# This script changes the file extension of all JPEG images that incorrectly
# match the "IMG_*.HEIC" file name pattern from ".HEIC" to ".JPG".

for file in $(find . -type f -name "*.heic" -print0 | xargs -0 file | grep JPEG | cut -d ':' -f1); do
  mv "$file" "${file%.*}.JPG" ;
done;
