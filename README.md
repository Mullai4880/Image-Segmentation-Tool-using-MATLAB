# Image Segmentation Tool (MATLAB)

A professional MATLAB-based GUI application for advanced image segmentation, featuring both basic thresholding and multi-threshold techniques. This tool provides real-time visualization, interactive controls, and comprehensive analysis capabilities.

## Table of Contents
- [Features](#features)
- [Technical Overview](#technical-overview)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage Guide](#usage-guide)
- [Implementation Details](#implementation-details)

## Features

### Core Functionality
- **Interactive GUI Interface**
  - Dark theme professional design
  - Real-time parameter adjustment
  - Side-by-side result preview
  - Dynamic histogram visualization

### Segmentation Methods
1. **Basic Threshold**
   - Single threshold value segmentation
   - Real-time threshold line visualization
   - Binary output (foreground/background)

2. **Multi-threshold**
   - Support for 2-5 regions
   - Color-coded region visualization
   - Multiple threshold lines
   - Automatic region distribution

### Analysis Tools
- **Real-time Histogram Analysis**
  - Dynamic intensity distribution
  - Interactive threshold markers
  - Color-coded threshold lines
  - Region boundary visualization

### Data Management
- **Image Support**
  - Load custom images (JPG, PNG, BMP, TIF)
  - Built-in test pattern generation
  - Grayscale conversion for color images
  - Multiple region visualization

- **Export Capabilities**
  - Save segmented results
  - Export histogram analysis
  - Multiple format support (PNG, JPG, TIF)
  - MATLAB figure export

## Technical Overview

### Key Terms
- **Image Segmentation**: Process of partitioning an image into multiple segments
- **Thresholding**: Technique to separate pixels based on intensity values
- **Histogram Analysis**: Visual representation of pixel intensity distribution
- **Multi-region Segmentation**: Division of image into multiple distinct regions
- **Region Coloring**: Assignment of unique colors to different segments

## Requirements

### Software Dependencies
- MATLAB R2019b or newer
- Image Processing Toolbox

### System Requirements
- Operating System: Windows/Mac/Linux
- RAM: 4GB minimum (8GB recommended)
- Display: 1280x720 or higher resolution
- Storage: 500MB free space

## Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/image-segmentation-tool.git
```

2. Add to MATLAB path
```matlab
addpath(genpath('path/to/image-segmentation-tool'))
```

3. Run the application
```matlab
region_segmentation_gui
```

## Usage Guide

### Basic Operation

1. **Starting the Tool**
   ```matlab
   region_segmentation_gui
   ```

2. **Loading Images**
   - ![Load Image](https://i.imgur.com/G1iPimO.png)
   - Click "Load Image" for custom images
   - Use "Reset to Test Pattern" for synthetic test image
   - Supported formats: JPG, PNG, BMP, TIF

4. **Basic Thresholding**
   - ![Basic Thresholding](https://i.imgur.com/KvZLxKO.png)
   - Select "Basic Threshold" mode
   - Adjust threshold using slider (0-1)
   - Observe real-time segmentation
   - View threshold line on histogram

6. **Multi-threshold Segmentation**
   - ![Multi-threshold Segmentation]([https://i.imgur.com/G1iPimO.png](https://i.imgur.com/nAnKUPR.png))
   - Select "Multi-threshold" mode
   - Choose number of regions (2-5)
   - Observe color-coded regions
   - View multiple threshold lines

8. **Saving Results**
   - ![Saving Results](https://i.imgur.com/krZRAGQ.png)
   - Click "Save Result" for segmented image
   - Use "Export Histogram" for analysis data
   - Choose desired output format
   - Select save location

### Advanced Features

1. **Histogram Analysis**
   - ![Histogram Analysis](https://i.imgur.com/KNKnHlk.png)
   - Real-time intensity distribution
   - Interactive threshold markers
   - Region boundary visualization
   - Color-coded threshold lines

2. **Parameter Adjustment**
   - ![Parameter Adjustment](https://i.imgur.com/WJEyM2A.png)
   - Threshold value (0-1)
   - Number of regions (2-5)
   - Real-time visual feedback
   - Confirmation dialogs

## Implementation Details

### Core Components
1. **GUI Layout**
   - Left panel: Image display
   - Right panel: Controls and analysis
   - Dark theme interface

2. **Image Processing**
   - Grayscale conversion
   - Intensity normalization
   - Region labeling
   - Color mapping

3. **Visualization**
   - Real-time updates
   - Side-by-side comparison
   - Dynamic histogram
   - Interactive controls

## Examples

### Basic Threshold Example
```matlab
% Load and segment an image
region_segmentation_gui
% 1. Load image
% 2. Select Basic Threshold
% 3. Adjust threshold to 0.5
% 4. Save result
```

### Multi-threshold Example
```matlab
% Segment image into multiple regions
region_segmentation_gui
% 1. Load image
% 2. Select Multi-threshold
% 3. Set regions to 3
% 4. Export histogram
```
