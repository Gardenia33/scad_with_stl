
// Parameters
flange_diameter = 45; // Increased to match original model
flange_thickness = 4; // Reduced thickness
spacer_thickness = 3; // Adjusted for better definition
bolt_diameter = 6; // Increased for more prominence
bolt_length = 22; // Adjusted for better fit
nut_diameter = 8; // Increased for better visibility
nut_thickness = 4; // Adjusted for proper fastening
cylinder_diameter = 30; // Widened to match original model
cylinder_length = 40; // Shortened for better proportions
hole_spacing = 22; // Adjusted for better alignment

// Function to create a flange plate
module flange_plate() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true);
        cylinder(d=12, h=flange_thickness + 2, center=true);
        for (i = [0:3]) {
            rotate([0, 0, i * 90])
                translate([hole_spacing / 2, 0, 0])
                cylinder(d=bolt_diameter, h=flange_thickness + 2, center=true);
        }
    }
}

// Function to create a spacer ring
module spacer_ring() {
    difference() {
        cylinder(d=flange_diameter, h=spacer_thickness, center=true);
        cylinder(d=18, h=spacer_thickness + 2, center=true);
    }
}

// Function to create a bolt
module bolt() {
    cylinder(d=bolt_diameter, h=bolt_length, center=true);
}

// Function to create a nut
module nut() {
    cylinder(d=nut_diameter, h=nut_thickness, center=true, $fn=6);
}

// Function to create the central cylinder
module central_cylinder() {
    difference() {
        cylinder(d=cylinder_diameter, h=cylinder_length, center=true);
        for (i = [0:3]) {
            rotate([0, 0, i * 90])
                translate([hole_spacing / 2, 0, 0])
                cylinder(d=bolt_diameter, h=cylinder_length + 2, center=true);
        }
    }
}

// Assembly
module coupling() {
    translate([0, 0, cylinder_length / 2 + flange_thickness])
        flange_plate();
    
    translate([0, 0, cylinder_length / 2 + flange_thickness + spacer_thickness])
        spacer_ring();
    
    translate([0, 0, cylinder_length / 2 + 2 * flange_thickness + spacer_thickness])
        flange_plate();
    
    central_cylinder();
    
    translate([0, 0, -cylinder_length / 2 - flange_thickness])
        flange_plate();
    
    translate([0, 0, -cylinder_length / 2 - flange_thickness - spacer_thickness])
        spacer_ring();
    
    translate([0, 0, -cylinder_length / 2 - 2 * flange_thickness - spacer_thickness])
        flange_plate();
    
    for (i = [0:3]) {
        rotate([0, 0, i * 90])
            translate([hole_spacing / 2, 0, cylinder_length / 2 + flange_thickness])
                bolt();
        
        rotate([0, 0, i * 90])
            translate([hole_spacing / 2, 0, cylinder_length / 2 + flange_thickness + bolt_length])
                nut();
        
        rotate([0, 0, i * 90])
            translate([hole_spacing / 2, 0, -cylinder_length / 2 - flange_thickness])
                bolt();
        
        rotate([0, 0, i * 90])
            translate([hole_spacing / 2, 0, -cylinder_length / 2 - flange_thickness - bolt_length])
                nut();
    }
}

// Render the coupling
coupling();

