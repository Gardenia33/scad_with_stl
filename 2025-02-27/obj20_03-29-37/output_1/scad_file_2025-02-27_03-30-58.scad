```openscad
// Parameters
shaft_length = 50;
shaft_diameter = 15;
hub_diameter = 25;
hub_length = 15;
flange_diameter = 40;
flange_thickness = 5;
spacer_ring_thickness = 2;
bolt_hole_diameter = 5;
bolt_circle_diameter = 30;
bolt_diameter = 4;
bolt_length = 20;
nut_diameter = 8;
nut_thickness = 4;
num_bolts = 6;

// Function to create a simple cylindrical hub
module hub() {
    difference() {
        cylinder(d=hub_diameter, h=hub_length, center=true);
        cylinder(d=shaft_diameter, h=hub_length + 2, center=true);
    }
}

// Function to create a simple flat flange with bolt holes
module flange() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true);
        cylinder(d=shaft_diameter, h=flange_thickness + 2, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), 0])
                cylinder(d=bolt_hole_diameter, h=flange_thickness + 2, center=true);
        }
    }
}

// Function to create a simple thin spacer ring
module spacer_ring() {
    difference() {
        cylinder(d=flange_diameter, h=spacer_ring_thickness, center=true);
        cylinder(d=bolt_circle_diameter, h=spacer_ring_thickness + 2, center=true);
    }
}

// Function to create a simple cylindrical bolt
module bolt() {
    cylinder(d=bolt_diameter, h=bolt_length, center=true);
}

// Function to create a simple hexagonal nut
module nut() {
    cylinder(d=nut_diameter, h=nut_thickness, center=true, $fn=6);
}

// Assembly
module flexible_coupling() {
    // Shaft (simple cylindrical shape)
    translate([0, 0, 0])
        cylinder(d=shaft_diameter, h=shaft_length, center=true);

    // Hub 1
    translate([0, 0, -shaft_length/2 - hub_length/2])
        hub();

    // Hub 2
    translate([0, 0, shaft_length/2 + hub_length/2])
        hub();

    // Flange 1
    translate([0, 0, -shaft_length/2 - hub_length/2 - flange_thickness/2])
        flange();

    // Flange 2
    translate([0, 0, shaft_length/2 + hub_length/2 + flange_thickness/2])
        flange();

    // Spacer Ring 1
    translate([0, 0, -shaft_length/2 - hub_length/2 - flange_thickness - spacer_ring_thickness/2])
        spacer_ring();

    // Spacer Ring 2
    translate([0, 0, shaft_length/2 + hub_length/2 + flange_thickness + spacer_ring_thickness/2])
        spacer_ring();

    // Bolts and Nuts (properly aligned)
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), 0])
            rotate([90, 0, angle])
                bolt();

        translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), -shaft_length/2 - hub_length/2 - flange_thickness - spacer_ring_thickness - nut_thickness])
            rotate([90, 0, angle])
                nut();

        translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), shaft_length/2 + hub_length/2 + flange_thickness + spacer_ring_thickness])
            rotate([90, 0, angle])
                nut();
    }
}

// Render the model
flexible_coupling();
```
 