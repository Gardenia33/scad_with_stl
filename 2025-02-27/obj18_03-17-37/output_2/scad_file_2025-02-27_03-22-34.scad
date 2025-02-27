
// Parameters
shaft_diameter = 12; // Adjusted for correct middle section thickness
shaft_length = 40;
hub_diameter = 22;
hub_length = 15; // Reduced to match the original compact design
flange_diameter = 32;
flange_thickness = 5; // Increased to match the original
spacer_thickness = 4; // Increased to match the original
bolt_diameter = 5; // Thickened to match the original
bolt_length = 24; // Lengthened to match the original
nut_diameter = 7; // Enlarged to match the original
nut_thickness = 5; // Enlarged to match the original
bolt_spacing = 14; // Adjusted for correct hole placement

// Central Shaft
module central_shaft() {
    difference() {
        cylinder(h=shaft_length, d=shaft_diameter, center=true);
        translate([0, 0, -shaft_length/2])
            cylinder(h=shaft_length, d=shaft_diameter - 4, center=true); // More pronounced middle section
    }
}

// Input and Output Hubs
module hub() {
    difference() {
        cylinder(h=hub_length, d=hub_diameter, center=true);
        cylinder(h=hub_length+2, d=shaft_diameter, center=true);
    }
}

// Flange Plate
module flange_plate() {
    difference() {
        cylinder(h=flange_thickness, d=flange_diameter, center=true);
        cylinder(h=flange_thickness+2, d=shaft_diameter, center=true);
        for (i = [0:3]) {
            rotate([0, 0, i * 90])
                translate([bolt_spacing, 0, 0])
                    cylinder(h=flange_thickness+2, d=bolt_diameter, center=true);
        }
    }
}

// Spacer Ring
module spacer_ring() {
    difference() {
        cylinder(h=spacer_thickness, d=flange_diameter, center=true);
        cylinder(h=spacer_thickness+2, d=shaft_diameter, center=true);
    }
}

// Bolt
module bolt() {
    cylinder(h=bolt_length, d=bolt_diameter, center=true);
}

// Nut
module nut() {
    cylinder(h=nut_thickness, d=nut_diameter, center=true);
}

// Assembly
module coupling() {
    translate([0, 0, -shaft_length/2 - hub_length/2]) hub();
    translate([0, 0, shaft_length/2 + hub_length/2]) hub();
    
    translate([0, 0, -shaft_length/2]) flange_plate();
    translate([0, 0, -shaft_length/2 + flange_thickness + spacer_thickness]) spacer_ring();
    translate([0, 0, -shaft_length/2 + 2 * flange_thickness + spacer_thickness]) flange_plate();
    
    translate([0, 0, shaft_length/2 - 2 * flange_thickness - spacer_thickness]) flange_plate();
    translate([0, 0, shaft_length/2 - flange_thickness - spacer_thickness]) spacer_ring();
    translate([0, 0, shaft_length/2]) flange_plate();
    
    central_shaft();
    
    for (i = [0:3]) {
        rotate([0, 0, i * 90]) {
            translate([bolt_spacing, 0, -shaft_length/2 + flange_thickness/2])
                bolt();
            translate([bolt_spacing, 0, -shaft_length/2 + flange_thickness + spacer_thickness + flange_thickness])
                bolt();
            translate([bolt_spacing, 0, shaft_length/2 - flange_thickness - spacer_thickness - flange_thickness])
                bolt();
            translate([bolt_spacing, 0, shaft_length/2 - flange_thickness/2])
                bolt();
            
            translate([bolt_spacing, 0, -shaft_length/2 + flange_thickness])
                nut();
            translate([bolt_spacing, 0, -shaft_length/2 + flange_thickness + spacer_thickness + flange_thickness])
                nut();
            translate([bolt_spacing, 0, shaft_length/2 - flange_thickness - spacer_thickness - flange_thickness])
                nut();
            translate([bolt_spacing, 0, shaft_length/2 - flange_thickness])
                nut();
        }
    }
}

// Render the coupling
coupling();

