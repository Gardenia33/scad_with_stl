
// Parameters
shaft_diameter = 20;
shaft_length = 60;
hub_diameter = 50;
hub_length = 30;
flange_diameter = 60;
flange_thickness = 5;
spacer_ring_thickness = 2;
bolt_diameter = 5;
bolt_length = 20;
nut_diameter = 8;
nut_thickness = 4;
bolt_hole_radius = 25;
num_bolts = 4;

// Central Shaft
module central_shaft() {
    cylinder(d=shaft_diameter, h=shaft_length, center=true);
}

// Hub
module hub() {
    difference() {
        cylinder(d=hub_diameter, h=hub_length, center=true);
        cylinder(d=shaft_diameter, h=hub_length + 2, center=true);
    }
}

// Flange Plate
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

// Spacer Ring
module spacer_ring() {
    difference() {
        cylinder(d=flange_diameter, h=spacer_ring_thickness, center=true);
        cylinder(d=shaft_diameter, h=spacer_ring_thickness + 2, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_hole_radius * cos(angle), bolt_hole_radius * sin(angle), 0])
                cylinder(d=bolt_diameter, h=spacer_ring_thickness + 2, center=true);
        }
    }
}

// Bolt
module bolt() {
    cylinder(d=bolt_diameter, h=bolt_length, center=true);
}

// Nut
module nut() {
    cylinder(d=nut_diameter, h=nut_thickness, center=true);
}

// Assembly
module coupling() {
    translate([0, 0, shaft_length / 2 + hub_length / 2]) hub();
    translate([0, 0, -shaft_length / 2 - hub_length / 2]) hub();
    
    translate([0, 0, shaft_length / 2 + hub_length + flange_thickness / 2]) flange_plate();
    translate([0, 0, shaft_length / 2 + hub_length + flange_thickness + spacer_ring_thickness / 2]) spacer_ring();
    translate([0, 0, shaft_length / 2 + hub_length + flange_thickness + spacer_ring_thickness + flange_thickness / 2]) flange_plate();
    
    translate([0, 0, -shaft_length / 2 - hub_length - flange_thickness / 2]) flange_plate();
    translate([0, 0, -shaft_length / 2 - hub_length - flange_thickness - spacer_ring_thickness / 2]) spacer_ring();
    translate([0, 0, -shaft_length / 2 - hub_length - flange_thickness - spacer_ring_thickness - flange_thickness / 2]) flange_plate();
    
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([bolt_hole_radius * cos(angle), bolt_hole_radius * sin(angle), shaft_length / 2 + hub_length + flange_thickness])
            bolt();
        translate([bolt_hole_radius * cos(angle), bolt_hole_radius * sin(angle), -shaft_length / 2 - hub_length - flange_thickness])
            bolt();
        
        translate([bolt_hole_radius * cos(angle), bolt_hole_radius * sin(angle), shaft_length / 2 + hub_length + flange_thickness + bolt_length / 2])
            nut();
        translate([bolt_hole_radius * cos(angle), bolt_hole_radius * sin(angle), -shaft_length / 2 - hub_length - flange_thickness - bolt_length / 2])
            nut();
    }
    
    central_shaft();
}

coupling();

