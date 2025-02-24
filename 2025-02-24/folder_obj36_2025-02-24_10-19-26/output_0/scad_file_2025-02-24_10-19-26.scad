
// Parameters
shaft_hub_diameter = 40;
shaft_hub_length = 50;
shaft_hole_diameter = 20;
flange_diameter = 80;
flange_thickness = 10;
bolt_hole_diameter = 8;
bolt_count = 6;
bolt_length = 30;
bolt_diameter = 8;
nut_diameter = 12;
nut_thickness = 6;
spacer_diameter = 70;
spacer_thickness = 20;

// Function to create a shaft hub
module shaft_hub() {
    difference() {
        cylinder(d=shaft_hub_diameter, h=shaft_hub_length, center=true);
        cylinder(d=shaft_hole_diameter, h=shaft_hub_length + 2, center=true);
    }
}

// Function to create a flange plate
module flange_plate() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true);
        cylinder(d=shaft_hole_diameter, h=flange_thickness + 2, center=true);
        for (i = [0:bolt_count-1]) {
            angle = i * 360 / bolt_count;
            translate([flange_diameter/2.5 * cos(angle), flange_diameter/2.5 * sin(angle), 0])
                cylinder(d=bolt_hole_diameter, h=flange_thickness + 2, center=true);
        }
    }
}

// Function to create the spacer element
module spacer_element() {
    difference() {
        cylinder(d=spacer_diameter, h=spacer_thickness, center=true);
        cylinder(d=shaft_hole_diameter, h=spacer_thickness + 2, center=true);
        for (i = [0:bolt_count-1]) {
            angle = i * 360 / bolt_count;
            translate([flange_diameter/2.5 * cos(angle), flange_diameter/2.5 * sin(angle), 0])
                cylinder(d=bolt_hole_diameter, h=spacer_thickness + 2, center=true);
        }
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
        translate([flange_diameter/2.5 * cos(angle), flange_diameter/2.5 * sin(angle), -bolt_length/2])
            rotate([90, 0, angle])
                bolt();
        
        translate([flange_diameter/2.5 * cos(angle), flange_diameter/2.5 * sin(angle), bolt_length/2])
            rotate([90, 0, angle])
                nut();
    }
}

// Render the coupling
coupling();

