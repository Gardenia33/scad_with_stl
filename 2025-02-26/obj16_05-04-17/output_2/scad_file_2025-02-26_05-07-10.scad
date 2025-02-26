
// Parameters
hub_diameter = 30;
hub_length = 35; 
shaft_hole_diameter = 10;
flange_diameter = 60;
flange_thickness = 4; 
bolt_hole_diameter = 5;
bolt_circle_diameter = 50;
spacer_thickness = 3; 
bolt_length = 22; 
bolt_diameter = 5;
nut_size = 8;
nut_thickness = 4;

// Function to create a hub with bolt holes and refined mounting hole
module hub() {
    difference() {
        cylinder(d=hub_diameter, h=hub_length, center=true);
        cylinder(d=shaft_hole_diameter, h=hub_length + 2, center=true);
        
        // Adding bolt holes to the hub
        for (i = [0:5]) {
            angle = i * 60;
            translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), 0])
                cylinder(d=bolt_hole_diameter, h=hub_length + 2, center=true);
        }
    }
}

// Function to create a flange plate with bolt holes
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
    translate([0, 0, -bolt_length/2])
        cylinder(d=bolt_diameter, h=bolt_length, center=true);
}

// Function to create a nut
module nut() {
    translate([0, 0, bolt_length/2])
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
        translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), 0]) {
            bolt();
            nut();
        }
    }
}

// Render the coupling
coupling();

