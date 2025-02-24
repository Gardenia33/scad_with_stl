
//==================================================
// Parameters (adjust these to match original model more closely)
//==================================================

// Central cylinder parameters
central_cylinder_diameter = 60; // Increased diameter for closer match and more robustness
central_cylinder_length = 60;   // Keep as is or adjust if original was longer/shorter

// Reinforcement rings for central cylinder
num_reinforcement_rings = 2;      // Number of reinforcement rings around central cylinder
reinforcement_ring_diameter = 70; // Outer diameter of reinforcement rings
reinforcement_ring_thickness = 4; // Thickness of each ring
reinforcement_ring_spacing = 15;  // Spacing between rings (center-to-center along the cylinder height)

// Flange parameters (thicker and more pronounced)
flange_diameter = 70;
flange_thickness = 6; // Increased thickness for a closer match
bolt_circle_radius = 35; // Slightly increased to match larger central diameter

// Spacer ring parameters (clearly defined and thicker)
spacer_ring_thickness = 8; // Increased thickness for more distinct appearance

// Bolt & nut parameters (redesigned with hex head, hex nut, and taller bolts)
bolt_shank_diameter = 4;   // Diameter of the bolt shank
bolt_length = 15;          // Longer bolt to match original model’s proportions
bolt_head_diameter = 8;    // Across-flats dimension for hex head (approx)
bolt_head_height = 4;      // Height of the hex head

nut_diameter = 12;         // Across-flats dimension for hex nut (approx)
nut_height = 6;            // Height of the hex nut

num_bolts = 8;             // Number of bolts (evenly spaced)

//==================================================
// Utility function: Position items at angles
//==================================================
module bolt_positions() {
    for (i = [0 : num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([
            bolt_circle_radius * cos(angle),
            bolt_circle_radius * sin(angle),
            0
        ])
        children();
    }
}

//==================================================
// Module: Central Cylinder with Reinforcement Rings
//==================================================
module central_cylinder() {
    union() {
        // Main cylinder
        cylinder(d = central_cylinder_diameter, h = central_cylinder_length, center=true, $fn=100);
        
        // Add multiple reinforcement rings
        if(num_reinforcement_rings > 0) {
            for(ringIndex = [0 : num_reinforcement_rings-1]) {
                // Position rings evenly along cylinder length
                zOffset = 
                    ( (ringIndex - (num_reinforcement_rings-1)/2) 
                      * reinforcement_ring_spacing );
                
                difference() {
                    translate([0,0,zOffset]) 
                        cylinder(d = reinforcement_ring_diameter, 
                                 h = reinforcement_ring_thickness, 
                                 center=true, 
                                 $fn=100);
                    // Subtract inner cylinder area
                    translate([0,0,zOffset]) 
                        cylinder(d = central_cylinder_diameter, 
                                 h = reinforcement_ring_thickness + 0.1, 
                                 center=true, 
                                 $fn=100);
                }
            }
        }
    }
}

//==================================================
// Module: Flange Plate (Thicker, with bolt holes)
//==================================================
module flange_plate() {
    difference() {
        // Outer flange
        cylinder(d=flange_diameter, h=flange_thickness, center=true, $fn=100);
        
        // Bolt holes
        bolt_positions() {
            // Make holes slightly larger to accommodate bolt_shank_diameter
            cylinder(d = bolt_shank_diameter + 1, 
                     h = flange_thickness + 2, 
                     center=true, 
                     $fn=100);
        }
    }
}

//==================================================
// Module: Spacer Ring (Thicker, clearly defined)
//==================================================
module spacer_ring() {
    difference() {
        // Outer visible ring
        cylinder(d = flange_diameter, 
                 h = spacer_ring_thickness, 
                 center=true, 
                 $fn=100);
        
        // Subtract inner area equal to the central cylinder
        cylinder(d = central_cylinder_diameter, 
                 h = spacer_ring_thickness + 0.1, 
                 center=true, 
                 $fn=100);
    }
}

//==================================================
// Module: Bolt (hex head + cylindrical shank)
//==================================================
module bolt() {
    union() {
        // Cylindrical shank
        translate([0, 0, 0])  // reference bottom at z=0
            cylinder(d = bolt_shank_diameter, 
                     h = bolt_length, 
                     center=false, 
                     $fn=100);
        
        // Hexagonal head on top
        // Place hex head so its bottom is flush with top of shank
        translate([0, 0, bolt_length]) 
            cylinder(d = bolt_head_diameter, 
                     h = bolt_head_height, 
                     center=false, 
                     $fn=6); // 6 facets for a hex
    }
}

//==================================================
// Module: Nut (hex shape)
//==================================================
module nut() {
    cylinder(d = nut_diameter, 
             h = nut_height, 
             center=false, 
             $fn=6); // 6 facets for a hex
}

//==================================================
// Module: Assembly
//==================================================
module coupling() {
    // Main central cylinder with reinforcements
    central_cylinder();
    
    // Top flange
    translate([0, 0, central_cylinder_length/2 + spacer_ring_thickness + flange_thickness/2])
        flange_plate();
    // Bottom flange
    translate([0, 0, -central_cylinder_length/2 - spacer_ring_thickness - flange_thickness/2])
        flange_plate();
    
    // Top spacer ring
    translate([0, 0, central_cylinder_length/2 + spacer_ring_thickness/2])
        spacer_ring();
    // Bottom spacer ring
    translate([0, 0, -central_cylinder_length/2 - spacer_ring_thickness/2])
        spacer_ring();
    
    // Bolts & Nuts
    bolt_positions() {
        // Top bolt (shank goes downward from the head)
        translate([0, 0, (central_cylinder_length/2 + spacer_ring_thickness + flange_thickness) ])
            rotate([180, 0, 0]) // flip so bolt shank goes into the assembly
            bolt();
        
        // Bottom bolt (shank goes upward from the head)
        translate([0, 0, -(central_cylinder_length/2 + spacer_ring_thickness + flange_thickness) ])
            bolt();
        
        // Top nut (sit on top of the top flange - above bolt head)
        translate([0, 0, (central_cylinder_length/2 + spacer_ring_thickness + flange_thickness) + bolt_length + 1])
            nut();
        
        // Bottom nut (sit on the bottom flange - below bolt shank)
        translate([0, 0, -(central_cylinder_length/2 + spacer_ring_thickness + flange_thickness) - nut_height - 1])
            nut();
    }
}

//==================================================
// Render the coupling
//==================================================
coupling();

