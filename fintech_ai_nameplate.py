#!/usr/bin/env python3
"""
FreeCAD Script: FINTECH × AI Nameplate
Creates a 3D printable nameplate with raised text for Bambu Lab X1

Design specs:
- Black rectangular base plate (3mm thick)
- Raised text (3-4mm above base, total height 6-7mm)
- FINTECH: Blue, strong upright font, centered left
- ×: Gray, enlarged (~130%), center
- AI: White, italic, slanted forward, centered right
"""

import FreeCAD as App
import Draft
import Part
import Sketcher

# Clear existing document or create new one
try:
    App.closeDocument("NameplateDoc")
except:
    pass

doc = App.newDocument("NameplateDoc")

# Design parameters
PLATE_WIDTH = 120.0      # mm
PLATE_HEIGHT = 40.0      # mm
BASE_THICKNESS = 3.0     # mm
TEXT_HEIGHT = 3.5        # mm (raised above base)
TOTAL_HEIGHT = BASE_THICKNESS + TEXT_HEIGHT

FONT_SIZE_FINTECH = 12.0  # mm
FONT_SIZE_X = 8.0         # mm (will be scaled to 130%)
FONT_SIZE_AI = 12.0       # mm

# Create base plate
print("Creating base plate...")
base_plate = Part.makeBox(PLATE_WIDTH, PLATE_HEIGHT, BASE_THICKNESS)
base_obj = doc.addObject("Part::Feature", "BasePlate")
base_obj.Shape = base_plate
base_obj.ViewObject.ShapeColor = (0.0, 0.0, 0.0)  # Black

# Create text objects using Draft.makeText (ShapeString alternative)
print("Creating FINTECH text...")
try:
    # Create FINTECH text
    fintech_text = Draft.makeShapeString("FINTECH", FontFile="", Size=FONT_SIZE_FINTECH, Tracking=0)
    fintech_text.Label = "FintechText"
    
    # Position FINTECH on left side
    fintech_text.Placement.Base = App.Vector(10.0, PLATE_HEIGHT/2 - FONT_SIZE_FINTECH/2, BASE_THICKNESS)
    
    # Extrude FINTECH text
    fintech_solid = doc.addObject("Part::Extrusion", "FintechSolid")
    fintech_solid.Base = fintech_text
    fintech_solid.Dir = App.Vector(0, 0, TEXT_HEIGHT)
    fintech_solid.Solid = True
    fintech_solid.ViewObject.ShapeColor = (0.0, 0.0, 1.0)  # Blue
    
except Exception as e:
    print(f"Error creating FINTECH text: {e}")
    # Fallback: create a simple box as placeholder
    fintech_box = Part.makeBox(35, 8, TEXT_HEIGHT)
    fintech_solid = doc.addObject("Part::Feature", "FintechSolid")
    fintech_solid.Shape = fintech_box
    fintech_solid.Placement.Base = App.Vector(10.0, 16.0, BASE_THICKNESS)
    fintech_solid.ViewObject.ShapeColor = (0.0, 0.0, 1.0)  # Blue

print("Creating × symbol...")
try:
    # Create × symbol (multiply sign)
    x_text = Draft.makeShapeString("×", FontFile="", Size=FONT_SIZE_X * 1.3, Tracking=0)  # 130% size
    x_text.Label = "XText"
    
    # Position × in center
    x_text.Placement.Base = App.Vector(PLATE_WIDTH/2 - 3, PLATE_HEIGHT/2 - FONT_SIZE_X/2, BASE_THICKNESS)
    
    # Extrude × text
    x_solid = doc.addObject("Part::Extrusion", "XSolid")
    x_solid.Base = x_text
    x_solid.Dir = App.Vector(0, 0, TEXT_HEIGHT)
    x_solid.Solid = True
    x_solid.ViewObject.ShapeColor = (0.5, 0.5, 0.5)  # Gray
    
