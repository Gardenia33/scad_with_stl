
// Parameters
shaft_diameter = 10;
shaft_length = 30;
flange_diameter = 25;
flange_thickness = 5;
spacer_diameter = 20;
spacer_thickness = 3;
bolt_diameter = 3;
bolt_length = 15;
nut_diameter = 6;
nut_thickness = 3;
hole_spacing = 15;
num_bolts = 4;

// Function to create a shaft
module shaft(length) {
    difference() {
        cylinder(h=length, d=shaft_diameter, center=true);
        cylinder(h=length+2, d=bolt_diameter, center=true);
    }
}

// Function to create a flange plate
module flange_plate() {
    difference() {
        cylinder(h=flange_thickness, d=flange_diameter, center=true);
        cylinder(h=flange_thickness+2, d=bolt_diameter, center=true);
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
        cylinder(h=spacer_thickness+2, d=bolt_diameter, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([hole_spacing * cos(angle), hole_spacing * sin(angle), 0])
                cylinder(h=spacer_thickness+2, d=bolt_diameter, center=true);
        }
    }
}

// Function to create a bolt
module bolt() {
    cylinder(h=bolt_length, d=bolt_diameter, center=true);
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
}

// Render the model
flexible_coupling();

