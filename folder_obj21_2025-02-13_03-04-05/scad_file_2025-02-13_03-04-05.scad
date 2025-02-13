//start

// Parameters
central_body_diameter = 50;
central_body_length = 60;
flange_diameter = 70;
flange_thickness = 5;
spacer_thickness = 3;
bolt_radius = 2.5;
bolt_length = 15;
nut_size = 6;
bolt_hole_radius = 3;
bolt_count = 10;
bolt_circle_radius = 30;

// Function to create a bolt
module bolt() {
    union() {
        cylinder(h=bolt_length, r=bolt_radius, center=true);
        translate([0, 0, bolt_length/2])
            cylinder(h=3, r1=bolt_radius, r2=bolt_radius*1.5);
    }
}

// Function to create a nut
module nut() {
    cylinder(h=4, r=nut_size, $fn=6);
}

// Function to create a flange plate
module flange_plate() {
    difference() {
        cylinder(h=flange_thickness, r=flange_diameter/2, center=true);
        cylinder(h=flange_thickness+1, r=central_body_diameter/2, center=true);
        for (i = [0:bolt_count-1]) {
            angle = i * 360 / bolt_count;
            translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), 0])
                cylinder(h=flange_thickness+1, r=bolt_hole_radius, center=true);
        }
    }
}

// Function to create a spacer ring
module spacer_ring() {
    difference() {
        cylinder(h=spacer_thickness, r=flange_diameter/2, center=true);
        cylinder(h=spacer_thickness+1, r=central_body_diameter/2, center=true);
    }
}

// Function to create the central body
module central_body() {
    cylinder(h=central_body_length, r=central_body_diameter/2, center=true);
}

// Assembly
module coupling() {
    // Central body
    translate([0, 0, 0])
        central_body();

    // Flange plates
    translate([0, 0, central_body_length/2 + spacer_thickness + flange_thickness/2])
        flange_plate();
    translate([0, 0, -central_body_length/2 - spacer_thickness - flange_thickness/2])
        flange_plate();

    // Spacer rings
    translate([0, 0, central_body_length/2 + spacer_thickness/2])
        spacer_ring();
    translate([0, 0, -central_body_length/2 - spacer_thickness/2])
        spacer_ring();

    // Bolts and nuts
    for (i = [0:bolt_count-1]) {
        angle = i * 360 / bolt_count;
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), central_body_length/2 + spacer_thickness + flange_thickness])
            rotate([90, 0, angle])
                bolt();
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), -central_body_length/2 - spacer_thickness - flange_thickness])
            rotate([90, 0, angle])
                bolt();
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), central_body_length/2 + spacer_thickness + flange_thickness + bolt_length])
            rotate([90, 0, angle])
                nut();
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), -central_body_length/2 - spacer_thickness - flange_thickness - bolt_length])
            rotate([90, 0, angle])
                nut();
    }
}

// Render the coupling
coupling();

