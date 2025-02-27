
// Parameters
clamp_diameter = 30;
clamp_length = 20;
shaft_hole_diameter = 10;
fastener_hole_diameter = 5;
fastener_hole_offset = 10;
slit_width = 1;
cutout_depth = 5;
cutout_width = 8;
flexible_element_thickness = 3;
screw_head_diameter = 8;
screw_length = 12;
groove_depth = 3;
groove_width = 5;

// Module for a single clamping half
module clamping_half() {
    difference() {
        // Main cylindrical body
        cylinder(d=clamp_diameter, h=clamp_length, center=true);
        
        // Shaft hole
        cylinder(d=shaft_hole_diameter, h=clamp_length+2, center=true);
        
        // Fastener holes
        for (angle = [120, 240]) {
            rotate([0, 0, angle])
                translate([fastener_hole_offset, 0, 0])
                cylinder(d=fastener_hole_diameter, h=clamp_length+2, center=true);
        }
        
        // Slit for clamping action
        translate([-clamp_diameter/2, 0, 0])
            cube([clamp_diameter, slit_width, clamp_length+2], center=true);
        
        // Side cutouts for flexible element
        for (z_offset = [-clamp_length/4, clamp_length/4]) {
            translate([0, 0, z_offset])
                rotate([0, 90, 0])
                cylinder(d=cutout_width, h=cutout_depth, center=true);
        }
        
        // Additional grooves for flexibility
        for (z_offset = [-clamp_length/3, clamp_length/3]) {
            translate([0, 0, z_offset])
                rotate([0, 90, 0])
                cylinder(d=groove_width, h=groove_depth, center=true);
        }
    }
}

// Module for the flexible element
module flexible_element() {
    difference() {
        // Main flexible insert
        cube([clamp_diameter, flexible_element_thickness, clamp_length], center=true);
        
        // Cutouts to fit into the clamping halves
        for (z_offset = [-clamp_length/4, clamp_length/4]) {
            translate([0, 0, z_offset])
                rotate([0, 90, 0])
                cylinder(d=cutout_width, h=cutout_depth, center=true);
        }
    }
}

// Module for fastening screws
module fastening_screw() {
    union() {
        // Screw body
        cylinder(d=fastener_hole_diameter, h=screw_length, center=true);
        
        // Screw head
        translate([0, 0, screw_length/2])
            cylinder(d=screw_head_diameter, h=fastener_hole_diameter/2, center=true);
    }
}

// Assemble the coupling
module flexible_coupling() {
    // Top clamping half
    translate([0, 0, clamp_length/2])
        clamping_half();
    
    // Bottom clamping half (mirrored)
    translate([0, 0, -clamp_length/2])
        mirror([0, 0, 1])
        clamping_half();
    
    // Flexible element
    flexible_element();
    
    // Fastening screws
    for (angle = [120, 240]) {
        rotate([0, 0, angle])
            translate([fastener_hole_offset, 0, 0])
            fastening_screw();
    }
}

// Render the model
flexible_coupling();