except Exception as e:
    print(f"Error creating × text: {e}")
    # Fallback: create a simple cross shape
    cross1 = Part.makeBox(8, 2, TEXT_HEIGHT)
    cross2 = Part.makeBox(2, 8, TEXT_HEIGHT)
    cross_shape = cross1.fuse(cross2)
    x_solid = doc.addObject("Part::Feature", "XSolid")
    x_solid.Shape = cross_shape
    x_solid.Placement.Base = App.Vector(PLATE_WIDTH/2 - 4, PLATE_HEIGHT/2 - 4, BASE_THICKNESS)
    x_solid.ViewObject.ShapeColor = (0.5, 0.5, 0.5)  # Gray

print("Creating AI text...")
try:
    # Create AI text
    ai_text = Draft.makeShapeString("AI", FontFile="", Size=FONT_SIZE_AI, Tracking=0)
    ai_text.Label = "AIText"
    
    # Position AI on right side with italic slant
    ai_text.Placement.Base = App.Vector(PLATE_WIDTH - 25, PLATE_HEIGHT/2 - FONT_SIZE_AI/2, BASE_THICKNESS)
    # Add slight forward slant (italic effect) - rotate around Y axis
    ai_text.Placement.Rotation = App.Rotation(App.Vector(0, 1, 0), 15)  # 15 degree forward slant
    
    # Extrude AI text
    ai_solid = doc.addObject("Part::Extrusion", "AISolid")
    ai_solid.Base = ai_text
    ai_solid.Dir = App.Vector(0, 0, TEXT_HEIGHT)
    ai_solid.Solid = True
    ai_solid.ViewObject.ShapeColor = (1.0, 1.0, 1.0)  # White
    
except Exception as e:
    print(f"Error creating AI text: {e}")
    # Fallback: create simple boxes for A and I
    a_box = Part.makeBox(8, 8, TEXT_HEIGHT)
    i_box = Part.makeBox(3, 8, TEXT_HEIGHT)
    ai_shape = a_box.fuse(i_box.translated(App.Vector(10, 0, 0)))
    ai_solid = doc.addObject("Part::Feature", "AISolid")
    ai_solid.Shape = ai_shape
    ai_solid.Placement.Base = App.Vector(PLATE_WIDTH - 25, 16, BASE_THICKNESS)
    ai_solid.ViewObject.ShapeColor = (1.0, 1.0, 1.0)  # White

# Create final fusion of all parts
print("Creating final nameplate...")
try:
    # Fuse all parts together
    fusion = doc.addObject("Part::MultiFuse", "NameplateFinal")
    fusion.Shapes = [base_obj, fintech_solid, x_solid, ai_solid]
    fusion.ViewObject.ShapeColor = (0.2, 0.2, 0.2)  # Dark gray for combined view
    
    # Hide individual components
    base_obj.ViewObject.Visibility = False
    fintech_solid.ViewObject.Visibility = False
    x_solid.ViewObject.Visibility = False
    ai_solid.ViewObject.Visibility = False
    
except Exception as e:
    print(f"Error creating fusion: {e}")
    print("Individual parts remain visible")

# Recompute the document
doc.recompute()

# Set view to fit all
try:
    import FreeCADGui as Gui
    Gui.activeDocument().activeView().fitAll()
    Gui.SendMsgToActiveView("ViewFit")
except:
    pass

print(f"""
Nameplate created successfully!

Dimensions:
- Width: {PLATE_WIDTH}mm
- Height: {PLATE_HEIGHT}mm  
- Total thickness: {TOTAL_HEIGHT}mm
- Base plate: {BASE_THICKNESS}mm
- Text height: {TEXT_HEIGHT}mm

For Bambu Lab X1 printing:
1. Export as STL: File → Export → Select STL format
2. In Bambu Studio:
   - Use 0.2mm layer height for good text detail
   - Support: None needed (text is raised, not hanging)
   - Infill: 15-20% is sufficient
   - Print speed: Normal/Standard
   - Material suggestions:
     * Base: Black PETG or PLA
     * Text: Blue, Gray, White filament (if printing separately)
     * Or print as single color and paint afterward

3. For multi-color printing:
   - Export each text part separately as STL
   - Use filament change at appropriate layers
   - Or print base first, then text parts separately and glue

4. Post-processing:
   - Light sanding of text edges if needed
   - Paint text in desired colors if printed in single color

Next steps:
- Review the model in FreeCAD
- Export to STL when satisfied
- Import STL into Bambu Studio for slicing
""")
