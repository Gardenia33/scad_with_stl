
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
    translate([0, 0, 0]) shaft(70, 15, 8); // Adjusted central shaft
    translate([-45, 0, 0]) shaft(35, 20, 8); // Adjusted left shaft
    translate([45, 0, 0]) shaft(35, 20, 8); // Adjusted right shaft

    translate([-35, 0, 0]) flange_plate(40, 3, 8, 4, 6); // Adjusted Flange Plate 1
    translate([-30, 0, 0]) flange_plate(40, 3, 8, 4, 6); // Adjusted Flange Plate 2
    translate([-32.5, 0, 0]) spacer_ring(35, 8, 2); // Added Spacer Ring 1
    translate([-31, 0, 0]) diaphragm(35, 1); // Added Diaphragm 1

    translate([35, 0, 0]) flange_plate(40, 3, 8, 4, 6); // Adjusted Flange Plate 3
    translate([30, 0, 0]) flange_plate(40, 3, 8, 4, 6); // Adjusted Flange Plate 4
    translate([32.5, 0, 0]) spacer_ring(35, 8, 2); // Added Spacer Ring 2
    translate([31, 0, 0]) diaphragm(35, 1); // Added Diaphragm 2

    for (i = [0:5]) {
        angle = i * 360 / 6;
        translate([-32.5 + 2, 35/3 * cos(angle), 35/3 * sin(angle)])
            bolt(12, 4, 6, 2);
        translate([-32.5 + 7, 35/3 * cos(angle), 35/3 * sin(angle)])
            nut(6, 3);
        
        translate([32.5 - 2, 35/3 * cos(angle), 35/3 * sin(angle)])
            bolt(12, 4, 6, 2);
        translate([32.5 - 7, 35/3 * cos(angle), 35/3 * sin(angle)])
            nut(6, 3);
    }
}

// Render the model
flexible_coupling();

