
// Parameters
shaft_length = 50;
shaft_diameter = 10;
hub_diameter = 12; // Adjusted to match the original model
hub_length = 15; // Adjusted to match the original model
flange_diameter = 25;
flange_thickness = 3; // Adjusted to match the original model
spacer_diameter = 23;
spacer_thickness = 3; // Adjusted to match the original model
bolt_diameter = 3;
bolt_length = 20;
nut_diameter = 6;
nut_thickness = 3;
bolt_hole_radius = 8;

// Function to create a hub
module hub() {
    difference() {
        cylinder(h = hub_length, d = hub_diameter);
        translate([0, 0, -1]) cylinder(h = hub_length + 2, d = shaft_diameter);
    }
}

// Function to create a flange plate
module flange_plate() {
    difference() {
        cylinder(h = flange_thickness, d = flange_diameter);
        for (i = [0:90:270]) {
            rotate([0, 0, i])
            translate([bolt_hole_radius, 0, -1])
            cylinder(h = flange_thickness + 2, d = bolt_diameter);
        }
    }
}

// Function to create a spacer ring
module spacer_ring() {
    difference() {
        cylinder(h = spacer_thickness, d = spacer_diameter);
        translate([0, 0, -1]) cylinder(h = spacer_thickness + 2, d = shaft_diameter);
    }
}

// Function to create a bolt
module bolt() {
    union() {
        cylinder(h = bolt_length, d = bolt_diameter);
        translate([0, 0, bolt_length]) cylinder(h = nut_thickness, d = nut_diameter, $fn=6);
    }
}

// Function to create a nut
module nut() {
    cylinder(h = nut_thickness, d = nut_diameter, $fn=6);
}

// Assembly
module coupling() {
    // End hub 1
    translate([0, 0, -shaft_length/2 - hub_length/2]) hub();
    
    // Flange plate 1
    translate([0, 0, -shaft_length/2 - flange_thickness]) flange_plate();
    
    // Spacer ring 1
    translate([0, 0, -shaft_length/2 - flange_thickness - spacer_thickness]) spacer_ring();
    
    // Flange plate 2
    translate([0, 0, -shaft_length/2 - flange_thickness - spacer_thickness - flange_thickness]) flange_plate();
    
    // Central shaft
    translate([0, 0, -shaft_length/2]) cylinder(h = shaft_length, d = shaft_diameter);
    
    // Flange plate 3
    translate([0, 0, shaft_length/2 + flange_thickness]) flange_plate();
    
    // Spacer ring 2
    translate([0, 0, shaft_length/2 + flange_thickness + spacer_thickness]) spacer_ring();
    
    // Flange plate 4
    translate([0, 0, shaft_length/2 + flange_thickness + spacer_thickness + flange_thickness]) flange_plate();
    
    // End hub 2
    translate([0, 0, shaft_length/2 + hub_length/2]) hub();
    
    // Bolts and nuts
    for (i = [0:90:270]) {
        rotate([0, 0, i]) {
            translate([bolt_hole_radius, 0, -shaft_length/2 - flange_thickness - spacer_thickness - flange_thickness])
            bolt();
            
            translate([bolt_hole_radius, 0, -shaft_length/2 - flange_thickness])
            nut();
            
            translate([bolt_hole_radius, 0, shaft_length/2 + flange_thickness])
            bolt();
            
            translate([bolt_hole_radius, 0, shaft_length/2 + flange_thickness + spacer_thickness + flange_thickness])
            nut();
        }
    }
}

// Render the coupling
coupling();

