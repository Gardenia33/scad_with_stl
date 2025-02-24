
// Parameters
hub_diameter = 30;
hub_length = 40;
shaft_hole_diameter = 15;
flange_diameter = 80;
flange_thickness = 10;
bolt_hole_radius = 35;
bolt_diameter = 6;
bolt_length = 20;
nut_size = 10;
num_bolts = 4;
flange_rim_thickness = 5;
flange_rim_diameter = 90;
hub_extension_length = 10;
hub_extension_diameter = 40;
hub_reinforcement_diameter = 50;
hub_reinforcement_thickness = 5;

// Hub module with additional structural details
module hub() {
    difference() {
        union() {
            cylinder(d=hub_diameter, h=hub_length, center=true);
            translate([0, 0, hub_length/2])
                cylinder(d=hub_extension_diameter, h=hub_extension_length, center=false);
            translate([0, 0, hub_length/4])
                cylinder(d=hub_reinforcement_diameter, h=hub_reinforcement_thickness, center=true);
        }
        cylinder(d=shaft_hole_diameter, h=hub_length+hub_extension_length+2, center=true);
    }
}

// Flange module with raised rim
module flange() {
    difference() {
        union() {
            cylinder(d=flange_diameter, h=flange_thickness, center=true);
            translate([0, 0, flange_thickness/2])
                cylinder(d=flange_rim_diameter, h=flange_rim_thickness, center=true);
        }
        cylinder(d=hub_diameter, h=flange_thickness+2, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_hole_radius * cos(angle), bolt_hole_radius * sin(angle), 0])
                cylinder(d=bolt_diameter, h=flange_thickness+2, center=true);
        }
    }
}

// Bolt module with hexagonal head and threading
module bolt() {
    union() {
        cylinder(d=bolt_diameter, h=bolt_length, center=false);
        translate([0, 0, bolt_length])
            cylinder(d=nut_size, h=5, $fn=6, center=false);
    }
}

// Nut module with proper hexagonal shape
module nut() {
    cylinder(d=nut_size, h=5, $fn=6, center=false);
}

// Assemble the components
module assembly() {
    hub();
    translate([0, 0, hub_length/2 + flange_thickness/2]) flange();
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([bolt_hole_radius * cos(angle), bolt_hole_radius * sin(angle), hub_length/2 + flange_thickness/2])
            bolt();
        translate([bolt_hole_radius * cos(angle), bolt_hole_radius * sin(angle), hub_length/2 + flange_thickness/2 + bolt_length])
            nut();
    }
}

// Render the assembly
assembly();

