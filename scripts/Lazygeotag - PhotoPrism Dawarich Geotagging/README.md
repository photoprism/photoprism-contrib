# Lazygeotag - PhotoPrism & Dawarich Geotagging Tool

**Intelligent geotagging tool for PhotoPrism and local directories using Dawarich location data**

## Overview

Lazygeotag automatically adds GPS coordinates to your photos by matching their timestamps with location data from Dawarich. It supports both PhotoPrism queries and local directory scanning, with intelligent failure reporting and safe dry-run testing.

## Features

- **Dual-mode operation**: PhotoPrism queries and local directory scanning
- **Safe dry-run mode** for testing without modifications
- **Intelligent failure reporting** with categorized reasons
- **Robust PhotoPrism API integration** with timeout handling
- **Automatic rescan optimization** with common path detection
- **Comprehensive EXIF GPS coordinate injection**
- **Support for JPEG and TIFF files** with PNG filtering
- **Time-based location matching** with configurable time windows

## Repository

**GitHub**: [streiman/lazygeotag](https://github.com/streiman/lazygeotag)

## Requirements

- Python 3.8+
- PhotoPrism instance (for PhotoPrism mode)
- Dawarich instance with location data
- Required Python packages: `requests`, `piexif`, `pytz`

## Installation

```bash
git clone https://github.com/streiman/lazygeotag.git
cd lazygeotag
pip install -r requirements.txt
cp .env.example .env
# Edit .env with your PhotoPrism and Dawarich credentials
```

## Usage Examples

### PhotoPrism Mode
```bash
# Dry-run to see what would be processed
python lazygeotag.py --query "album:vacation" --dry-run

# Process photos from specific album
python lazygeotag.py --query "album:vacation year:2024"

# Process with custom time window
python lazygeotag.py --query "geo:false" --time-window 30
```

### Local Directory Mode
```bash
# Process local directory (dry-run)
python lazygeotag.py --local-dir "/path/to/photos" --dry-run

# Process with automatic PhotoPrism rescan
python lazygeotag.py --local-dir "/path/to/photos" --rescan
```

## Configuration

Create a `.env` file with your credentials:

```env
PHOTOPRISM_URL=http://your-photoprism-instance:2342
PHOTOPRISM_USERNAME=your-username
PHOTOPRISM_PASSWORD=your-password
DAWARICH_URL=http://your-dawarich-instance:3000
DAWARICH_API_KEY=your-api-key
```

## Key Benefits for PhotoPrism Users

- **Non-destructive testing** with `--dry-run` mode
- **Automatic PhotoPrism rescans** after geotagging
- **Intelligent batch processing** with progress reporting
- **Robust error handling** for large photo collections
- **Time zone aware** location matching
- **Detailed failure analysis** to understand why photos weren't geotagged

## Integration with PhotoPrism

The tool seamlessly integrates with PhotoPrism by:
1. Using PhotoPrism's search API to find photos
2. Downloading and processing photos in batches
3. Updating EXIF data with GPS coordinates
4. Triggering intelligent rescans of modified folders
5. Providing detailed progress and failure reports

Perfect for PhotoPrism users who want to automatically geotag their photo collections using location data from Dawarich or similar services.
