
// Parameters
shaft_hub_diameter = 40;
shaft_hub_length = 40;
shaft_hole_diameter = 20;
flange_diameter = 80;
flange_thickness = 10; // Reduced thickness for better accuracy
bolt_hole_diameter = 8;
bolt_count = 6;
bolt_length = 40; // Extended bolts for proper protrusion
bolt_diameter = 8;
nut_diameter = 12;
nut_thickness = 6;
spacer_diameter = 70;
spacer_thickness = 20; // Adjusted thickness for better separation

// Function to create a shaft hub with refined curvature
module shaft_hub() {
    difference() {
        union() {
            cylinder(d=shaft_hub_diameter, h=shaft_hub_length, center=true);
            translate([0, 0, shaft_hub_length/2])
                cylinder(d1=shaft_hub_diameter, d2=shaft_hub_diameter * 0.9, h=5, center=false);
        }
        cylinder(d=shaft_hole_diameter, h=shaft_hub_length + 2, center=true);
    }
}

// Function to create a refined flange plate
module flange_plate() {
    difference() {
        union() {
            cylinder(d=flange_diameter, h=flange_thickness, center=true);
            translate([0, 0, flange_thickness/2])
                cylinder(d1=flange_diameter, d2=flange_diameter * 0.95, h=2, center=false);
        }
        cylinder(d=shaft_hole_diameter, h=flange_thickness + 2, center=true);
        for (i = [0:bolt_count-1]) {
            angle = i * 360 / bolt_count;
            translate([flange_diameter/3 * cos(angle), flange_diameter/3 * sin(angle), 0])
                cylinder(d=bolt_hole_diameter, h=flange_thickness + 2, center=true);
        }
    }
}

// Function to create a distinct spacer element
module spacer_element() {
    difference() {
        cylinder(d=spacer_diameter, h=spacer_thickness, center=true);
        cylinder(d=shaft_hole_diameter, h=spacer_thickness + 2, center=true);
        for (i = [0:bolt_count-1]) {
            angle = i * 360 / bolt_count;
            translate([flange_diameter/3 * cos(angle), flange_diameter/3 * sin(angle), 0])
                cylinder(d=bolt_hole_diameter, h=spacer_thickness + 2, center=true);
        }
    }
}

// Function to create a bolt with a hexagonal head
module bolt() {
    union() {
        cylinder(d=bolt_diameter, h=bolt_length, center=true);
        translate([0, 0, bolt_length/2])
            cylinder(d=nut_diameter, h=nut_thickness, center=false, $fn=6);
    }
}

// Function to create a hexagonal nut
module nut() {
    cylinder(d=nut_diameter, h=nut_thickness, center=true, $fn=6);
}

// Assembly
module coupling() {
    translate([0, 0, -shaft_hub_length/2 - flange_thickness])
        shaft_hub();
    
    translate([0, 0, shaft_hub_length/2 + flange_thickness])
        shaft_hub();
    
    translate([0, 0, -flange_thickness/2])
        flange_plate();
    
    translate([0, 0, flange_thickness/2 + spacer_thickness])
        flange_plate();
    
    translate([0, 0, spacer_thickness/2])
        spacer_element();
    
    for (i = [0:bolt_count-1]) {
        angle = i * 360 / bolt_count;
        translate([flange_diameter/3 * cos(angle), flange_diameter/3 * sin(angle), -bolt_length/2])
            rotate([90, 0, angle])
                bolt();
        
        translate([flange_diameter/3 * cos(angle), flange_diameter/3 * sin(angle), bolt_length/2])
            rotate([90, 0, angle])
                nut();
    }
}

// Render the coupling
coupling();

