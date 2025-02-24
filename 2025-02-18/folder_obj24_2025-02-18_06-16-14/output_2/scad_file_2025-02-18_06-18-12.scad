
// Parameters
shaft_diameter = 10; // Adjusted to match original model
shaft_length = 60; // Extended for proper alignment
flange_diameter = 30; // Adjusted to match original model
flange_thickness = 5; // Adjusted for correct proportion
spacer_diameter = 25; // Increased to match original model
spacer_thickness = 4; // Adjusted for correct separation
bolt_diameter = 4; // Adjusted for better fit
bolt_length = 22; // Extended for proper securing
nut_diameter = 8; // Adjusted for proper fit
nut_thickness = 4; // Adjusted for correct proportion
hole_spacing = 18; // Adjusted for correct bolt placement
num_bolts = 6; // Increased to match original model

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
        cylinder(h=3, d1=8, d2=8, center=false); // Hexagonal head
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

