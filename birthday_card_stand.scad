// ============================================================
// Birthday Card Display Stand - Foldable with Living Hinges
// ============================================================
// Prints flat as a cross shape, folds into a display cradle.
// Each card panel slides into U-channel grooves.
// Designed for Bambu Lab A1, white PLA, no supports needed.
//
// Card dimensions (from hand-drawn sketch):
//   Center panel:  4.25" x 5.5"
//   Top flap:      4.25" x 2.625"
//   Bottom flap:   4.25" x 2.625"
//   Left flap:     2" x 5.5"
//   Right flap:    2" x 5.5"
// ============================================================

// ---- Toggle: set to true to see the folded/assembled view ----
folded_preview = false;

// ---- Unit conversion ----
inch = 25.4;

// ---- Card dimensions (mm) ----
center_w = 4.25 * inch;   // 107.95mm
center_h = 5.5 * inch;    // 139.7mm
top_h    = 2.625 * inch;  // 66.675mm
bottom_h = 2.625 * inch;  // 66.675mm
left_w   = 2 * inch;      // 50.8mm
right_w  = 2 * inch;      // 50.8mm

// ---- Stand parameters ----
wall       = 2;       // wall thickness (mm)
slot_w     = 1.5;     // slot width for card (mm)
slot_d     = 8;       // slot depth (mm)
rail_thick = 5;       // overall rail/panel thickness (mm)

// Rail heights (how tall each support panel is when folded up)
center_rail_h = 80;          // center support height
wing_rail_h   = center_rail_h; // left/right same height
top_rail_h    = 25;           // top rail strip height

// Base plate
base_thick = 5;               // base plate thickness
base_depth = bottom_h * 0.5;  // base extends ~33mm forward

// ---- Living hinge parameters ----
hinge_gap     = 0.4;    // gap between panels at hinge
hinge_bridges = 3;      // number of thin bridge strips
hinge_bridge_w = 3;     // width of each bridge strip
hinge_bridge_t = 0.3;   // thickness of bridge (thin for flex)

// ---- Angle stop bracket ----
bracket_size = 15;      // triangle leg size
bracket_thick = wall;

// ---- Derived dimensions ----
// Width of groove rail cross-section: wall + slot + wall
groove_rail_w = wall + slot_w + wall;  // 5.5mm

// ---- Wing angle ----
wing_angle = 45;

// ---- Bambu A1 bed check ----
total_flat_w = left_w + groove_rail_w + hinge_gap + center_w + hinge_gap + groove_rail_w + right_w;
total_flat_h = top_rail_h + hinge_gap + center_rail_h + hinge_gap + base_depth;

echo(str("=== Birthday Card Stand ==="));
echo(str("Flat footprint: ", total_flat_w, "mm x ", total_flat_h, "mm"));
echo(str("Bambu A1 bed: 256mm x 256mm"));
echo(str("Fits on bed: ", total_flat_w <= 256 && total_flat_h <= 256 ? "YES" : "NO - resize needed"));
echo(str("Card center: ", center_w, "mm x ", center_h, "mm"));
echo(str("Groove: ", slot_w, "mm wide x ", slot_d, "mm deep"));

// ============================================================
// MODULES
// ============================================================

// U-channel groove rail along X axis
// length: how long the groove runs
// height: how tall the rail panel is
module groove_rail(length, height) {
    difference() {
        // Solid rail block
        cube([length, groove_rail_w, height]);
        
        // Cut the slot channel along the top
        translate([0, wall, height - slot_d])
            cube([length, slot_w, slot_d + 1]);
    }
}

// Base plate - solid, sits flat on table
module base_plate() {
    // Main base slab
    cube([center_w, base_depth, base_thick]);
    
    // Groove along the far edge (top of base) to hold bottom card flap
    translate([0, base_depth - groove_rail_w, 0])
        difference() {
            cube([center_w, groove_rail_w, base_thick + slot_d]);
            // Slot cut
            translate([0, wall, base_thick])
                cube([center_w, slot_w, slot_d + 1]);
        }
    
    // Small feet/pads at corners for grip
    foot_r = 3;
    foot_h = 1;
    for (x = [foot_r, center_w - foot_r])
        for (y = [foot_r, base_depth - groove_rail_w - foot_r])
            translate([x, y, -foot_h])
                cylinder(h = foot_h, r = foot_r, $fn = 16);
}

// Center support panel - frame style with groove on top
module center_support() {
    border = 10;  // frame border width
    
    difference() {
        cube([center_w, rail_thick, center_rail_h]);
        
        // Cut out center to make frame (save material)
        translate([border, -1, border])
            cube([center_w - 2*border, rail_thick + 2, center_rail_h - 2*border - slot_d]);
    }
    
