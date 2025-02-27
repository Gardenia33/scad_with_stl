
// Parameters
shaft_diameter = 20;
shaft_length = 80;
hub_diameter = 50;
hub_height = 30;
flange_diameter = 60;
flange_thickness = 5;
spacer_diameter = 55;
spacer_thickness = 3;
bolt_diameter = 5;
bolt_length = 20;
nut_diameter = 8;
nut_thickness = 4;
bolt_hole_radius = 25;
num_bolts = 6;

// Function to create a hub
module hub() {
    difference() {
        cylinder(d=hub_diameter, h=hub_height, center=true);
        cylinder(d=shaft_diameter, h=hub_height + 2, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_hole_radius * cos(angle), bolt_hole_radius * sin(angle), 0])
                cylinder(d=bolt_diameter, h=hub_height + 2, center=true);
        }
    }
}

// Function to create a flange plate
module flange_plate() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true);
        cylinder(d=shaft_diameter, h=flange_thickness + 2, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_hole_radius * cos(angle), bolt_hole_radius * sin(angle), 0])
                cylinder(d=bolt_diameter, h=flange_thickness + 2, center=true);
        }
    }
}

// Function to create a spacer ring
module spacer_ring() {
    difference() {
        cylinder(d=spacer_diameter, h=spacer_thickness, center=true);
        cylinder(d=shaft_diameter, h=spacer_thickness + 2, center=true);
    }
}

// Function to create a bolt
module bolt() {
    cylinder(d=bolt_diameter, h=bolt_length, center=true);
}

// Function to create a nut
module nut() {
    cylinder(d=nut_diameter, h=nut_thickness, center=true);
}

// Assembly
module coupling() {
    translate([0, 0, shaft_length / 2 + hub_height / 2]) hub();
    translate([0, 0, shaft_length / 2]) flange_plate();
    translate([0, 0, shaft_length / 2 - flange_thickness]) spacer_ring();
    translate([0, 0, shaft_length / 2 - flange_thickness - spacer_thickness]) flange_plate();
    
    translate([0, 0, 0]) cylinder(d=shaft_diameter, h=shaft_length, center=true);
    
    translate([0, 0, -shaft_length / 2 + flange_thickness + spacer_thickness]) flange_plate();
    translate([0, 0, -shaft_length / 2 + flange_thickness]) spacer_ring();
    translate([0, 0, -shaft_length / 2]) flange_plate();
    translate([0, 0, -shaft_length / 2 - hub_height / 2]) hub();
    
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([bolt_hole_radius * cos(angle), bolt_hole_radius * sin(angle), shaft_length / 2])
            bolt();
        translate([bolt_hole_radius * cos(angle), bolt_hole_radius * sin(angle), -shaft_length / 2])
            bolt();
    }
}

// Render the coupling
coupling();

