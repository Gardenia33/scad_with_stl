
// Parameters
hub_diameter = 30;
hub_length = 40;
shaft_hole_diameter = 10;
flange_diameter = 60;
flange_thickness = 5;
bolt_hole_diameter = 5;
bolt_circle_diameter = 50;
spacer_thickness = 2;
bolt_length = 20;
bolt_diameter = 5;
nut_size = 8;
nut_thickness = 4;

// Function to create a hub
module hub() {
    difference() {
        cylinder(d=hub_diameter, h=hub_length, center=true);
        cylinder(d=shaft_hole_diameter, h=hub_length + 2, center=true);
    }
}

// Function to create a flange plate
module flange_plate() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true);
        for (i = [0:5]) {
            angle = i * 60;
            translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), 0])
                cylinder(d=bolt_hole_diameter, h=flange_thickness + 2, center=true);
        }
    }
}

// Function to create a spacer ring
module spacer_ring() {
    difference() {
        cylinder(d=flange_diameter, h=spacer_thickness, center=true);
        cylinder(d=bolt_circle_diameter, h=spacer_thickness + 2, center=true);
    }
}

// Function to create a bolt
module bolt() {
    cylinder(d=bolt_diameter, h=bolt_length, center=true);
}

// Function to create a nut
module nut() {
    cylinder(d=nut_size, h=nut_thickness, center=true, $fn=6);
}

// Assembly
module coupling() {
    translate([0, 0, -hub_length/2 - flange_thickness/2])
        hub();
    
    translate([0, 0, hub_length/2 + flange_thickness/2])
        hub();
    
    translate([0, 0, -flange_thickness/2])
        flange_plate();
    
    translate([0, 0, flange_thickness/2 + spacer_thickness])
        spacer_ring();
    
    translate([0, 0, flange_thickness/2 + 2 * spacer_thickness])
        spacer_ring();
    
    translate([0, 0, flange_thickness/2 + 3 * spacer_thickness])
        flange_plate();
    
    for (i = [0:5]) {
        angle = i * 60;
        translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), -bolt_length/2])
            bolt();
        
        translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), bolt_length/2])
            nut();
    }
}

// Render the coupling
coupling();

