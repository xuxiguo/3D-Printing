// ========================================================
// Family Birthday Card Display Stand
// ========================================================
//
// Designed for: Bambu Lab A1 - White PLA
// Layer height: 0.20mm, 15% infill, no supports needed
//
// Card dimensions (from hand-drawn sketch):
//   Center panel:  4.25" wide × 5.5" tall  (108 × 140 mm)
//   Side panels:   2.0"  wide × 5.5" tall  ( 51 × 140 mm each)
//   Top/Bot flaps: 4.25" wide × 2.625" tall (108 × 67 mm)
//
// Display layout (top-down view):
//
//   VIEWER
//     |
//     |   ___________
//     |  |           |   <- center panel faces viewer
//     |   \         /
//     |    \       /     <- side panels at 45° fanning backward
//     |     \_____/
//     |      (base)
//
// Build footprint: ~210 × 66 × 15 mm  (fits Bambu Lab A1 256×256mm bed)
// ========================================================

$fn = 48;

// ---- Card Dimensions (inches → mm) ----
CENTER_W = 4.25 * 25.4;    // 107.95 mm — center panel width
CENTER_H = 5.5  * 25.4;    // 139.70 mm — center panel height
SIDE_W   = 2.0  * 25.4;    //  50.80 mm — side panel width
FLAP_H   = 2.625 * 25.4;   //  66.68 mm — top / bottom flap height

// ---- Slot Parameters ----
// Adjust SLOT_W if card feels too tight or too loose after printing.
// Typical card stock + photo: 1.5–2.5 mm thick.
SLOT_W     = 2.8;   // slot opening width (paper thickness + clearance)
SLOT_DEPTH = 12.0;  // how deep card edge sits in slot (grip / stability)

// ---- Base Geometry ----
BASE_H   = 15.0;    // total base thickness (must be ≥ SLOT_DEPTH)
BORDER   = 16.0;    // material margin around active slot area
CORNER_R = 10.0;    // rounded-corner radius for aesthetics

// ---- Derived Values ----
ANGLE   = 45.0;
SIDE_DX = SIDE_W * cos(ANGLE);   // x-projection of side panel: ~35.9 mm
SIDE_DY = SIDE_W * sin(ANGLE);   // y-projection of side panel: ~35.9 mm

BASE_W = CENTER_W + 2*SIDE_DX + 2*BORDER;  // ≈ 208 mm
BASE_D = SIDE_DY + 2*BORDER;               // ≈  68 mm

CX     = BASE_W / 2;   // x-centre of base
Y_SLOT = BORDER;       // y-position of center-slot line (front of active zone)

// -- Console output for verification --
echo(str("=== DISPLAY STAND ==="));
echo(str("Width  : ", round(BASE_W*10)/10, " mm  (", round(BASE_W/25.4*10)/10, " in)"));
echo(str("Depth  : ", round(BASE_D*10)/10, " mm  (", round(BASE_D/25.4*10)/10, " in)"));
echo(str("Height : ", BASE_H, " mm"));
echo(str("Fits A1: ", BASE_W < 256 && BASE_D < 256 ? "YES" : "NO"));

// ========================================================
//  HELPER MODULES
// ========================================================

module rounded_plate(w, d, h, r) {
    hull() {
        translate([r,   r,   0]) cylinder(r=r, h=h);
        translate([w-r, r,   0]) cylinder(r=r, h=h);
        translate([r,   d-r, 0]) cylinder(r=r, h=h);
        translate([w-r, d-r, 0]) cylinder(r=r, h=h);
    }
}

// ========================================================
//  SLOT CUTS  (all extend from z = BASE_H−SLOT_DEPTH to z = BASE_H)
// ========================================================

// Center panel slot — runs left-right along front of base
module center_slot() {
    translate([CX - CENTER_W/2,
               Y_SLOT - SLOT_W/2,
               BASE_H - SLOT_DEPTH])
        cube([CENTER_W, SLOT_W, SLOT_DEPTH + 1]);
}

// Left panel slot — angles 135° (back-left) from left junction
module left_slot() {
    translate([CX - CENTER_W/2, Y_SLOT, BASE_H - SLOT_DEPTH])
        rotate([0, 0, 135])
            translate([0, -SLOT_W/2, 0])
                cube([SIDE_W + 6, SLOT_W, SLOT_DEPTH + 1]);
}

// Right panel slot — angles 45° (back-right) from right junction
module right_slot() {
    translate([CX + CENTER_W/2, Y_SLOT, BASE_H - SLOT_DEPTH])
        rotate([0, 0, 45])
            translate([0, -SLOT_W/2, 0])
                cube([SIDE_W + 6, SLOT_W, SLOT_DEPTH + 1]);
}

// Cylindrical relief at each junction — prevents card from binding at corners
// and gives a clean transition between slots
module junction_relief(x, y) {
    translate([x, y, BASE_H - SLOT_DEPTH])
        cylinder(r = SLOT_W * 0.9, h = SLOT_DEPTH + 1);
}

// ========================================================
//  MAIN MODEL
// ========================================================

module stand() {
    difference() {
        // Solid base plate with rounded corners
        rounded_plate(BASE_W, BASE_D, BASE_H, CORNER_R);

        // Slots for the three card sections
        center_slot();
        left_slot();
        right_slot();

        // Smooth the T-junctions so the card corners slide in cleanly
        junction_relief(CX - CENTER_W/2, Y_SLOT);
        junction_relief(CX + CENTER_W/2, Y_SLOT);
    }
}

stand();

// ========================================================
//  USAGE NOTES
// ========================================================
//
//  1. Open the card fully so all three panels are separated.
//  2. Insert the bottom edge of the CENTER panel into the
//     horizontal slot (front-center of base).
//  3. Insert the LEFT side panel into the diagonal slot on
//     the left — it naturally angles 45° backward.
//  4. Insert the RIGHT side panel into the diagonal slot on
//     the right — mirrors the left.
//  5. The TOP "Happy Birthday" flap rests forward at whatever
//     angle it naturally folds (approx 45°–60°).
//  6. The BOTTOM children's-drawing flap rests flat against
//     the front face of the base or folds under the stand.
//
//  PRINT SETTINGS (Bambu Lab A1):
//    Material : PLA - White
//    Layer    : 0.20 mm
//    Infill   : 15 % Gyroid
//    Supports : None required
//    Plate    : Print flat (Z = height of stand)
// ========================================================
