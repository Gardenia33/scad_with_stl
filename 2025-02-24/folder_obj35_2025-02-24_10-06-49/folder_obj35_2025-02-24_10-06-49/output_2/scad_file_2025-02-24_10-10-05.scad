
// Parameters
flange_diameter = 80;
flange_thickness = 3; // Reduced thickness for accuracy
hub_diameter = 30;
hub_length = 20;
shaft_hole_diameter = 15;
bolt_hole_diameter = 5;
bolt_circle_diameter = 60;
bolt_length = 30; // Increased length for better accuracy
bolt_head_diameter = 10; // More defined hexagonal head
bolt_head_height = 5;
nut_diameter = 12; // Adjusted for better fit
nut_thickness = 6;
num_bolts = 4;
hub_recess_depth = 3;
hub_recess_diameter = 40;

// Function to create a flange hub with additional structural details
module flange_hub() {
    difference() {
        union() {
            // Flange with refined thickness
            cylinder(h=flange_thickness, d=flange_diameter, center=true);
            
            // Hub with refined cutouts
            translate([0, 0, -hub_length/2])
                cylinder(h=hub_length, d=hub_diameter, center=true);
            
            // Additional recess for structural refinement
            translate([0, 0, -hub_length/2 + hub_recess_depth])
                cylinder(h=hub_recess_depth, d=hub_recess_diameter, center=true);
            
            // Adding cutout details to match the original model
            for (i = [0:num_bolts-1]) {
                angle = i * 360 / num_bolts;
                translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), -hub_length/2])
                    cylinder(h=hub_length/2, d=bolt_hole_diameter * 1.5, center=true);
            }
        }
        
        // Shaft hole
        cylinder(h=hub_length + flange_thickness + 2, d=shaft_hole_diameter, center=true);
        
        // Bolt holes
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), 0])
                cylinder(h=flange_thickness + 2, d=bolt_hole_diameter, center=true);
        }
    }
}

// Function to create a diaphragm with curvature and integration refinements
module diaphragm() {
    difference() {
        // Thinner diaphragm for better flexibility
        hull() {
            translate([0, 0, -0.3])
                cylinder(h=0.6, d=flange_diameter, center=true);
            translate([0, 0, 0.3])
                cylinder(h=0.6, d=flange_diameter * 0.98, center=true);
        }
        
        // Bolt holes with better alignment
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), 0])
                cylinder(h=3, d=bolt_hole_diameter, center=true);
        }
    }
}

// Function to create a properly aligned bolt with hexagonal head
module bolt() {
    union() {
        // Bolt shaft
        cylinder(h=bolt_length, d=bolt_hole_diameter, center=true);
        
        // Hexagonal bolt head
        translate([0, 0, bolt_length/2])
            cylinder(h=bolt_head_height, d=bolt_head_diameter, $fn=6, center=true);
    }
}

// Function to create a properly aligned hexagonal nut
module nut() {
    cylinder(h=nut_thickness, d=nut_diameter, $fn=6, center=true);
}

// Assembly with corrected bolt and nut alignment
module coupling() {
    translate([0, 0, hub_length/2])
        flange_hub();
    
    translate([0, 0, hub_length/2 + flange_thickness])
        diaphragm();
    
    translate([0, 0, hub_length/2 + flange_thickness + 1])
        flange_hub();
    
    translate([0, 0, hub_length/2 + flange_thickness * 2 + 1])
        diaphragm();

    // Bolts and nuts correctly positioned
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), hub_length/2 + flange_thickness])
            rotate([0, 0, angle])
                bolt();
        
        translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), -hub_length/2 - flange_thickness - nut_thickness])
            rotate([0, 0, angle])
                nut();
    }
}

// Render the coupling
coupling();

