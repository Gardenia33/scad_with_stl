//start

// Parameters
shaft_diameter = 20;
shaft_length = 40;
flange_diameter = 50;
flange_thickness = 5;
bolt_hole_radius = 3;
bolt_radius = 3;
bolt_length = 15;
nut_size = 6;
diaphragm_thickness = 1;
diaphragm_diameter = 45;
keyway_width = 4;
keyway_depth = 2;

// Function to create a shaft with a keyway
module shaft() {
    difference() {
        cylinder(h=shaft_length, d=shaft_diameter, center=true);
        translate([0, 0, -shaft_length/2])
            cylinder(h=shaft_length, d=5, center=true); // Central hole
        translate([-keyway_width/2, shaft_diameter/2 - keyway_depth, -shaft_length/2])
            cube([keyway_width, keyway_depth, shaft_length]); // Keyway slot
    }
}

// Function to create a flange plate
module flange_plate() {
    difference() {
        cylinder(h=flange_thickness, d=flange_diameter, center=true);
        cylinder(h=flange_thickness+1, d=5, center=true); // Central hole
        for (i = [0:3]) {
            rotate([0, 0, i * 90])
                translate([flange_diameter/2 - 10, 0, 0])
                    cylinder(h=flange_thickness+1, r=bolt_hole_radius, center=true); // Bolt holes
        }
    }
}

// Function to create the flexible diaphragm
module flexible_diaphragm() {
    difference() {
        cylinder(h=diaphragm_thickness, d=diaphragm_diameter, center=true);
        cylinder(h=diaphragm_thickness+1, d=5, center=true); // Central hole
        for (i = [0:3]) {
            rotate([0, 0, i * 90])
                translate([diaphragm_diameter/2 - 10, 0, 0])
                    cylinder(h=diaphragm_thickness+1, r=bolt_hole_radius, center=true); // Bolt holes
        }
    }
}

// Function to create a bolt
module bolt() {
    cylinder(h=bolt_length, r=bolt_radius, center=true);
}

// Function to create a nut
module nut() {
    cylinder(h=4, r=nut_size, center=true, $fn=6);
}

// Assembly
module coupling() {
    // Input Shaft
    translate([0, 0, -shaft_length/2 - flange_thickness])
        shaft();
    
    // Output Shaft
    translate([0, 0, shaft_length/2 + flange_thickness])
        shaft();
    
    // Flange Plate 1
    translate([0, 0, -flange_thickness/2])
        flange_plate();
    
    // Flange Plate 2
    translate([0, 0, flange_thickness/2])
        flange_plate();
    
    // Flexible Diaphragm
    translate([0, 0, 0])
        flexible_diaphragm();
    
    // Bolts and Nuts
    for (i = [0:3]) {
        rotate([0, 0, i * 90]) {
            translate([flange_diameter/2 - 10, 0, 0]) {
                bolt();
                translate([0, 0, bolt_length/2])
                    nut();
            }
        }
    }
}

// Render the coupling
coupling();

