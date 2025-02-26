
// Parameters
shaft_length = 50;
shaft_radius = 5;
hub_radius = 10;
hub_length = 10;
flange_radius = 15;
flange_thickness = 3;
bolt_radius = 1.5;
bolt_length = 10;
nut_radius = 2.5;
nut_thickness = 2;
bolt_hole_offset = 10;
num_bolts = 4;

// Function to create a bolt
module bolt() {
    cylinder(h = bolt_length, r = bolt_radius);
    translate([0, 0, bolt_length])
        cylinder(h = nut_thickness, r = nut_radius);
}

// Function to create a flange plate
module flange_plate() {
    difference() {
        cylinder(h = flange_thickness, r = flange_radius);
        cylinder(h = flange_thickness + 1, r = shaft_radius);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_hole_offset * cos(angle), bolt_hole_offset * sin(angle), -0.5])
                cylinder(h = flange_thickness + 1, r = bolt_radius);
        }
    }
}

// Function to create a hub
module hub() {
    difference() {
        cylinder(h = hub_length, r = hub_radius);
        cylinder(h = hub_length + 1, r = shaft_radius);
    }
}

// Function to create the central shaft
module central_shaft() {
    cylinder(h = shaft_length, r = shaft_radius);
}

// Function to assemble the coupling
module coupling() {
    // Central shaft
    translate([0, 0, hub_length])
        central_shaft();

    // Input hub
    hub();

    // Output hub
    translate([0, 0, shaft_length + hub_length])
        hub();

    // Flange plates
    translate([0, 0, hub_length - flange_thickness])
        flange_plate();
    translate([0, 0, shaft_length + hub_length])
        flange_plate();

    // Bolts and nuts
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([bolt_hole_offset * cos(angle), bolt_hole_offset * sin(angle), hub_length - flange_thickness])
            bolt();
        translate([bolt_hole_offset * cos(angle), bolt_hole_offset * sin(angle), shaft_length + hub_length])
            bolt();
    }
}

// Render the coupling
coupling();

