
// Parameters
shaft_diameter = 10;
flange_diameter = 50;
flange_thickness = 5;
spacer_thickness = 1.5; // Reduced thickness to match the original model
bolt_diameter = 5;
bolt_length = 20;
nut_size = 8;
nut_thickness = 4;
spacing = 10;

// Function to create a cylindrical component with a central bore
module craft() {
    difference() {
        cylinder(h = 20, d = 30, center = true);
        cylinder(h = 25, d = shaft_diameter, center = true);
    }
}

// Function to create a flange plate with bolt holes
module flange_plate() {
    difference() {
        cylinder(h = flange_thickness, d = flange_diameter, center = true);
        cylinder(h = flange_thickness + 2, d = shaft_diameter, center = true);
        for (i = [0:3]) {
            rotate([0, 0, i * 90])
                translate([flange_diameter / 2.5, 0, 0])
                cylinder(h = flange_thickness + 2, d = bolt_diameter, center = true);
        }
    }
}

// Function to create a thinner spacer ring
module spacer_ring() {
    difference() {
        cylinder(h = spacer_thickness, d = flange_diameter - 5, center = true);
        cylinder(h = spacer_thickness + 2, d = shaft_diameter + 5, center = true);
    }
}

// Function to create a bolt
module bolt() {
    translate([0, 0, -bolt_length / 2]) cylinder(h = bolt_length, d = bolt_diameter, center = false);
}

// Function to create a nut
module nut() {
    translate([0, 0, -nut_thickness / 2]) cylinder(h = nut_thickness, d = nut_size, $fn = 6, center = false);
}

// Assembly of the coupling
module coupling() {
    translate([0, 0, spacing * 3]) craft(); // Input craft
    translate([0, 0, spacing * 2]) flange_plate(); // First flange plate
    translate([0, 0, spacing * 1.5]) spacer_ring(); // First spacer ring
    translate([0, 0, spacing]) flange_plate(); // Second flange plate
    translate([0, 0, spacing * 0.5]) spacer_ring(); // Second spacer ring
    translate([0, 0, 0]) flange_plate(); // Third flange plate
    translate([0, 0, -spacing]) craft(); // Output craft

    // Bolts and nuts
    for (i = [0:3]) {
        rotate([0, 0, i * 90])
            translate([flange_diameter / 2.5, 0, spacing * 1.5])
            bolt();
        rotate([0, 0, i * 90])
            translate([flange_diameter / 2.5, 0, spacing * 2])
            nut();
        rotate([0, 0, i * 90])
            translate([flange_diameter / 2.5, 0, spacing * 0.5])
            bolt();
        rotate([0, 0, i * 90])
            translate([flange_diameter / 2.5, 0, 0])
            nut();
    }
}

// Render the coupling
coupling();

