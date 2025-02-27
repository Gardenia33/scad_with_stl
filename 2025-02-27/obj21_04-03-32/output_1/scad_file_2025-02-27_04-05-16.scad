
// Parameters
cylinder_diameter = 50;
cylinder_height = 100; // Increased height for a more extended cylindrical body
flange_diameter = 70;
flange_thickness = 8; // Increased thickness for better definition
spacer_thickness = 5; // Adjusted for proper spacing
bolt_diameter = 5;
bolt_length = 15; // Shortened to match the original model
nut_diameter = 8;
nut_thickness = 4;
bolt_hole_radius = 3;
num_bolts = 8; // Increased number of bolts to match the original model
bolt_circle_radius = 30;

// Function to create a bolt hole pattern
module bolt_holes() {
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), 0])
            cylinder(h = flange_thickness * 2, r = bolt_hole_radius, center = true);
    }
}

// Central cylindrical body
module central_cylindrical_body() {
    difference() {
        cylinder(h = cylinder_height, r = cylinder_diameter / 2, center = true);
    }
}

// End plate
module end_plate() {
    difference() {
        cylinder(h = flange_thickness, r = flange_diameter / 2, center = true);
        bolt_holes();
    }
}

// Coupling flange
module coupling_flange() {
    difference() {
        cylinder(h = flange_thickness, r = flange_diameter / 2, center = true);
        bolt_holes();
    }
}

// Spacer ring
module spacer_ring() {
    difference() {
        cylinder(h = spacer_thickness, r = flange_diameter / 2, center = true);
        cylinder(h = spacer_thickness * 2, r = cylinder_diameter / 2, center = true);
    }
}

// Bolt
module bolt() {
    translate([0, 0, -bolt_length / 2])
        cylinder(h = bolt_length, r = bolt_diameter / 2, center = true);
}

// Nut
module nut() {
    translate([0, 0, nut_thickness / 2])
        cylinder(h = nut_thickness, r = nut_diameter / 2, center = true);
}

// Assembly
module coupling_assembly() {
    translate([0, 0, cylinder_height / 2 + flange_thickness])
        end_plate();
    
    translate([0, 0, cylinder_height / 2])
        coupling_flange();
    
    translate([0, 0, cylinder_height / 2 - spacer_thickness])
        spacer_ring();
    
    central_cylindrical_body();
    
    translate([0, 0, -cylinder_height / 2 + spacer_thickness])
        spacer_ring();
    
    translate([0, 0, -cylinder_height / 2])
        coupling_flange();
    
    translate([0, 0, -cylinder_height / 2 - flange_thickness])
        end_plate();
    
    // Bolts and nuts
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), cylinder_height / 2 + flange_thickness])
            rotate([0, 0, angle])
                bolt();
        
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), cylinder_height / 2 + flange_thickness + bolt_length / 2])
            rotate([0, 0, angle])
                nut();
        
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), -cylinder_height / 2 - flange_thickness])
            rotate([0, 0, angle])
                bolt();
        
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), -cylinder_height / 2 - flange_thickness - bolt_length / 2])
            rotate([0, 0, angle])
                nut();
    }
}

// Render the coupling assembly
coupling_assembly();

