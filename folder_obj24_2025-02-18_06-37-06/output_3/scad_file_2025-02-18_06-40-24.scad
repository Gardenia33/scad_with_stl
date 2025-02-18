
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
    // Corrected central shaft dimensions and alignment
    translate([0, 0, 0]) shaft(100, 22, 8); 

    // Corrected left and right shafts with proper alignment and length
    translate([-55, 0, 0]) shaft(50, 22, 8);
    translate([55, 0, 0]) shaft(50, 22, 8);

    // Corrected flange plates with proper thickness and hole alignment
    translate([-45, 0, 0]) flange_plate(50, 6, 8, 5, 6);
    translate([-40, 0, 0]) flange_plate(50, 6, 8, 5, 6);
    translate([-42.5, 0, 0]) spacer_ring(42, 8, 4);
    translate([-41, 0, 0]) diaphragm(42, 2);

    translate([45, 0, 0]) flange_plate(50, 6, 8, 5, 6);
    translate([40, 0, 0]) flange_plate(50, 6, 8, 5, 6);
    translate([42.5, 0, 0]) spacer_ring(42, 8, 4);
    translate([41, 0, 0]) diaphragm(42, 2);

    // Corrected bolts and nuts positioning
    for (i = [0:5]) {
        angle = i * 360 / 6;
        translate([-42.5 + 2, 42/3 * cos(angle), 42/3 * sin(angle)])
            bolt(16, 5, 8, 3);
        translate([-42.5 + 10, 42/3 * cos(angle), 42/3 * sin(angle)])
            nut(8, 4);
        
        translate([42.5 - 2, 42/3 * cos(angle), 42/3 * sin(angle)])
            bolt(16, 5, 8, 3);
        translate([42.5 - 10, 42/3 * cos(angle), 42/3 * sin(angle)])
            nut(8, 4);
    }
}

// Render the model
flexible_coupling();

