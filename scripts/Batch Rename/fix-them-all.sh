#!/bin/bash

# This script changes the file extension of all HEIC, JPEG, JPG and PNG images
# that using incorrectly file extension to it's actual name.
# It scans the current directory and all subdirectories.

find . -type f \( -iname "*.JPEG" -o -iname "*.JPG" -o -iname "*.HEIC" -o -iname "*.PNG" \) -print0 | while IFS= read -r -d '' file; do
  mime_type=$(file --brief --mime-type -- "$file")
  filename=$(basename -- "$file")
  ext=".${filename##*.}"
  actual_ext=

  case "$mime_type" in
    'image/heic')
      actual_ext=".HEIC"
      ;;
    'image/jpeg')
      if [[ "${ext^^}" == ".JPG" || "${ext^^}" == ".JPEG" ]]; then
        actual_ext="$ext"
      else
        actual_ext=".JPG"
      fi
      ;;
    'image/png')
      actual_ext=".PNG"
      ;;
  esac

  if [[ -n "$actual_ext" && "${actual_ext^^}" != "${ext^^}" ]]; then
    actual_name="${file%.*}${actual_ext}"
    echo "Renaming \"$file\" to \"$actual_name\" ..."
    mv -- "$file" "$actual_name"
  fi
done