    // Groove along the top edge
    translate([0, (rail_thick - groove_rail_w)/2, center_rail_h - slot_d])
        difference() {
            cube([center_w, groove_rail_w, slot_d]);
            translate([0, wall, 0])
                cube([center_w, slot_w, slot_d + 1]);
        }
    
    // Groove along the bottom edge (connects to base groove)
    translate([0, (rail_thick - groove_rail_w)/2, 0])
        difference() {
            cube([center_w, groove_rail_w, slot_d]);
            translate([0, wall, 0])
                cube([center_w, slot_w, slot_d + 1]);
        }
}

// Wing rail panel - holds side card flap
module wing_rail(width) {
    border = 8;
    
    difference() {
        cube([width, rail_thick, wing_rail_h]);
        
        // Frame cutout if wide enough
        if (width > 3 * border) {
            translate([border, -1, border])
                cube([width - 2*border, rail_thick + 2, wing_rail_h - 2*border - slot_d]);
        }
    }
    
    // Groove along inner edge (top when folded)
    translate([0, (rail_thick - groove_rail_w)/2, wing_rail_h - slot_d])
        difference() {
            cube([width, groove_rail_w, slot_d]);
            translate([0, wall, 0])
                cube([width, slot_w, slot_d + 1]);
        }
}

// Top rail strip - holds top "happy birthday" flap
module top_rail() {
    cube([center_w, rail_thick, top_rail_h]);
    
    // Groove along bottom edge
    translate([0, (rail_thick - groove_rail_w)/2, 0])
        difference() {
            cube([center_w, groove_rail_w, slot_d]);
            translate([0, wall, 0])
                cube([center_w, slot_w, slot_d + 1]);
        }
}

// Living hinge - thin bridges connecting two panels
module living_hinge(length) {
    spacing = (length - hinge_bridges * hinge_bridge_w) / (hinge_bridges + 1);
    
    for (i = [0 : hinge_bridges - 1]) {
        x_pos = spacing + i * (hinge_bridge_w + spacing);
        translate([x_pos, 0, 0])
            cube([hinge_bridge_w, hinge_gap, hinge_bridge_t]);
    }
}

// 45-degree angle stop bracket (triangle)
module angle_stop_bracket() {
    // Right triangle that props wing at 45 degrees
    linear_extrude(height = bracket_thick)
        polygon(points = [
            [0, 0],
            [bracket_size, 0],
            [0, bracket_size]
        ]);
}

// ============================================================
// FLAT LAYOUT (for printing)
// ============================================================
module flat_layout() {
    // --- Base plate (bottom of cross) ---
    translate([left_w + hinge_gap, 0, 0])
        base_plate();
    
    // --- Hinge: base to center ---
    translate([left_w + hinge_gap, base_depth + hinge_gap/2, 0])
        living_hinge(center_w);
    
    // --- Center support (middle of cross) ---
    // Lay flat for printing: the center panel lies on its back
    translate([left_w + hinge_gap, base_depth + hinge_gap, 0])
        cube([center_w, center_rail_h, rail_thick]);
    
    // Center panel grooves (printed as raised features on the flat panel)
    // Bottom groove (near base)
    translate([left_w + hinge_gap, base_depth + hinge_gap, rail_thick])
        difference() {
            cube([center_w, groove_rail_w, slot_d]);
            translate([0, wall, 0])
                cube([center_w, slot_w, slot_d + 1]);
        }
    // Top groove (far from base)
    translate([left_w + hinge_gap, base_depth + hinge_gap + center_rail_h - groove_rail_w, rail_thick])
        difference() {
            cube([center_w, groove_rail_w, slot_d]);
            translate([0, wall, 0])
                cube([center_w, slot_w, slot_d + 1]);
        }
    
    // --- Hinge: center to top rail ---
    translate([left_w + hinge_gap, base_depth + hinge_gap + center_rail_h + hinge_gap/2, 0])
        living_hinge(center_w);
    
    // --- Top rail (top of cross) ---
    translate([left_w + hinge_gap, base_depth + 2*hinge_gap + center_rail_h, 0])
        cube([center_w, top_rail_h, rail_thick]);
    
    // Top rail groove
    translate([left_w + hinge_gap, base_depth + 2*hinge_gap + center_rail_h, rail_thick])
        difference() {
            cube([center_w, groove_rail_w, slot_d]);
            translate([0, wall, 0])
                cube([center_w, slot_w, slot_d + 1]);
        }
    
    // --- Hinge: center to left wing ---
    center_y_mid = base_depth + hinge_gap + center_rail_h / 2;
    
    translate([left_w + hinge_gap/2, center_y_mid - left_w/2, 0])
        rotate([0, 0, 90])
            living_hinge(left_w);
    
