
// Module for a streamlined cylindrical hub with a keyway slot
module shaft_hub() {
    difference() {
        cylinder(h=25, d=40, center=true); // Adjusted hub height
        translate([0, 0, -12.5]) cylinder(h=25, d=15, center=true); // Central hole
        translate([-20, -2, -12.5]) cube([10, 4, 25]); // Keyway slot
    }
}

// Module for a thinner and more uniform flange plate with correct bolt hole positions
module flange_plate() {
    difference() {
        cylinder(h=2, d=50, center=true); // Thinner flange
        translate([0, 0, -1]) cylinder(h=2, d=15, center=true); // Central hole
        for (i = [0:90:270]) {
            rotate([0, 0, i]) translate([18, 0, -1]) cylinder(h=2, d=5, center=true); // Adjusted bolt holes
        }
    }
}

// Module for a flexible spacer ring with a more pronounced curvature
module flexible_spacer_ring() {
    difference() {
        hull() { // Creating a more curved profile
            translate([0, 0, -1]) cylinder(h=1, d=50, center=true);
            translate([0, 0, 1]) cylinder(h=1, d=46, center=true);
        }
        translate([0, 0, -1]) cylinder(h=2, d=15, center=true); // Central hole
        for (i = [0:90:270]) {
            rotate([0, 0, i]) translate([18, 0, -1]) cylinder(h=2, d=5, center=true); // Adjusted bolt holes
        }
    }
}

// Module for a shorter bolt with a hexagonal head, properly aligned
module bolt() {
    union() {
        cylinder(h=8, d=5, center=true); // Shorter bolt
        translate([0, 0, 4]) cylinder(h=3, d1=8, d2=5, center=true); // Hexagonal head
    }
}

// Module for a hexagonal nut, properly positioned
module nut() {
    translate([0, 0, -1.5]) cylinder(h=3, d=8, center=true);
}

// Assemble the coupling with corrected components
module coupling() {
    translate([0, 0, 20]) shaft_hub(); // Input shaft hub
    translate([0, 0, 10]) flange_plate(); // First flange plate
    translate([0, 0, 7]) flexible_spacer_ring(); // First flexible spacer ring
    translate([0, 0, 4]) flange_plate(); // Second flange plate
    translate([0, 0, 1]) flexible_spacer_ring(); // Second flexible spacer ring
    translate([0, 0, -10]) shaft_hub(); // Output shaft hub

    // Bolts and nuts (shortened and repositioned)
    for (i = [0:90:270]) {
        rotate([0, 0, i]) translate([18, 0, 4]) bolt();
        rotate([0, 0, i]) translate([18, 0, -1]) nut();
    }
}

// Render the coupling
coupling();

