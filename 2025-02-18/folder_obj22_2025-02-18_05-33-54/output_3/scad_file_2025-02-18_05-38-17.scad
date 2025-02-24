
// Parameters
shaft_length = 25; // Reduced shaft length to match the original model
shaft_diameter = 25;
shaft_hole_diameter = 10; // Adjusted hole diameter

flange_diameter = 50;
flange_thickness = 2; // Reduced thickness to match the original model
flange_hole_diameter = 8;
bolt_hole_radius = 2.5; // Adjusted bolt hole size
bolt_spacing_radius = 20;

diaphragm_thickness = 1; // Ensuring diaphragm is thin and visible

bolt_length = 18; // Reduced bolt length to match the original model
bolt_diameter = 5; // Reduced bolt size
nut_size = 6; // Reduced nut size

// Shaft Module
module shaft() {
    difference() {
        cylinder(h = shaft_length, d = shaft_diameter, center = true, $fn=100);
        cylinder(h = shaft_length + 2, d = shaft_hole_diameter, center = true, $fn=100);
    }
}

// Flange Module
module flange() {
    difference() {
        cylinder(h = flange_thickness, d = flange_diameter, center = true, $fn=100);
        cylinder(h = flange_thickness + 2, d = flange_hole_diameter, center = true, $fn=100);
        for (i = [0:60:360]) {
            rotate([0, 0, i])
            translate([bolt_spacing_radius, 0, 0])
            cylinder(h = flange_thickness + 2, d = bolt_hole_radius * 2, center = true, $fn=100);
        }
    }
}

// Diaphragm Module
module diaphragm() {
    difference() {
        cylinder(h = diaphragm_thickness, d = flange_diameter - 5, center = true, $fn=100);
        cylinder(h = diaphragm_thickness + 2, d = flange_hole_diameter, center = true, $fn=100);
        for (i = [0:60:360]) {
            rotate([0, 0, i])
            translate([bolt_spacing_radius, 0, 0])
            cylinder(h = diaphragm_thickness + 2, d = bolt_hole_radius * 2, center = true, $fn=100);
        }
    }
}

// Bolt Module
module bolt() {
    union() {
        cylinder(h = bolt_length, d = bolt_diameter, center = true, $fn=100);
        translate([0, 0, bolt_length / 2])
        sphere(d = bolt_diameter, $fn=100);
    }
}

// Nut Module
module nut() {
    cylinder(h = nut_size / 2, d = nut_size, $fn = 6);
}

// Assembly
module coupling() {
    translate([0, 0, -shaft_length / 2 - flange_thickness / 2])
    shaft();
    
    translate([0, 0, shaft_length / 2 + flange_thickness / 2])
    shaft();
    
    translate([0, 0, -flange_thickness / 2])
    flange();
    
    translate([0, 0, flange_thickness / 2])
    flange();
    
    translate([0, 0, 0])
    diaphragm();
    
    for (i = [0:60:360]) {
        rotate([0, 0, i])
        translate([bolt_spacing_radius, 0, -bolt_length / 2])
        bolt();
        
        rotate([0, 0, i])
        translate([bolt_spacing_radius, 0, bolt_length / 2])
        nut();
    }
}

// Render the coupling
coupling();

