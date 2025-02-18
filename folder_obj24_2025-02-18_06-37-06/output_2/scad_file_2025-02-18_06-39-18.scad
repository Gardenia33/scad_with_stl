
// Module for a cylindrical shaft with a central hole
module shaft(length, outer_diameter, hole_diameter) {
    difference() {
        cylinder(h=length, d=outer_diameter, center=true);
        cylinder(h=length+2, d=hole_diameter, center=true);
    }
}

// Module for a flange plate with multiple holes
module flange_plate(diameter, thickness, hole_diameter, bolt_hole_diameter, bolt_count) {
    difference() {
        cylinder(h=thickness, d=diameter, center=true);
        cylinder(h=thickness+2, d=hole_diameter, center=true);
        for (i = [0:bolt_count-1]) {
            angle = i * 360 / bolt_count;
            translate([diameter/3 * cos(angle), diameter/3 * sin(angle), 0])
                cylinder(h=thickness+2, d=bolt_hole_diameter, center=true);
        }
    }
}

// Module for a spacer ring
module spacer_ring(outer_diameter, inner_diameter, thickness) {
    difference() {
        cylinder(h=thickness, d=outer_diameter, center=true);
        cylinder(h=thickness+2, d=inner_diameter, center=true);
    }
}

// Module for a diaphragm
module diaphragm(diameter, thickness) {
    cylinder(h=thickness, d=diameter, center=true);
}

// Module for a bolt with a hexagonal head
module bolt(length, diameter, head_diameter, head_height) {
    union() {
        cylinder(h=length, d=diameter, center=true);
        translate([0, 0, length/2])
            cylinder(h=head_height, d=head_diameter, center=true);
    }
}

// Module for a hexagonal nut
module nut(diameter, thickness) {
    cylinder(h=thickness, d=diameter, center=true);
}

// Assemble the flexible coupling
module flexible_coupling() {
    // Adjusted central shaft
    translate([0, 0, 0]) shaft(90, 18, 8); 

    // Adjusted left and right shafts with more defined flange connections
    translate([-50, 0, 0]) shaft(40, 22, 8);
    translate([50, 0, 0]) shaft(40, 22, 8);

    // Adjusted flange plates with correct hole patterns
    translate([-40, 0, 0]) flange_plate(45, 4, 8, 5, 6);
    translate([-35, 0, 0]) flange_plate(45, 4, 8, 5, 6);
    translate([-37.5, 0, 0]) spacer_ring(38, 8, 3);
    translate([-36, 0, 0]) diaphragm(38, 1);

    translate([40, 0, 0]) flange_plate(45, 4, 8, 5, 6);
    translate([35, 0, 0]) flange_plate(45, 4, 8, 5, 6);
    translate([37.5, 0, 0]) spacer_ring(38, 8, 3);
    translate([36, 0, 0]) diaphragm(38, 1);

    // Adjusted bolts and nuts positioning
    for (i = [0:5]) {
        angle = i * 360 / 6;
        translate([-37.5 + 2, 38/3 * cos(angle), 38/3 * sin(angle)])
            bolt(14, 5, 7, 2);
        translate([-37.5 + 8, 38/3 * cos(angle), 38/3 * sin(angle)])
            nut(7, 3);
        
        translate([37.5 - 2, 38/3 * cos(angle), 38/3 * sin(angle)])
            bolt(14, 5, 7, 2);
        translate([37.5 - 8, 38/3 * cos(angle), 38/3 * sin(angle)])
            nut(7, 3);
    }
}

// Render the model
flexible_coupling();

