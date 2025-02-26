
// Parameters
shaft_length = 30; // Shortened shaft
shaft_radius = 7;  // Increased shaft radius
hub_radius = 12;   // Adjusted hub radius for compactness
hub_length = 8;    // Shortened hub length
flange_radius = 16; // Slightly increased flange radius
flange_thickness = 5; // Thickened flange
bolt_radius = 1.5;
bolt_length = 6; // Shortened bolts
nut_radius = 2.5;
nut_thickness = 2;
bolt_hole_offset = 8; // Adjusted bolt hole offset
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

