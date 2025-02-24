//start

// Parameters
central_body_diameter = 50;
central_body_length = 65; // Extended length to match the original model
flange_diameter = 70;
flange_thickness = 8; // Increased thickness to match the original model
spacer_ring_thickness = 4; // Increased thickness to match the original model
bolt_diameter = 5;
bolt_length = 18; // Extended length to match the original model
nut_diameter = 7; 
bolt_spacing_radius = 25;
num_bolts = 10;

// Central Body
module central_body() {
    cylinder(d=central_body_diameter, h=central_body_length, center=true);
}

// Flange Plate
module flange_plate() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            x = bolt_spacing_radius * cos(angle);
            y = bolt_spacing_radius * sin(angle);
            translate([x, y, 0]) cylinder(d=bolt_diameter, h=flange_thickness + 2, center=true); // Adjusted hole size
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
    translate([0, 0, -bolt_length/2])
        cylinder(d=bolt_diameter, h=bolt_length, center=true);
}

// Nut
module nut() {
    translate([0, 0, bolt_diameter / 2]) // Adjusted to protrude slightly more
        cylinder(d=nut_diameter, h=bolt_diameter, $fn=6, center=true);
}

// Assembly
module coupling() {
    // Central Body
    central_body();

    // Flange Plates
    translate([0, 0, central_body_length/2 + flange_thickness/2]) flange_plate(); // Adjusted position
    translate([0, 0, -central_body_length/2 - flange_thickness/2]) flange_plate(); // Adjusted position

    // Spacer Rings
    translate([0, 0, central_body_length/2 + flange_thickness + spacer_ring_thickness/2]) spacer_ring(); // Adjusted position
    translate([0, 0, -central_body_length/2 - flange_thickness - spacer_ring_thickness/2]) spacer_ring(); // Adjusted position

    // Bolts and Nuts
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        x = bolt_spacing_radius * cos(angle);
        y = bolt_spacing_radius * sin(angle);
        
        // Bolts
        translate([x, y, 0]) bolt();
        
        // Nuts
        translate([x, y, bolt_length/2 + bolt_diameter / 2]) nut(); // Adjusted position to protrude more
        translate([x, y, -bolt_length/2 - bolt_diameter / 2]) nut(); // Adjusted position to protrude more
    }
}

// Render the coupling
coupling();

