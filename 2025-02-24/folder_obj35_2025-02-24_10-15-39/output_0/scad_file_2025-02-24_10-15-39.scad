
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

// Hub module
module hub() {
    difference() {
        cylinder(d=hub_diameter, h=hub_length, center=true);
        cylinder(d=shaft_hole_diameter, h=hub_length+2, center=true);
    }
}

// Flange module
module flange() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true);
        cylinder(d=hub_diameter, h=flange_thickness+2, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_hole_radius * cos(angle), bolt_hole_radius * sin(angle), 0])
                cylinder(d=bolt_diameter, h=flange_thickness+2, center=true);
        }
    }
}

// Bolt module
module bolt() {
    cylinder(d=bolt_diameter, h=bolt_length, center=true);
}

// Nut module
module nut() {
    cylinder(d=nut_size, h=5, $fn=6, center=true);
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

