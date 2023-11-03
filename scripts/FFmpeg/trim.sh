#!/bin/bash

# This script uses FFmpeg to trim the first few seconds of an mp4 video file.
# If the second argument is not provided, 10 seconds are removed by default.
# Please note that further work is needed to trim videos from the end instead,
# and to support additional container formats.

if [[ -z $1 ]]; then
  echo "Usage: ${0##*/} [video filename] [seconds]" 1>&2
  exit 1
fi

set -e

if [[ -z $2 ]]; then
  SECONDS=10
else
  SECONDS=$2
fi

echo "Trimming the first $SECONDS seconds from $1..."
ffmpeg -i $1 -ss $SECONDS -vcodec copy -acodec copy $1.trim.mp4

echo "Deleting $1..."
rm $1

echo "Renaming $1.trim.mp4 to $1..."
mv $1.trim.mp4 $1

echo "Done."