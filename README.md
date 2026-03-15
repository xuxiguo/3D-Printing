# 3D Printing Projects

This folder contains OpenSCAD (.scad) files for 3D printing projects designed for Bambu Lab X1.

## 📁 Project Files

### 1. **fintech_ai_nameplate.scad**
- **Description**: Professional nameplate with "FINTECH × AI" text
- **Dimensions**: 250×85×4.6mm (large desktop nameplate)
- **Features**: 
  - Efficient 2-color printing (black base + blue text)
  - One filament change at 3mm height
  - Large 24mm fonts for maximum impact
- **Print Time**: ~75 minutes
- **Material**: ~$2.50

### 2. **tea_storage_box.scad**
- **Description**: Storage box for tea accessories with Chinese character 茶
- **Dimensions**: 7"×4"×3" (177.8×101.6×76.2mm)
- **Features**:
  - Hollow interior for tea accessories
  - Carved Chinese character 茶 (tea) on front
  - Fitted lid with handle
  - 3mm walls, 4mm bottom
- **Print Time**: ~3-4 hours (box + lid)
- **Material**: ~50g PLA/PETG

## 🖥️ How to Open Files in OpenSCAD

### Method 1: Command Line (Current Method)
```powershell
cd "C:\Users\nguo001\Dropbox\Git\Fun\3D Printing"
& "C:\Users\nguo001\Downloads\openscad-2021.01\openscad.exe" "filename.scad"
```

### Method 2: Drag & Drop
1. Open Windows Explorer
2. Navigate to: `C:\Users\nguo001\Dropbox\Git\Fun\3D Printing`
3. Drag any `.scad` file onto: `C:\Users\nguo001\Downloads\openscad-2021.01\openscad.exe`

### Method 3: File Association (One-time setup)
1. Right-click any `.scad` file
2. Choose "Open with" → "Choose another app"
3. Browse to: `C:\Users\nguo001\Downloads\openscad-2021.01\openscad.exe`
4. Check "Always use this app"
5. Future: Double-click any `.scad` file to open in OpenSCAD

## 🎯 Quick Start Commands

### Open Nameplate Project:
```powershell
cd "C:\Users\nguo001\Dropbox\Git\Fun\3D Printing"
& "C:\Users\nguo001\Downloads\openscad-2021.01\openscad.exe" "fintech_ai_nameplate.scad"
```

### Open Tea Box Project:
```powershell
cd "C:\Users\nguo001\Dropbox\Git\Fun\3D Printing"
& "C:\Users\nguo001\Downloads\openscad-2021.01\openscad.exe" "tea_storage_box.scad"
```

## 📋 OpenSCAD Workflow

### 1. Preview (F5)
- Fast preview of the design
- Good for adjusting parameters
- Colors show different parts

### 2. Render (F6)
- Full geometry calculation
- Required before STL export
- Takes longer but more accurate

### 3. Export STL
- File → Export → Export as STL
- Save to same folder
- Import STL into Bambu Studio

## 🖨️ Bambu Studio Settings

### General Settings:
- **Layer Height**: 0.2mm (0.15mm for fine details)
- **Infill**: 15-20%
- **Print Speed**: Normal/Standard
- **Supports**: Usually none needed

### Multi-Color Setup:
1. Import STL into Bambu Studio
2. Use "Change Filament" for height-based colors
3. Or use "Paint" tool for geometry-based colors
4. Set up AMS filament sequence

## 🔧 Troubleshooting

### If OpenSCAD won't open file:
- Check file path has no special characters
- Use PowerShell instead of Command Prompt
- Make sure OpenSCAD is not already running

### If Chinese characters don't render:
- Install "Noto Sans CJK SC" font
- Or use the fallback geometric version in code

### If STL export fails:
- Press F6 first (full render)
- Check for error messages in console
- Reduce $fn value if too complex

## 📂 File Locations

- **Project Folder**: `C:\Users\nguo001\Dropbox\Git\Fun\3D Printing`
- **OpenSCAD**: `C:\Users\nguo001\Downloads\openscad-2021.01\openscad.exe`
- **Git Repository**: `3D-Printing` (owner: xuxiguo)

## 💡 Tips

- Keep `.scad` files in this folder for version control
- Export `.stl` files to the same folder
- Use descriptive filenames for variations
- Comment your parameter changes in the code
- Test print small versions first for fit checks

---
*Last Updated: August 2025*
*Compatible with: OpenSCAD 2021.01, Bambu Lab X1*
