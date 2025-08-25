# Batch Rename Scripts

## Fix Extension of JPEG Files Matching the `*.HEIC` Pattern

The [heic2jpg.sh](heic2jpg.sh) script changes the file extension of all JPEG images that incorrectly match the `*.HEIC` file name pattern from `.HEIC` to `.JPG`:

```bash
./heic2jpg.sh
```

The script will scans the current directory and all subdirectories.

## Fix Extension of HEIC Files Matching the `*.JPG` and `*.JPEG` Pattern

The [jpg2heic.sh](jpg2heic.sh) script changes the file extension of all HEIC images that incorrectly match the `*.JPG` or `*.JPEG` file name pattern to `.HEIC`:

```bash
./jpg2heic.sh
```

The script will scan the current directory and all subdirectories.

## Fix Extension of JPEG Files Matching the `*.PNG` Pattern

The [png2jpg.sh](png2jpg.sh) script changes the file extension of all JPEG images that incorrectly match the `*.PNG` file name pattern from `.PNG` to `.JPG`:

```bash
./png2jpg.sh
```

The script will scan the current directory and all subdirectories.

## Fix All Incorrect Extensions at Once

The [fix-them-all.sh](fix-them-all.sh) script combines the functionality of all three scripts above into one convenient tool. It automatically detects the actual file type (HEIC, JPG, or PNG) and renames files to use the correct extension based on their MIME type:

```bash
./fix-them-all.sh
```

This script will scan the current directory and all subdirectories for files with `.HEIC`, `.JPG`, `.JPEG`, and `.PNG` extensions.

*Contributed by [Miłosz Kosobucki](https://github.com/MiKom) and [Xie Yanbo](https://github.com/xyb).*
