
// Parameters
central_body_diameter = 50;
central_body_length = 60;
flange_diameter = 70;
flange_thickness = 3; // Reduced thickness
spacer_ring_thickness = 3;
bolt_diameter = 5;
bolt_length = 20; // Increased bolt length
nut_diameter = 8;
nut_thickness = 4;
bolt_spacing_radius = 25;
num_bolts = 12; // Increased number of bolts

// Central Body with structural reinforcements
module central_body() {
    difference() {
        cylinder(d=central_body_diameter, h=central_body_length, center=true);
        translate([0, 0, -central_body_length/2])
            cylinder(d=central_body_diameter + 10, h=10, center=false);
        translate([0, 0, central_body_length/2 - 10])
            cylinder(d=central_body_diameter + 10, h=10, center=false);
    }
}

// Flange Plate with correct bolt pattern
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

// External Flange Plate
module external_flange_plate() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true);
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

