
// Parameters
hub_diameter = 50;
hub_height = 40; // Extended height for more refined shape
hub_hole_diameter = 20;
flange_diameter = 80;
flange_thickness = 3; // Reduced thickness for accuracy
spacer_thickness = 5; // More distinct spacer ring
bolt_diameter = 4; // Reduced bolt size
bolt_length = 40;
num_bolts = 18; // Increased number of bolts
bolt_circle_diameter = 70; // Adjusted for better alignment

// Main hub with additional details
module main_hub() {
    difference() {
        cylinder(h = hub_height, d = hub_diameter, center = true);
        cylinder(h = hub_height + 2, d = hub_hole_diameter, center = true);
        
        // Adding mounting grooves
        for (i = [0:5]) {
            angle = i * 360 / 6;
            translate([hub_diameter/2 * cos(angle), hub_diameter/2 * sin(angle), 0])
                rotate([0, 0, angle])
                cube([5, 2, hub_height], center = true);
        }
    }
}

// Flange plate with refined hole distribution
module flange_plate() {
    difference() {
        cylinder(h = flange_thickness, d = flange_diameter, center = true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), 0])
                cylinder(h = flange_thickness + 2, d = bolt_diameter, center = true);
        }
    }
}

// Spacer ring with distinct separation
module spacer_ring() {
    difference() {
        cylinder(h = spacer_thickness, d = flange_diameter, center = true);
        cylinder(h = spacer_thickness + 2, d = hub_diameter, center = true);
    }
}

// Bolt with adjusted size
module bolt() {
    cylinder(h = bolt_length, d = bolt_diameter, center = true);
}

// Nut with better alignment
module nut() {
    cylinder(h = 4, d = 6, center = true);
}

// Assembly with improved alignment
module coupling_assembly() {
    // Bottom flange plate
    translate([0, 0, -flange_thickness/2])
        flange_plate();
    
    // Spacer ring
    translate([0, 0, spacer_thickness/2])
        spacer_ring();
    
    // Top flange plate
    translate([0, 0, spacer_thickness + flange_thickness/2])
        flange_plate();
    
    // Main hub
    translate([0, 0, spacer_thickness + flange_thickness + hub_height/2])
        main_hub();
    
    // Bolts and nuts
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), -flange_thickness/2])
            bolt();
        translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), bolt_length/2])
            nut();
    }
}

// Render the assembly
coupling_assembly();

