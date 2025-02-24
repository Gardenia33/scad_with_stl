
// Parameters
shaft_diameter = 8; // Reduced diameter for better proportion
shaft_length = 50; // Increased length to match original model
flange_diameter = 25;
flange_thickness = 3; // Reduced thickness for better definition
spacer_diameter = 20;
spacer_thickness = 2; // Adjusted for better separation
bolt_diameter = 3;
bolt_length = 18; // Extended bolts for better visibility
nut_diameter = 6;
nut_thickness = 3;
hole_spacing = 15;
num_bolts = 4;

// Function to create a shaft
module shaft(length) {
    cylinder(h=length, d=shaft_diameter, center=true);
}

// Function to create a flange plate
module flange_plate() {
    difference() {
        cylinder(h=flange_thickness, d=flange_diameter, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([hole_spacing * cos(angle), hole_spacing * sin(angle), 0])
                cylinder(h=flange_thickness+2, d=bolt_diameter, center=true);
        }
    }
}

// Function to create a spacer ring
module spacer_ring() {
    difference() {
        cylinder(h=spacer_thickness, d=spacer_diameter, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([hole_spacing * cos(angle), hole_spacing * sin(angle), 0])
                cylinder(h=spacer_thickness+2, d=bolt_diameter, center=true);
        }
    }
}

// Function to create a bolt with a hexagonal head
module bolt() {
    translate([0, 0, -bolt_length/2])
        cylinder(h=bolt_length, d=bolt_diameter, center=false);
    translate([0, 0, bolt_length/2])
        cylinder(h=2, d1=6, d2=6, center=false); // Hexagonal head
}

// Function to create a nut
module nut() {
    cylinder(h=nut_thickness, d=nut_diameter, center=true);
}

// Assembly
module flexible_coupling() {
    translate([-shaft_length/2, 0, 0]) shaft(shaft_length);
    translate([shaft_length/2, 0, 0]) shaft(shaft_length);
    
    translate([-shaft_length/2 + flange_thickness/2, 0, 0]) flange_plate();
    translate([-shaft_length/2 + flange_thickness + spacer_thickness/2, 0, 0]) spacer_ring();
    translate([-shaft_length/2 + flange_thickness + spacer_thickness + flange_thickness/2, 0, 0]) flange_plate();
    
    translate([shaft_length/2 - flange_thickness/2, 0, 0]) flange_plate();
    translate([shaft_length/2 - flange_thickness - spacer_thickness/2, 0, 0]) spacer_ring();
    translate([shaft_length/2 - flange_thickness - spacer_thickness - flange_thickness/2, 0, 0]) flange_plate();
    
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([-shaft_length/2 + flange_thickness + spacer_thickness/2, hole_spacing * cos(angle), hole_spacing * sin(angle)])
            bolt();
        translate([shaft_length/2 - flange_thickness - spacer_thickness/2, hole_spacing * cos(angle), hole_spacing * sin(angle)])
            bolt();
    }
    
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([-shaft_length/2 + flange_thickness + spacer_thickness/2 + bolt_length, hole_spacing * cos(angle), hole_spacing * sin(angle)])
            nut();
        translate([shaft_length/2 - flange_thickness - spacer_thickness/2 - bolt_length, hole_spacing * cos(angle), hole_spacing * sin(angle)])
            nut();
    }
}

// Render the model
flexible_coupling();

