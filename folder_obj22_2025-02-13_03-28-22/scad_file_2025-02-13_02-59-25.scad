//start

// Parameters
shaft_diameter = 10;
shaft_length = 40;
flange_diameter = 25;
flange_thickness = 3;
spacer_thickness = 5;
bolt_hole_diameter = 3;
bolt_diameter = 2;
bolt_length = 15;
nut_diameter = 5;
nut_thickness = 3;
num_bolts = 4;
bolt_spacing_radius = 8;

// Function to create a shaft with a central hole
module shaft(length) {
    difference() {
        cylinder(h=length, d=shaft_diameter, center=true);
        cylinder(h=length+2, d=bolt_hole_diameter, center=true);
    }
}

// Function to create a flange plate with bolt holes
module flange_plate() {
    difference() {
        cylinder(h=flange_thickness, d=flange_diameter, center=true);
        cylinder(h=flange_thickness+2, d=bolt_hole_diameter, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_spacing_radius * cos(angle), bolt_spacing_radius * sin(angle), 0])
                cylinder(h=flange_thickness+2, d=bolt_hole_diameter, center=true);
        }
    }
}

// Function to create a spacer ring
module spacer_ring() {
    difference() {
        cylinder(h=spacer_thickness, d=flange_diameter, center=true);
        cylinder(h=spacer_thickness+2, d=shaft_diameter, center=true);
    }
}

// Function to create a bolt
module bolt() {
    union() {
        cylinder(h=bolt_length, d=bolt_diameter, center=true);
        translate([0, 0, bolt_length/2])
            cylinder(h=bolt_diameter, d=nut_diameter, center=true, $fn=6);
    }
}

// Function to create a nut
module nut() {
    cylinder(h=nut_thickness, d=nut_diameter, center=true, $fn=6);
}

// Assembly
module coupling() {
    // Central shaft
    shaft(shaft_length);

    // Left shaft and flange
    translate([-shaft_length/2, 0, 0]) {
        shaft(shaft_length/4);
        translate([0, 0, shaft_length/8]) flange_plate();
    }

    // Right shaft and flange
    translate([shaft_length/2, 0, 0]) {
        shaft(shaft_length/4);
        translate([0, 0, -shaft_length/8]) flange_plate();
    }

    // Left flange pair with spacer
    translate([-shaft_length/2 + shaft_length/8, 0, 0]) {
        flange_plate();
        translate([0, 0, flange_thickness]) spacer_ring();
        translate([0, 0, flange_thickness + spacer_thickness]) flange_plate();
    }

    // Right flange pair with spacer
    translate([shaft_length/2 - shaft_length/8, 0, 0]) {
        flange_plate();
        translate([0, 0, -flange_thickness]) spacer_ring();
        translate([0, 0, -flange_thickness - spacer_thickness]) flange_plate();
    }

    // Bolts and nuts
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([bolt_spacing_radius * cos(angle), bolt_spacing_radius * sin(angle), -flange_thickness - spacer_thickness/2])
            bolt();
        translate([bolt_spacing_radius * cos(angle), bolt_spacing_radius * sin(angle), flange_thickness + spacer_thickness/2])
            nut();
    }
}

// Render the coupling
coupling();

