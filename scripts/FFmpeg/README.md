# FFmpeg Helper Scripts

## Remove the first X seconds of an MP4 video

The [trim.sh](trim.sh) script cuts the first e.g. 15 seconds from an mp4 video file (please use carefully and create a backup before trying this):

```bash
./trim.sh video.mp4 15
```

If the second argument is not provided, 10 seconds will be trimmed by default. Also note that further work is needed to trim videos from the end instead, and to support additional video formats. 