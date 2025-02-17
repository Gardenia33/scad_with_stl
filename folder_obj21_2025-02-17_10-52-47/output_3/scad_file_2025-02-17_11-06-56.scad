//==================================================
// Parameters (adjusted to match original model more closely)
//==================================================

// Central cylinder parameters (smooth, uniform diameter)
central_cylinder_diameter = 60;  // Uniform diameter; removed extra ridges
central_cylinder_length = 60;    // Keep length the same

// Flange parameters (simplified shape, thinner)
flange_diameter = 70;
flange_thickness = 4;    // Reduced for simpler, flatter flange
bolt_circle_radius = 35;  // Spacing remains the same

// Spacer ring parameters (thinner, simpler)
spacer_ring_thickness = 3; // Reduced thickness for simpler ring

// Bolt & nut parameters (smaller, flush alignment)
bolt_shank_diameter = 3;    // Slightly smaller diameter
bolt_length = 10;           // Shorter overall length
bolt_head_diameter = 6;     // Reduced for a smaller hex head
bolt_head_height = 3;       // Slightly lower profile head

nut_diameter = 8;           // Smaller across-flats dimension
nut_height = 4;             // Reduced nut height

num_bolts = 8;              // Number of bolts

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
// Module: Central Cylinder (smooth, uniform)
//==================================================
module central_cylinder() {
    // Single smooth, uniform cylinder
    cylinder(d = central_cylinder_diameter, 
             h = central_cylinder_length, 
             center=true, 
             $fn=100);
}

//==================================================
// Module: Flange Plate (simplified circular form)
//==================================================
module flange_plate() {
    difference() {
        // Outer flange
        cylinder(d=flange_diameter, 
                 h=flange_thickness, 
                 center=true, 
                 $fn=100);
        
        // Bolt holes, slightly larger than shank
        bolt_positions() {
            cylinder(d = bolt_shank_diameter + 1, 
                     h = flange_thickness + 2, 
                     center=true, 
                     $fn=100);
        }
    }
}

//==================================================
// Module: Spacer Ring (simpler, thin ring)
//==================================================
module spacer_ring() {
    difference() {
        // Outer cylindrical ring
        cylinder(d = flange_diameter, 
                 h = spacer_ring_thickness, 
                 center=true, 
                 $fn=100);
        
        // Subtract inner area to fit over central cylinder
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
        translate([0, 0, 0])  
            cylinder(d = bolt_shank_diameter, 
                     h = bolt_length, 
                     center=false, 
                     $fn=100);
        
        // Hexagonal head on top
        translate([0, 0, bolt_length]) 
            cylinder(d = bolt_head_diameter, 
                     h = bolt_head_height, 
                     center=false, 
                     $fn=6); // 6 facets for a hex
    }
}

//==================================================
// Module: Nut (hex shape, smaller profile)
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
    // Main central cylinder
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
    
    // Bolts & Nuts (smaller, aligned more flush)
    bolt_positions() {
        // Top bolt (head flush with top flange)
        translate([0, 0, central_cylinder_length/2 + spacer_ring_thickness + flange_thickness/2])
            rotate([180, 0, 0])  // Shank points downward
            bolt();
        
        // Bottom bolt (head flush with bottom flange)
        translate([0, 0, -(central_cylinder_length/2 + spacer_ring_thickness + flange_thickness/2)])
            bolt();
        
        // Top nut (near top bolt end)
        translate([0, 0, 
            (central_cylinder_length/2 + spacer_ring_thickness + flange_thickness/2)
            + bolt_length + 0.5])
            nut();
        
        // Bottom nut (near bottom bolt end)
        translate([0, 0, 
            -(central_cylinder_length/2 + spacer_ring_thickness + flange_thickness/2)
            - nut_height - 0.5])
            nut();
    }
}

//==================================================
// Render the coupling
//==================================================
coupling();
