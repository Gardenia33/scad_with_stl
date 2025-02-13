//start

// Parameters
shaft_diameter = 18; // Adjusted to match original model
shaft_length = 45; // Extended to ensure proper spacing
flange_diameter = 50;
flange_thickness = 4; // Reduced thickness to match original
bolt_hole_diameter = 5;
bolt_count = 8; // Increased number of bolt holes
bolt_diameter = 5;
bolt_length = 25; // Extended bolts to match original fastening
nut_diameter = 10; // Increased nut size to match original
nut_thickness = 5;
spacer_diameter = 40;
spacer_thickness = 4; // Reduced thickness to match original
spacing = 10;

// Function to create a shaft
module shaft(length, diameter) {
    difference() {
        cylinder(h=length, d=diameter, center=true);
        cylinder(h=length+2, d=bolt_hole_diameter, center=true);
    }
}

// Function to create a flange plate
module flange_plate(diameter, thickness) {
    difference() {
        cylinder(h=thickness, d=diameter, center=true);
        cylinder(h=thickness+2, d=bolt_hole_diameter, center=true);
        for (i = [0:bolt_count-1]) {
            angle = i * 360 / bolt_count;
            translate([diameter/2.5 * cos(angle), diameter/2.5 * sin(angle), 0])
                cylinder(h=thickness+2, d=bolt_hole_diameter, center=true);
        }
    }
}

// Function to create a bolt
module bolt(length, diameter) {
    cylinder(h=length, d=diameter, center=true);
}

// Function to create a nut
module nut(diameter, thickness) {
    cylinder(h=thickness, d=diameter, center=true, $fn=6);
}

// Function to create a spacer ring
module spacer_ring(diameter, thickness) {
    difference() {
        cylinder(h=thickness, d=diameter, center=true);
        cylinder(h=thickness+2, d=bolt_hole_diameter, center=true);
    }
}

// Assembly
module flexible_coupling() {
    // Central Shaft
    translate([0, 0, 0])
        shaft(shaft_length, shaft_diameter);

    // Left Shaft
    translate([-shaft_length, 0, 0])
        shaft(shaft_length, shaft_diameter);

    // Right Shaft
    translate([shaft_length, 0, 0])
        shaft(shaft_length, shaft_diameter);

    // Flange Plates
    translate([-shaft_length/2, 0, 0])
        flange_plate(flange_diameter, flange_thickness);
    
    translate([-shaft_length/2 - spacing, 0, 0])
        flange_plate(flange_diameter, flange_thickness);
    
    translate([shaft_length/2, 0, 0])
        flange_plate(flange_diameter, flange_thickness);
    
    translate([shaft_length/2 + spacing, 0, 0])
        flange_plate(flange_diameter, flange_thickness);

    // Spacer Rings
    translate([-shaft_length/2 - spacing/2, 0, 0])
        spacer_ring(spacer_diameter, spacer_thickness);
    
    translate([shaft_length/2 + spacing/2, 0, 0])
        spacer_ring(spacer_diameter, spacer_thickness);

    // Bolts and Nuts
    for (i = [0:bolt_count-1]) {
        angle = i * 360 / bolt_count;
        translate([-shaft_length/2 - spacing/2, spacer_diameter/2.5 * cos(angle), spacer_diameter/2.5 * sin(angle)])
            bolt(bolt_length, bolt_diameter);
        
        translate([shaft_length/2 + spacing/2, spacer_diameter/2.5 * cos(angle), spacer_diameter/2.5 * sin(angle)])
            bolt(bolt_length, bolt_diameter);
        
        translate([-shaft_length/2 - spacing/2 - bolt_length/2, spacer_diameter/2.5 * cos(angle), spacer_diameter/2.5 * sin(angle)])
            nut(nut_diameter, nut_thickness);
        
        translate([shaft_length/2 + spacing/2 + bolt_length/2, spacer_diameter/2.5 * cos(angle), spacer_diameter/2.5 * sin(angle)])
            nut(nut_diameter, nut_thickness);
    }
}

// Render the flexible coupling
flexible_coupling();

