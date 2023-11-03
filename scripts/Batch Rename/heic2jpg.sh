#!/bin/bash

# This script changes the file extension of all JPEG images that incorrectly
# match the "IMG_*.HEIC" file name pattern from ".HEIC" to ".JPG".

for file in $(file IMG_*.HEIC | grep JPEG | cut -d ':' -f1); do
  mv "$file" "${file%.*}.JPG" ;
done;
