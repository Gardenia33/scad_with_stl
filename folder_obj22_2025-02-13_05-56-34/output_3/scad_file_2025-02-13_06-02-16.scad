//start

// Parameters
shaft_length = 42; 
shaft_diameter = 20; // Adjusted diameter to match original model
shaft_hole_diameter = 8;
shaft_mounting_diameter = 22; // Adjusted diameter for mounting surface
flange_diameter = 40;
flange_thickness = 3; // Reduced thickness to match original model
diaphragm_thickness = 2;
bolt_diameter = 4.5; 
bolt_length = 57; // Adjusted bolt length for proper protrusion
nut_size = 6; // Reduced nut size to match original model
bolt_spacing = 25;

// Function to create a shaft with keyway slots
module shaft() {
    difference() {
        union() {
            cylinder(h=shaft_length - 5, d=shaft_diameter, center=true);
            translate([0, 0, (shaft_length - 5) / 2])
                cylinder(h=5, d=shaft_mounting_diameter, center=false); // Adjusted mounting surface
        }
        cylinder(h=shaft_length+2, d=shaft_hole_diameter, center=true);
        
        // Adjusted keyway slots positioning
        translate([-shaft_diameter/2, -2, -shaft_length/2 + 5])
        cube([shaft_diameter, 4, shaft_length - 5]);
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
    translate([0, 0, 0])
    diaphragm();
    
    // Bolts and Nuts - Adjusted positioning
    for (i = [0:3]) {
        rotate([0, 0, i * 90])
            translate([bolt_spacing/2, 0, 0]) {
                bolt();
                translate([0, 0, bolt_length/2 + 2]) // Adjusted nut position for proper fastening
                nut();
            }
    }
}

// Render the coupling
coupling();

