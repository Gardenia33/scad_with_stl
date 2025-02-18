
// Parameters
central_body_diameter = 50;
central_body_length = 40; // Shortened to match the original model
flange_diameter = 70;
flange_thickness = 4; // Adjusted thickness to match original model
spacer_ring_thickness = 6; // Increased to match the original model
bolt_diameter = 6; // Increased bolt size for proper detailing
bolt_length = 20; // Increased bolt length for better alignment
nut_diameter = 8; // Adjusted nut size to match original model
nut_thickness = 4; // Adjusted thickness for better integration
bolt_spacing_radius = 25;
num_bolts = 8; // Keeping the correct number of bolts

// Central Body with additional structural details
module central_body() {
    difference() {
        cylinder(d=central_body_diameter, h=central_body_length, center=true, $fn=100);
        // Adding structural details
        translate([0, 0, -central_body_length/2])
            cylinder(d=central_body_diameter + 10, h=5, center=true, $fn=100);
        translate([0, 0, central_body_length/2])
            cylinder(d=central_body_diameter + 10, h=5, center=true, $fn=100);
    }
}

// Flange Plate with correct thickness and external detailing
module flange_plate() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true, $fn=100);
        cylinder(d=central_body_diameter, h=flange_thickness + 2, center=true, $fn=100);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_spacing_radius * cos(angle), bolt_spacing_radius * sin(angle), 0])
                cylinder(d=bolt_diameter, h=flange_thickness + 2, center=true, $fn=50);
        }
    }
}

// External Flange Plate with correct detailing
module external_flange_plate() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true, $fn=100);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_spacing_radius * cos(angle), bolt_spacing_radius * sin(angle), 0])
                cylinder(d=bolt_diameter, h=flange_thickness + 2, center=true, $fn=50);
        }
    }
}

// Spacer Ring with correct separation
module spacer_ring() {
    difference() {
        cylinder(d=flange_diameter, h=spacer_ring_thickness, center=true, $fn=100);
        cylinder(d=central_body_diameter, h=spacer_ring_thickness + 2, center=true, $fn=100);
    }
}

// Bolt with correct length and hexagonal head
module bolt() {
    union() {
        cylinder(d=bolt_diameter, h=bolt_length, center=true, $fn=50);
        translate([0, 0, bolt_length/2])
            cylinder(d=bolt_diameter + 2, h=2, center=true, $fn=6);
    }
}

// Nut with correct size and hexagonal shape
module nut() {
    cylinder(d=nut_diameter, h=nut_thickness, center=true, $fn=6);
}

// Assembly
module coupling() {
    // Central Body
    translate([0, 0, 0])
        central_body();
    
    // Flange Plates
    translate([0, 0, central_body_length/2 + flange_thickness/2])
        flange_plate();
    translate([0, 0, -central_body_length/2 - flange_thickness/2])
        flange_plate();
    
    // External Flange Plates
    translate([0, 0, central_body_length/2 + flange_thickness + spacer_ring_thickness])
        external_flange_plate();
    translate([0, 0, -central_body_length/2 - flange_thickness - spacer_ring_thickness])
        external_flange_plate();
    
    // Spacer Rings
    translate([0, 0, central_body_length/2 + flange_thickness + spacer_ring_thickness/2])
        spacer_ring();
    translate([0, 0, -central_body_length/2 - flange_thickness - spacer_ring_thickness/2])
        spacer_ring();
    
    // Bolts and Nuts
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([bolt_spacing_radius * cos(angle), bolt_spacing_radius * sin(angle), central_body_length/2 + flange_thickness + spacer_ring_thickness])
            bolt();
        translate([bolt_spacing_radius * cos(angle), bolt_spacing_radius * sin(angle), -central_body_length/2 - flange_thickness - spacer_ring_thickness])
            bolt();
        
        translate([bolt_spacing_radius * cos(angle), bolt_spacing_radius * sin(angle), central_body_length/2 + flange_thickness + spacer_ring_thickness + bolt_length/2])
            nut();
        translate([bolt_spacing_radius * cos(angle), bolt_spacing_radius * sin(angle), -central_body_length/2 - flange_thickness - spacer_ring_thickness - bolt_length/2])
            nut();
    }
}

// Render the coupling
coupling();

