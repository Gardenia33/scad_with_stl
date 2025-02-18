
// Parameters
central_body_diameter = 50;
central_body_length = 60;
flange_diameter = 70;
flange_thickness = 5;
spacer_ring_thickness = 3;
bolt_diameter = 5;
bolt_length = 15;
nut_diameter = 8;
nut_thickness = 4;
bolt_spacing_radius = 25;
num_bolts = 8;

// Central Body
module central_body() {
    cylinder(d=central_body_diameter, h=central_body_length, center=true);
}

// Flange Plate
module flange_plate() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true);
        cylinder(d=central_body_diameter, h=flange_thickness + 2, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_spacing_radius * cos(angle), bolt_spacing_radius * sin(angle), 0])
                cylinder(d=bolt_diameter, h=flange_thickness + 2, center=true);
        }
    }
}

// Spacer Ring
module spacer_ring() {
    difference() {
        cylinder(d=flange_diameter, h=spacer_ring_thickness, center=true);
        cylinder(d=central_body_diameter, h=spacer_ring_thickness + 2, center=true);
    }
}

// Bolt
module bolt() {
    cylinder(d=bolt_diameter, h=bolt_length, center=true);
}

// Nut
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
        flange_plate();
    translate([0, 0, -central_body_length/2 - flange_thickness - spacer_ring_thickness])
        flange_plate();
    
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

