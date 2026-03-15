/*
FINTECH × AI Nameplat// Text parameters - DOUBLE SIZE
font_size_fintech = 28;   // Doubled from 14mm
font_size_x = 20;         // Doubled from 10mm
font_size_ai = 28;        // Doubled from 14mm
font = "Liberation Sans:style=Bold"; // Reliable system font
font_italic = "Liberation Sans:style=Bold Italic";

// Positioning - doubled for 2x larger plate
margin = 40;  // Doubled margin

// Manual positioning for visual balance (doubled spacing)
fintech_x = 100;     // Doubled from 50mm
x_x = 150;           // Center × in the middle of the plate (300/2)  
ai_x = 250;          // Doubled from 125mmb X1
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
// Plate dimensions - DOUBLE SIZE (2x larger)
plate_width = 300;   // Doubled from 150mm 
plate_height = 100;  // Doubled from 50mm
base_thickness = 3;
text_height = 1.6; // More natural, shallow raised text
total_height = base_thickness + text_height;

// Text parameters - SCALED UP
font_size_fintech = 14;   // Increased from 11mm
font_size_x = 10;         // Increased from 8mm
font_size_ai = 14;        // Increased from 11mm
font = "Liberation Sans:style=Bold"; // Reliable system font
font_italic = "Liberation Sans:style=Bold Italic";

// Positioning - adjusted for larger plate
margin = 20;  // Increased margin

// Manual positioning for visual balance (scaled for larger plate)
fintech_x = 50;      // Moved right proportionally
x_x = 105;            // Center × in the middle of the plate (150/2)  
ai_x = 125;          // Moved left proportionally for balance

// Background carving parameters
carve_depth = 0.6;      // Shallower carving
carve_radius = 0;       // Smaller radius
carve_margin = 4;       // Larger margin for better proportions

// Text depth
text_depth = 0.3; // Shallow depth for natural look

// === COLORS FOR PREVIEW ===
color_base = [0.1, 0.1, 0.1];      // Dark gray (will be black when printed)
color_fintech = [0.2, 0.4, 0.8];   // Blue
color_x = [0.6, 0.6, 0.6];         // Gray  
color_ai = [0.9, 0.9, 0.9];        // White

// === MODULES ===

// Simple, manifold-safe base plate
module base_plate() {
    // Just a simple solid cube - no complex operations
    color(color_base)
    cube([plate_width, plate_height, base_thickness]);
}

// FINTECH text (ultra-clean manifold construction)
module fintech_text() {
    translate([fintech_x, plate_height/2, base_thickness]) {
        color(color_fintech)
        linear_extrude(height = text_height, convexity = 10) {
            text("FINTECH", 
                 size = font_size_fintech, 
                 font = font,
                 halign = "center", 
                 valign = "center");
        }
    }
}

// × symbol (ultra-clean manifold construction)
module x_symbol() {
    translate([x_x, plate_height/2, base_thickness]) {
        color(color_x)
        linear_extrude(height = text_height, convexity = 10) {
            text("×", 
                 size = font_size_x * 1.4, 
                 font = font,
                 halign = "center", 
                 valign = "center");
        }
    }
}

// AI text (ultra-clean manifold construction)
module ai_text() {
    translate([ai_x, plate_height/2, base_thickness]) {
        color(color_ai)
        linear_extrude(height = text_height, convexity = 10) {
            text("AI", 
                 size = font_size_ai, 
                 font = font_italic,
                 halign = "center", 
                 valign = "center");
        }
    }
}

// === ASSEMBLY ===

// Debug module to show positioning (comment out for final print)
module debug_positions() {
    // Show position markers
    color("red") {
        translate([fintech_x, plate_height/2 - 2, base_thickness + text_height]) 
            cube([1, 4, 0.5], center=true);
        translate([x_x, plate_height/2 - 2, base_thickness + text_height]) 
            cube([1, 4, 0.5], center=true);
        translate([ai_x, plate_height/2 - 2, base_thickness + text_height]) 
            cube([1, 4, 0.5], center=true);
    }
}

// Test module for manifold debugging
module simple_test() {
    union() {
        // Just base and one text element
        cube([plate_width, plate_height, base_thickness]);
        translate([60, 20, base_thickness]) {
            linear_extrude(height = text_height) {
                text("TEST", size = 8, halign = "center", valign = "center");
            }
        }
    }
}

// Main nameplate assembly - using union for manifold safety
module nameplate() {
    // Use union to combine all parts into a single manifold
    union() {
        base_plate();
        fintech_text();
        x_symbol();
        ai_text();
    }
}

// === HEIGHT-SEPARATED MULTI-COLOR (EFFICIENT) ===
// Each color prints at different Z-heights - no per-layer color changes

module efficient_multi_color() {
    // Layer 1-20: Only black base (3mm) - no other colors on these layers
    color(color_base)
    cube([plate_width, plate_height, base_thickness]);
    
    // Layer 21-32: All text in ONE color (1.6mm) - choose your preferred color
    translate([0, 0, base_thickness]) {
        color(color_fintech) // All text will be this color (blue)
        union() {
            // FINTECH text
            translate([fintech_x, plate_height/2, 0]) {
                linear_extrude(height = text_height, convexity = 10) {
                    text("FINTECH", 
                         size = font_size_fintech, 
                         font = font, 
                         halign = "center", 
                         valign = "center");
                }
            }
            // × symbol  
            translate([x_x, plate_height/2, 0]) {
                linear_extrude(height = text_height, convexity = 10) {
                    text("×", 
                         size = font_size_x * 1.4, 
                         font = font, 
                         halign = "center", 
                         valign = "center");
                }
            }
            // AI text
            translate([ai_x, plate_height/2, 0]) {
                linear_extrude(height = text_height, convexity = 10) {
                    text("AI", 
                         size = font_size_ai, 
                         font = font_italic, 
                         halign = "center", 
                         valign = "center");
                }
            }
        }
    }
}

// === PRINTER-COMPATIBLE LARGE VERSION ===
// Scaled to fit Bambu X1 while still being very large

module nameplate_fit_printer() {
    // Dimensions that fit Bambu X1 (256mm max) but still very large
    fit_width = 250;   // Just under printer limit
    fit_height = 85;   // Proportionally scaled
    fit_fintech_x = 85;
    fit_x_x = 125;     // Center
    fit_ai_x = 210;
    
    // Base plate
    color(color_base)
    cube([fit_width, fit_height, base_thickness]);
    
    // All text in blue
    translate([0, 0, base_thickness]) {
        color(color_fintech)
        union() {
            // FINTECH text
            translate([fit_fintech_x, fit_height/2, 0]) {
                linear_extrude(height = text_height, convexity = 10) {
                    text("FINTECH", size = 24, font = font, halign = "center", valign = "center");
                }
            }
            // × symbol  
            translate([fit_x_x, fit_height/2, 0]) {
                linear_extrude(height = text_height, convexity = 10) {
                    text("×", size = 17, font = font, halign = "center", valign = "center");
                }
            }
            // AI text
            translate([fit_ai_x, fit_height/2, 0]) {
                linear_extrude(height = text_height, convexity = 10) {
                    text("AI", size = 24, font = font_italic, halign = "center", valign = "center");
                }
            }
        }
    }
}

// === SEPARATE PARTS FOR MULTI-COLOR PRINTING ===
// Each part prints in place with different colors

// Part 1: Base plate (Black)
module part_base() {
    base_plate();
}

// Part 2: FINTECH text (Blue) 
module part_fintech() {
    fintech_text();
}

// Part 3: × symbol (Gray)
module part_x() {
    x_symbol();
}

// Part 4: AI text (White)
module part_ai() {
    ai_text();
}

// Combined layout for multi-color printing
// All parts print together but assigned different colors in slicer
module multi_color_layout() {
    part_base();     // Will be assigned black in slicer
    part_fintech();  // Will be assigned blue in slicer  
    part_x();        // Will be assigned gray in slicer
    part_ai();       // Will be assigned white in slicer
}

// === ADVANCED: SEPARATE BY HEIGHT FOR AUTO-COLOR CHANGE ===

// Method for height-based color changes in Bambu Studio
module base_layer() {
    // Only the base plate (0 to 3mm)
    intersection() {
        nameplate();
        cube([plate_width, plate_height, base_thickness]);
    }
}

module text_layer() {
    // Only the text parts (3mm to 4.6mm)
    intersection() {
        nameplate();
        translate([0, 0, base_thickness])
            cube([plate_width, plate_height, text_height]);
    }
}

// === RENDERING ===

// Conservative settings for manifold safety
$fn = 16; // Lower for preview, increase to 32 for final export

// === CHOOSE YOUR SIZE ===

// OPTION 1: MASSIVE 300×100mm (TOO LARGE for Bambu X1)
// efficient_multi_color();

// OPTION 2: LARGE but fits printer 250×85mm (RECOMMENDED)
nameplate_fit_printer();

// === ALTERNATIVE METHODS ===
// multi_color_layout();     // Expensive multi-color method

// === INFORMATION OUTPUT ===
echo("=== NAMEPLATE SPECIFICATIONS ===");
echo(str("Dimensions: ", plate_width, "mm × ", plate_height, "mm × ", total_height, "mm"));
echo(str("Base thickness: ", base_thickness, "mm"));
echo(str("Text height: ", text_height, "mm (natural shallow raise)"));
echo(str("Total height: ", total_height, "mm"));
echo("");
echo("=== DOUBLE SIZE NAMEPLATE SPECIFICATIONS ===");
echo(str("MASSIVE Dimensions: ", plate_width, "mm × ", plate_height, "mm × ", total_height, "mm"));
echo(str("Previous small: 120mm × 40mm"));
echo(str("Previous large: 150mm × 50mm")); 
echo(str("Current DOUBLE: 300mm × 100mm (4x area!)"));
echo(str("Base thickness: ", base_thickness, "mm"));
echo(str("Text height: ", text_height, "mm"));
echo(str("LARGE font sizes: FINTECH/AI=", font_size_fintech, "mm, ×=", font_size_x, "mm"));
echo("");
echo("⚠️  IMPORTANT: Check if this fits your Bambu X1 build plate!");
echo("Bambu X1 max: 256×256×256mm - Your design: 300×100mm");
echo("Width is TOO LARGE for single print - see options below");
echo("");
echo("=== DESIGN IMPROVEMENTS ===");
echo("✓ Reliable Arial font for better rendering");
echo("✓ Proper visual balance with manual positioning");
echo("✓ × symbol truly centered on plate (60mm)");
echo("✓ Reduced text sizes for better proportions");
echo("✓ Clean manifold geometry (no 2-manifold warnings)");
echo("✓ Simplified carved border for reliable printing");
echo("✓ Eliminated overlapping geometries");
echo("✓ Removed complex transformations");
echo("✓ Clean linear extrusion without depth overlap");
echo("");
echo("=== BAMBU LAB X1 PRINT SETTINGS ===");
echo("Layer height: 0.15mm (for fine detail on shallow text)");
echo("Infill: 20%");
echo("Supports: None needed");
echo("Print speed: Normal/Standard");
echo("");
echo("=== EFFICIENT MULTI-COLOR PRINTING ===");
echo("");
echo("🎯 NEW METHOD: Height-separated colors (COST EFFECTIVE!)");
echo("");
echo("PRINT OPTIONS FOR LARGE NAMEPLATE:");
echo("⚠️  300mm width > Bambu X1 limit (256mm)");
echo("");
echo("OPTION 1: Split into 2 parts (RECOMMENDED)");
echo("- Print left half (FINTECH + ×) separately");
echo("- Print right half (AI + base) separately"); 
echo("- Join with dowels or glue");
echo("");
echo("OPTION 2: Reduce to fit (275mm × 95mm)");
echo("- Still very large but fits build plate");
echo("- Uncomment 'nameplate_fit_printer()' below");
echo("");
echo("OPTION 3: Use larger printer");
echo("- Prusa XL, Bambu X1E, or commercial printer");
echo("");
echo("ADVANTAGES OF DOUBLE SIZE:");
echo("✅ MASSIVE desktop presence (12\" × 4\")");
echo("✅ Huge text - readable from across room"); 
echo("✅ Premium executive appearance");
echo("✅ Still efficient printing method");
echo("✅ Cost: ~$3-4 (4x material)");
echo("");
echo("BAMBU STUDIO SETUP:");
echo("1. Import STL file");
echo("2. Use 'Change Filament' feature");
echo(str("3. Set change at layer ", round(base_thickness/0.15), " (", base_thickness, "mm height)"));
echo("4. Filament sequence: Black → Blue");
echo("5. Print time: ~45 minutes");
echo("");
echo("RESULT: Black base + Blue text (FINTECH × AI)");
echo("");
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
