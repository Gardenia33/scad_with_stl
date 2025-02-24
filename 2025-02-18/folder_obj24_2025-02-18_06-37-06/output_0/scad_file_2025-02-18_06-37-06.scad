
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
            translate([diameter/2.5 * cos(angle), diameter/2.5 * sin(angle), 0])
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
    translate([0, 0, 0]) shaft(50, 20, 10); // Central shaft
    translate([-40, 0, 0]) shaft(30, 25, 10); // Left shaft
    translate([40, 0, 0]) shaft(30, 25, 10); // Right shaft

    translate([-30, 0, 0]) flange_plate(40, 5, 10, 5, 6); // Flange Plate 1
    translate([-25, 0, 0]) flange_plate(40, 5, 10, 5, 6); // Flange Plate 2
    translate([-27.5, 0, 0]) spacer_ring(35, 10, 2); // Spacer Ring 1
    translate([-26, 0, 0]) diaphragm(35, 1); // Diaphragm 1

    translate([30, 0, 0]) flange_plate(40, 5, 10, 5, 6); // Flange Plate 3
    translate([25, 0, 0]) flange_plate(40, 5, 10, 5, 6); // Flange Plate 4
    translate([27.5, 0, 0]) spacer_ring(35, 10, 2); // Spacer Ring 2
    translate([26, 0, 0]) diaphragm(35, 1); // Diaphragm 2

    for (i = [0:5]) {
        angle = i * 360 / 6;
        translate([-27.5 + 2, 35/2.5 * cos(angle), 35/2.5 * sin(angle)])
            bolt(10, 5, 8, 2);
        translate([-27.5 + 7, 35/2.5 * cos(angle), 35/2.5 * sin(angle)])
            nut(8, 3);
        
        translate([27.5 - 2, 35/2.5 * cos(angle), 35/2.5 * sin(angle)])
            bolt(10, 5, 8, 2);
        translate([27.5 - 7, 35/2.5 * cos(angle), 35/2.5 * sin(angle)])
            nut(8, 3);
    }
}

// Render the model
flexible_coupling();

