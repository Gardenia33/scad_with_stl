
// Parameters
shaft_length = 40;
shaft_diameter = 20;
shaft_hole_diameter = 8;
flange_diameter = 40;
flange_thickness = 5;
bolt_hole_diameter = 5;
bolt_count = 6;
bolt_length = 15;
bolt_diameter = 5;
nut_diameter = 8;
nut_thickness = 4;
diaphragm_thickness = 1;
diaphragm_diameter = 38;
bolt_circle_radius = 15;

// Function to create a shaft
module shaft() {
    difference() {
        cylinder(h = shaft_length, d = shaft_diameter, center = true);
        cylinder(h = shaft_length + 2, d = shaft_hole_diameter, center = true);
    }
}

// Function to create a flange plate
module flange_plate() {
    difference() {
        cylinder(h = flange_thickness, d = flange_diameter, center = true);
        cylinder(h = flange_thickness + 2, d = shaft_hole_diameter, center = true);
        
        // Bolt holes
        for (i = [0:bolt_count-1]) {
            angle = i * 360 / bolt_count;
            translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), 0])
                cylinder(h = flange_thickness + 2, d = bolt_hole_diameter, center = true);
        }
    }
}

// Function to create the flexible diaphragm
module flexible_diaphragm() {
    difference() {
        cylinder(h = diaphragm_thickness, d = diaphragm_diameter, center = true);
        cylinder(h = diaphragm_thickness + 2, d = shaft_hole_diameter, center = true);
        
        // Bolt holes
        for (i = [0:bolt_count-1]) {
            angle = i * 360 / bolt_count;
            translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), 0])
                cylinder(h = diaphragm_thickness + 2, d = bolt_hole_diameter, center = true);
        }
    }
}

// Function to create a bolt
module bolt() {
    cylinder(h = bolt_length, d = bolt_diameter, center = true);
}

// Function to create a nut
module nut() {
    cylinder(h = nut_thickness, d = nut_diameter, center = true, $fn=6);
}

// Assembly
module coupling_assembly() {
    // Left Shaft
    translate([0, 0, -shaft_length/2 - flange_thickness])
        shaft();
    
    // Right Shaft
    translate([0, 0, shaft_length/2 + flange_thickness])
        shaft();
    
    // Left Flange Plate
    translate([0, 0, -flange_thickness/2])
        flange_plate();
    
    // Right Flange Plate
    translate([0, 0, flange_thickness/2])
        flange_plate();
    
    // Flexible Diaphragm
    translate([0, 0, 0])
        flexible_diaphragm();
    
    // Bolts and Nuts
    for (i = [0:bolt_count-1]) {
        angle = i * 360 / bolt_count;
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), -bolt_length/2])
            bolt();
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), bolt_length/2])
            nut();
    }
}

// Render the coupling assembly
coupling_assembly();

