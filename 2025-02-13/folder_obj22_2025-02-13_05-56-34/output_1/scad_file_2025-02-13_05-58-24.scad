//start

// Parameters
shaft_length = 42; // Adjusted length for better alignment
shaft_diameter = 18; // Adjusted diameter for better match
shaft_hole_diameter = 8;
flange_diameter = 40;
flange_thickness = 4; // Reduced thickness to match original
diaphragm_thickness = 2;
bolt_diameter = 4.5; // Reduced diameter for better match
bolt_length = 50;
nut_size = 7; // Reduced size for better match
bolt_spacing = 25;

// Function to create a shaft with keyway slots
module shaft() {
    difference() {
        cylinder(h=shaft_length, d=shaft_diameter, center=true);
        cylinder(h=shaft_length+2, d=shaft_hole_diameter, center=true);
        
        // Adding keyway slots
        translate([-shaft_diameter/2, -2, -shaft_length/2])
        cube([shaft_diameter, 4, shaft_length]);
    }
}

// Function to create a flange plate
module flange_plate() {
    difference() {
        cylinder(h=flange_thickness, d=flange_diameter, center=true);
        cylinder(h=flange_thickness+2, d=shaft_hole_diameter, center=true);
        for (i = [0:3]) {
            rotate([0, 0, i * 90])
                translate([bolt_spacing/2, 0, 0])
                cylinder(h=flange_thickness+2, d=bolt_diameter, center=true);
        }
    }
}

// Function to create the diaphragm
module diaphragm() {
    difference() {
        translate([0, 0, -diaphragm_thickness/2])
        cylinder(h=diaphragm_thickness, d=flange_diameter, center=true);
        cylinder(h=diaphragm_thickness+2, d=shaft_hole_diameter, center=true);
        for (i = [0:3]) {
            rotate([0, 0, i * 90])
                translate([bolt_spacing/2, 0, 0])
                cylinder(h=diaphragm_thickness+2, d=bolt_diameter, center=true);
        }
    }
}

// Function to create a bolt
module bolt() {
    translate([0, 0, -bolt_length/2])
    cylinder(h=bolt_length, d=bolt_diameter, center=false);
}

// Function to create a nut
module nut() {
    cylinder(h=nut_size, d=nut_size, $fn=6);
}

// Assembly of the coupling
module coupling() {
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
    
    // Diaphragm - Adjusted for better alignment
    translate([0, 0, 0.5])
    diaphragm();
    
    // Bolts and Nuts - Adjusted positioning
    for (i = [0:3]) {
        rotate([0, 0, i * 90])
            translate([bolt_spacing/2, 0, 0]) {
                bolt();
                translate([0, 0, bolt_length/2 + 1]) // Adjusted nut position
                nut();
            }
    }
}

// Render the coupling
coupling();

