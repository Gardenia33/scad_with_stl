
// Parameters
shaft_length = 30; // Adjusted shaft length
shaft_diameter = 25; // Adjusted diameter
shaft_hole_diameter = 8;

flange_diameter = 50;
flange_thickness = 2.5; // Reduced thickness for smoother appearance
flange_hole_diameter = 8;
bolt_hole_radius = 3;
bolt_spacing_radius = 20;

diaphragm_thickness = 1.5; // Ensuring diaphragm is thin and visible

bolt_length = 22; // Adjusted bolt length
bolt_diameter = 6;
nut_size = 8; // More refined nut size

// Shaft Module (Refined cylindrical shape)
module shaft() {
    difference() {
        cylinder(h = shaft_length, d = shaft_diameter, center = true, $fn=100);
        cylinder(h = shaft_length + 2, d = shaft_hole_diameter, center = true, $fn=100);
    }
}

// Flange Module (Smoother and thinner)
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

// Diaphragm Module (Ensuring visibility and flexibility)
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

// Bolt Module (Refined cylindrical shape with rounded head)
module bolt() {
    union() {
        cylinder(h = bolt_length, d = bolt_diameter, center = true, $fn=100);
        translate([0, 0, bolt_length / 2])
        sphere(d = bolt_diameter, $fn=100);
    }
}

// Nut Module (Refined hexagonal shape)
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

