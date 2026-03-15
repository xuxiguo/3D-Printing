/*
FINTECH × AI Nameplate for Bambu Lab X1
OpenSCAD Script

Design specifications:
- Black rectangular base plate (3mm thick)
- Raised text (3-4mm above base, total height 6-7mm)
- FINTECH: Blue, strong upright font, left side
- ×: Gray, enlarged (~130%), center
- AI: White, italic effect, right side

For multi-color printing:
1. Print base in black
2. Change filament at layer corresponding to base height
3. Print text layers in respective colors
*/

// === PARAMETERS ===
// Plate dimensions
plate_width = 120;
plate_height = 40;
base_thickness = 3;
text_height = 3.5;
total_height = base_thickness + text_height;

// Text parameters
font_size_fintech = 12;
font_size_x = 8;
font_size_ai = 12;
font = "Liberation Sans:style=Bold"; // Good for 3D printing
font_italic = "Liberation Sans:style=Bold Italic";

// Positioning
margin = 8;
text_depth = 0.5; // How deep text sits into the raised area for better printing

// === COLORS FOR PREVIEW ===
color_base = [0.1, 0.1, 0.1];      // Dark gray (will be black when printed)
color_fintech = [0.2, 0.4, 0.8];   // Blue
color_x = [0.6, 0.6, 0.6];         // Gray
color_ai = [0.9, 0.9, 0.9];        // White

// === MODULES ===

// Base plate
module base_plate() {
    color(color_base)
    cube([plate_width, plate_height, base_thickness]);
}

// FINTECH text (left side)
module fintech_text() {
    translate([margin, plate_height/2, base_thickness - text_depth]) {
        color(color_fintech)
        linear_extrude(height = text_height + text_depth) {
            text("FINTECH",
                 size = font_size_fintech,
                 font = font,
                 halign = "left",
                 valign = "center");
        }
    }
}

// × symbol (center)
module x_symbol() {
    translate([plate_width/2, plate_height/2, base_thickness - text_depth]) {
        color(color_x)
        linear_extrude(height = text_height + text_depth) {
            text("×",
                 size = font_size_x * 1.3, // 130% size
                 font = font,
                 halign = "center",
                 valign = "center");
        }
    }
}

// AI text (right side, with italic effect)
module ai_text() {
    translate([plate_width - margin, plate_height/2, base_thickness - text_depth]) {
        color(color_ai)
        linear_extrude(height = text_height + text_depth) {
            // Extra shear on top of Bold Italic font for a more dramatic slant
            multmatrix([[1, 0.2, 0, 0],
                       [0, 1, 0, 0],
                       [0, 0, 1, 0],
                       [0, 0, 0, 1]]) {
                text("AI",
                     size = font_size_ai,
                     font = font_italic,
                     halign = "right",
                     valign = "center");
            }
        }
    }
}

// Alternative AI text without transformation (in case above doesn't work well)
module ai_text_simple() {
    translate([plate_width - margin, plate_height/2, base_thickness - text_depth]) {
        color(color_ai)
        linear_extrude(height = text_height + text_depth) {
            text("AI",
                 size = font_size_ai,
                 font = font_italic,
                 halign = "right",
                 valign = "center");
        }
    }
}

// === ASSEMBLY ===

// Main nameplate assembly
module nameplate() {
    union() {
        base_plate();
        fintech_text();
        x_symbol();
        ai_text(); // Use ai_text_simple() if italic effect doesn't work
    }
}

// === RENDERING ===

// Render the complete nameplate
nameplate();

// === INFORMATION OUTPUT ===
echo("=== NAMEPLATE SPECIFICATIONS ===");
echo(str("Dimensions: ", plate_width, "mm × ", plate_height, "mm × ", total_height, "mm"));
echo(str("Base thickness: ", base_thickness, "mm"));
echo(str("Text height: ", text_height, "mm"));
echo(str("Total height: ", total_height, "mm"));
echo("");
echo("=== BAMBU LAB X1 PRINT SETTINGS ===");
echo("Layer height: 0.2mm (recommended for text detail)");
echo("Infill: 15-20%");
echo("Supports: None needed");
echo("Print speed: Normal/Standard");
echo("");
echo("=== MULTI-COLOR PRINTING ===");
echo(str("Change filament at layer: ", base_thickness/0.2, " (", base_thickness, "mm height)"));
echo("1. Black filament: Base plate");
echo("2. Blue filament: FINTECH text");
echo("3. Gray filament: × symbol");
echo("4. White filament: AI text");
echo("");
echo("=== SINGLE COLOR OPTION ===");
echo("Print entire model in black, then paint text with:");
echo("- Blue paint for FINTECH");
echo("- Gray paint for ×");
echo("- White paint for AI");

/*
USAGE INSTRUCTIONS:

1. PREVIEW IN OPENSCAD:
   - Open this file in OpenSCAD
   - Press F5 for quick preview or F6 for full render
   - Adjust parameters at the top if needed

2. EXPORT FOR PRINTING:
   - Press F6 for full render
   - File → Export → Export as STL
   - Use high resolution: $fn=100 (add this line before nameplate() call)

3. BAMBU STUDIO SETUP:
   - Import STL file
   - Layer height: 0.2mm
   - Quality: Standard
   - Infill: 15-20%
   - No supports needed

4. MULTI-COLOR PRINTING:
   - In Bambu Studio, use "Change Filament" feature
   - Set filament change at layer corresponding to 3mm height
   - Or print with single color and paint afterward

5. TROUBLESHOOTING:
   - If text doesn't appear properly, try different fonts
   - Increase $fn value for smoother text curves
   - Adjust text_depth if text doesn't print cleanly
*/
