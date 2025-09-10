#!/bin/bash

set -euo pipefail

# This script changes the file extension of all HEIC, JPEG, JPG and PNG images
# that using incorrectly file extension to it's actual name.
# It scans the current directory and all subdirectories.

find . -type d -name "@eaDir" -prune -o -type f \( -iname "*.JPEG" -o -iname "*.JPG" -o -iname "*.HEIC" -o -iname "*.PNG" \) -print0 | while IFS= read -r -d '' file; do
  mime_type=$(file --brief --mime-type -- "$file")
  filename=$(basename -- "$file")
  ext=".${filename##*.}"
  ext_upper=$(echo "$ext" | tr '[:lower:]' '[:upper:]')
  actual_ext=""

  case "$mime_type" in
    'image/heic')
      actual_ext=".HEIC"
      ;;
    'image/jpeg')
      if [[ "$ext_upper" == ".JPG" || "$ext_upper" == ".JPEG" ]]; then
        actual_ext="$ext"
      else
        actual_ext=".JPG"
      fi
      ;;
    'image/jp2')
      actual_ext=".JP2"
      ;;
    'image/png')
      actual_ext=".PNG"
      ;;
  esac

  if [ -n "$actual_ext" ]; then
    actual_ext_upper=$(echo "$actual_ext" | tr '[:lower:]' '[:upper:]')
    if [[ "$actual_ext_upper" != "$ext_upper" ]]; then
      actual_name="${file%.*}${actual_ext}"
      echo "Renaming \"$file\" to \"$actual_name\" ..."
      mv -n -- "$file" "$actual_name"
    fi
  fi
done
