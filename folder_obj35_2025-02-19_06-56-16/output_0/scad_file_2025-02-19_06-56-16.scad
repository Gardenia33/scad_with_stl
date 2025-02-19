
// Parameters
hub_diameter = 30;
hub_length = 40;
shaft_hole_diameter = 15;
flange_diameter = 80;
flange_thickness = 10;
spacer_thickness = 2;
bolt_hole_diameter = 5;
bolt_diameter = 5;
bolt_length = 20;
nut_size = 8;
bolt_count = 4;
bolt_circle_diameter = 50;

// Hub
module hub() {
    difference() {
        cylinder(d=hub_diameter, h=hub_length, center=true);
        cylinder(d=shaft_hole_diameter, h=hub_length + 2, center=true);
    }
}

// Flange Plate
module flange_plate() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true);
        cylinder(d=shaft_hole_diameter, h=flange_thickness + 2, center=true);
        for (i = [0:bolt_count-1]) {
            angle = i * 360 / bolt_count;
            translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), 0])
                cylinder(d=bolt_hole_diameter, h=flange_thickness + 2, center=true);
        }
    }
}

// Spacer Ring
module spacer_ring() {
    difference() {
        cylinder(d=flange_diameter, h=spacer_thickness, center=true);
        cylinder(d=shaft_hole_diameter, h=spacer_thickness + 2, center=true);
    }
}

// Bolt
module bolt() {
    cylinder(d=bolt_diameter, h=bolt_length, center=true);
}

// Nut
module nut() {
    cylinder(d=nut_size, h=nut_size/2, center=true, $fn=6);
}

// Assembly
module coupling_assembly() {
    hub();
    translate([0, 0, hub_length/2 + spacer_thickness/2])
        spacer_ring();
    translate([0, 0, hub_length/2 + spacer_thickness + flange_thickness/2])
        flange_plate();
    
    for (i = [0:bolt_count-1]) {
        angle = i * 360 / bolt_count;
        translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), hub_length/2 + spacer_thickness + flange_thickness])
            rotate([0, 90, 0])
                bolt();
        translate([bolt_circle_diameter/2 * cos(angle), bolt_circle_diameter/2 * sin(angle), hub_length/2 + spacer_thickness + flange_thickness + bolt_length])
            rotate([0, 90, 0])
                nut();
    }
}

// Render the coupling assembly
coupling_assembly();