    // --- Left wing (left of cross) ---
    translate([0, center_y_mid - wing_rail_h/2, 0])
        cube([left_w, wing_rail_h, rail_thick]);
    
    // Left wing groove
    translate([left_w - groove_rail_w, center_y_mid - wing_rail_h/2, rail_thick])
        difference() {
            cube([groove_rail_w, wing_rail_h, slot_d]);
            translate([wall, 0, 0])
                cube([slot_w, wing_rail_h, slot_d + 1]);
        }
    
    // --- Hinge: center to right wing ---
    translate([left_w + hinge_gap + center_w + hinge_gap/2, center_y_mid - right_w/2, 0])
        rotate([0, 0, 90])
            living_hinge(right_w);
    
    // --- Right wing (right of cross) ---
    translate([left_w + 2*hinge_gap + center_w, center_y_mid - wing_rail_h/2, 0])
        cube([right_w, wing_rail_h, rail_thick]);
    
    // Right wing groove
    translate([left_w + 2*hinge_gap + center_w, center_y_mid - wing_rail_h/2, rail_thick])
        difference() {
            cube([groove_rail_w, wing_rail_h, slot_d]);
            translate([wall, 0, 0])
                cube([slot_w, wing_rail_h, slot_d + 1]);
        }
    
    // --- Angle stop brackets (printed flat, fold up) ---
    // Left bracket pair
    translate([left_w + hinge_gap - bracket_size - 2, base_depth + hinge_gap + 5, 0])
        cube([bracket_size, bracket_thick, bracket_size]);
    translate([left_w + hinge_gap - bracket_size - 2, base_depth + hinge_gap + center_rail_h - bracket_thick - 5, 0])
        cube([bracket_size, bracket_thick, bracket_size]);
    
    // Right bracket pair
    translate([left_w + hinge_gap + center_w + 2, base_depth + hinge_gap + 5, 0])
        cube([bracket_size, bracket_thick, bracket_size]);
    translate([left_w + hinge_gap + center_w + 2, base_depth + hinge_gap + center_rail_h - bracket_thick - 5, 0])
        cube([bracket_size, bracket_thick, bracket_size]);
}

// ============================================================
// FOLDED PREVIEW (assembled view)
// ============================================================
module folded_preview() {
    color([0.95, 0.95, 0.95]) {
        // Base plate - flat on table (XY plane)
        base_plate();
        
        // Center support - vertical, rising from back edge of base
        translate([0, base_depth, 0])
            rotate([90, 0, 0])
                translate([0, 0, -rail_thick])
                    center_support();
        
        // Top rail - vertical, on top of center support
        translate([0, base_depth, center_rail_h])
            rotate([90, 0, 0])
                translate([0, 0, -rail_thick])
                    top_rail();
        
        // Left wing - angled 45° outward from center
        translate([0, base_depth, 0])
            rotate([0, 0, 0])
                rotate([90 - wing_angle, 0, 0])
                    translate([-(left_w + hinge_gap), 0, 0])
                        wing_rail(left_w);
        
        // Right wing - angled 45° outward from center (mirror)
        translate([center_w, base_depth, 0])
            rotate([0, 0, 0])
                rotate([90 - wing_angle, 0, 0])
                    translate([hinge_gap, 0, 0])
                        wing_rail(right_w);
    }
    
    // Semi-transparent card panels for visualization
    card_alpha = 0.3;
    
    // Center card panel
    color([1, 0.9, 0.8], card_alpha)
        translate([0, base_depth + wall, slot_d])
            cube([center_w, 0.5, center_h - slot_d]);
    
    // Bottom card flap (in base groove)
    color([1, 0.9, 0.8], card_alpha)
        translate([0, 0, base_thick])
            cube([center_w, bottom_h * 0.3, 0.5]);
}

// ============================================================
// RENDER
// ============================================================
if (folded_preview) {
    folded_preview();
} else {
    flat_layout();
}

// ============================================================
// PRINTING NOTES
// ============================================================
echo("=== PRINTING INSTRUCTIONS ===");
echo("Printer: Bambu Lab A1");
echo("Material: White PLA");
echo("Layer height: 0.2mm");
echo("Infill: 20% grid");
echo("Supports: NONE (prints flat)");
echo("Bed adhesion: Brim recommended");
echo("After printing: Gently fold along living hinges.");
echo("  1. Fold center support up 90° from base");
echo("  2. Fold left/right wings to 45° outward");
echo("  3. Fold top rail to continue center vertically");
echo("  4. Slide card panels into grooves");
echo("If a hinge breaks, glue at desired angle.");
echo("Test print: Export just a 20mm groove strip first to verify card fit.");
