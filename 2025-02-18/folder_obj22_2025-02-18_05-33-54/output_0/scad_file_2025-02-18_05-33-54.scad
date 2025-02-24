
// Parameters
shaft_length = 40;
shaft_diameter = 20;
shaft_hole_diameter = 8;

flange_diameter = 50;
flange_thickness = 5;
flange_hole_diameter = 8;
bolt_hole_radius = 3;
bolt_spacing_radius = 20;

diaphragm_thickness = 2;

bolt_length = 30;
bolt_diameter = 6;
nut_size = 10;

// Shaft Module
module shaft() {
    difference() {
        cylinder(h = shaft_length, d = shaft_diameter, center = true);
        cylinder(h = shaft_length + 2, d = shaft_hole_diameter, center = true);
    }
}

// Flange Module
module flange() {
    difference() {
        cylinder(h = flange_thickness, d = flange_diameter, center = true);
        cylinder(h = flange_thickness + 2, d = flange_hole_diameter, center = true);
        for (i = [0:60:360]) {
            rotate([0, 0, i])
            translate([bolt_spacing_radius, 0, 0])
            cylinder(h = flange_thickness + 2, d = bolt_hole_radius * 2, center = true);
        }
    }
}

// Diaphragm Module
module diaphragm() {
    difference() {
        cylinder(h = diaphragm_thickness, d = flange_diameter - 5, center = true);
        cylinder(h = diaphragm_thickness + 2, d = flange_hole_diameter, center = true);
        for (i = [0:60:360]) {
            rotate([0, 0, i])
            translate([bolt_spacing_radius, 0, 0])
            cylinder(h = diaphragm_thickness + 2, d = bolt_hole_radius * 2, center = true);
        }
    }
}

// Bolt Module
module bolt() {
    cylinder(h = bolt_length, d = bolt_diameter, center = true);
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

