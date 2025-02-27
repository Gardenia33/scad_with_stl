
// Module for a cylindrical hub with a keyway slot
module shaft_hub() {
    difference() {
        cylinder(h=30, d=40, center=true);
        translate([0, 0, -15]) cylinder(h=30, d=15, center=true); // Central hole
        translate([-20, -2, -15]) cube([10, 4, 30]); // Keyway slot
    }
}

// Module for a flange plate with bolt holes
module flange_plate() {
    difference() {
        cylinder(h=5, d=50, center=true);
        translate([0, 0, -2.5]) cylinder(h=5, d=15, center=true); // Central hole
        for (i = [0:90:270]) {
            rotate([0, 0, i]) translate([20, 0, -2.5]) cylinder(h=5, d=5, center=true); // Bolt holes
        }
    }
}

// Module for a flexible spacer ring
module flexible_spacer_ring() {
    difference() {
        cylinder(h=2, d=50, center=true);
        translate([0, 0, -1]) cylinder(h=2, d=15, center=true); // Central hole
        for (i = [0:90:270]) {
            rotate([0, 0, i]) translate([20, 0, -1]) cylinder(h=2, d=5, center=true); // Bolt holes
        }
    }
}

// Module for a bolt with a hexagonal head
module bolt() {
    union() {
        cylinder(h=20, d=5, center=true);
        translate([0, 0, 10]) cylinder(h=3, d1=8, d2=5, center=true); // Hexagonal head
    }
}

// Module for a hexagonal nut
module nut() {
    cylinder(h=3, d=8, center=true);
}

// Assemble the coupling
module coupling() {
    translate([0, 0, 30]) shaft_hub(); // Input shaft hub
    translate([0, 0, 15]) flange_plate(); // First flange plate
    translate([0, 0, 10]) flexible_spacer_ring(); // First flexible spacer ring
    translate([0, 0, 5]) flange_plate(); // Second flange plate
    translate([0, 0, 0]) flexible_spacer_ring(); // Second flexible spacer ring
    translate([0, 0, -15]) shaft_hub(); // Output shaft hub

    // Bolts and nuts
    for (i = [0:90:270]) {
        rotate([0, 0, i]) translate([20, 0, 5]) bolt();
        rotate([0, 0, i]) translate([20, 0, -5]) nut();
    }
}

// Render the coupling
coupling();

