
// Parameters
flange_diameter = 45; 
flange_thickness = 3; // Reduced thickness to match original
spacer_thickness = 2; // Added thinner spacer rings
bolt_diameter = 6; 
bolt_length = 22; 
nut_diameter = 8; 
nut_thickness = 4; 
cylinder_diameter = 30; 
cylinder_middle_diameter = 35; // Added wider middle section
cylinder_length = 40; 
hole_spacing = 22; 

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

// Function to create the central cylinder with a wider middle section
module central_cylinder() {
    difference() {
        union() {
            cylinder(d=cylinder_diameter, h=cylinder_length / 3, center=true);
            translate([0, 0, cylinder_length / 3])
                cylinder(d=cylinder_middle_diameter, h=cylinder_length / 3, center=true);
            translate([0, 0, -cylinder_length / 3])
                cylinder(d=cylinder_diameter, h=cylinder_length / 3, center=true);
        }
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

