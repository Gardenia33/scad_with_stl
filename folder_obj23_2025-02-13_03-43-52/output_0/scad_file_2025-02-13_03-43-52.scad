//start

// Parameters
shaft_radius = 5;
shaft_length = 20;
flange_radius = 12;
flange_thickness = 3;
spacer_radius = 10;
spacer_thickness = 2;
bolt_radius = 1.5;
bolt_length = 10;
nut_radius = 2.5;
nut_thickness = 2;
hole_radius = 2;
bolt_spacing = 8;
num_bolts = 6;

// Function to create a shaft with a central hole
module shaft(length, radius) {
    difference() {
        cylinder(h=length, r=radius, center=true);
        cylinder(h=length+2, r=hole_radius, center=true);
    }
}

// Function to create a flange plate with bolt holes
module flange_plate(radius, thickness) {
    difference() {
        cylinder(h=thickness, r=radius, center=true);
        cylinder(h=thickness+2, r=hole_radius, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_spacing * cos(angle), bolt_spacing * sin(angle), 0])
                cylinder(h=thickness+2, r=bolt_radius, center=true);
        }
    }
}

// Function to create a spacer ring
module spacer_ring(radius, thickness) {
    difference() {
        cylinder(h=thickness, r=radius, center=true);
        cylinder(h=thickness+2, r=hole_radius, center=true);
    }
}

// Function to create a bolt
module bolt(length, radius) {
    cylinder(h=length, r=radius, center=true);
}

// Function to create a nut
module nut(radius, thickness) {
    cylinder(h=thickness, r=radius, center=true, $fn=6);
}

// Assembly
module flexible_coupling() {
    // Central shaft
    shaft(shaft_length, shaft_radius);

    // Left outer shaft
    translate([-shaft_length/2 - flange_thickness, 0, 0])
        shaft(shaft_length/2, shaft_radius);

    // Right outer shaft
    translate([shaft_length/2 + flange_thickness, 0, 0])
        shaft(shaft_length/2, shaft_radius);

    // Left flange plates
    translate([-shaft_length/2, 0, 0])
        flange_plate(flange_radius, flange_thickness);
    translate([-shaft_length/2 - spacer_thickness, 0, 0])
        flange_plate(flange_radius, flange_thickness);

    // Right flange plates
    translate([shaft_length/2, 0, 0])
        flange_plate(flange_radius, flange_thickness);
    translate([shaft_length/2 + spacer_thickness, 0, 0])
        flange_plate(flange_radius, flange_thickness);

    // Spacer rings
    translate([-shaft_length/2 - flange_thickness/2, 0, 0])
        spacer_ring(spacer_radius, spacer_thickness);
    translate([shaft_length/2 + flange_thickness/2, 0, 0])
        spacer_ring(spacer_radius, spacer_thickness);

    // Bolts and nuts
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([-shaft_length/2 - flange_thickness/2, bolt_spacing * cos(angle), bolt_spacing * sin(angle)])
            bolt(bolt_length, bolt_radius);
        translate([shaft_length/2 + flange_thickness/2, bolt_spacing * cos(angle), bolt_spacing * sin(angle)])
            bolt(bolt_length, bolt_radius);

        translate([-shaft_length/2 - flange_thickness/2 - bolt_length/2, bolt_spacing * cos(angle), bolt_spacing * sin(angle)])
            nut(nut_radius, nut_thickness);
        translate([shaft_length/2 + flange_thickness/2 + bolt_length/2, bolt_spacing * cos(angle), bolt_spacing * sin(angle)])
            nut(nut_radius, nut_thickness);
    }
}

// Render the model
flexible_coupling();

