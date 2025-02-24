
// Parameters
central_body_diameter = 50;
central_body_length = 60;
flange_diameter = 70;
flange_thickness = 2; // Reduced thickness for better integration
spacer_ring_thickness = 4; // Increased to make it more distinct
bolt_diameter = 4; // Reduced bolt size for a more flush appearance
bolt_length = 15; // Reduced bolt length for better alignment
nut_diameter = 6; // Reduced nut size for a more compact look
nut_thickness = 3; // Reduced thickness for better integration
bolt_spacing_radius = 25;
num_bolts = 8; // Reduced number of bolts to match the original model

// Central Body with smoother surface
module central_body() {
    cylinder(d=central_body_diameter, h=central_body_length, center=true, $fn=100);
}

// Flange Plate with correct thickness and alignment
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

// External Flange Plate with reduced thickness
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

// Spacer Ring with better separation
module spacer_ring() {
    difference() {
        cylinder(d=flange_diameter, h=spacer_ring_thickness, center=true, $fn=100);
        cylinder(d=central_body_diameter, h=spacer_ring_thickness + 2, center=true, $fn=100);
    }
}

// Bolt with reduced size
module bolt() {
    cylinder(d=bolt_diameter, h=bolt_length, center=true, $fn=50);
}

// Nut with reduced size and better alignment
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

