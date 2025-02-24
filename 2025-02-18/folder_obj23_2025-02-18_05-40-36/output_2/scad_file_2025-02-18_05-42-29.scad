
// Parameters
shaft_diameter = 12; // Increased diameter to match original model
shaft_length = 35; // Extended central shaft length
flange_diameter = 20; // Adjusted for better fit
flange_thickness = 4; // Increased thickness
spacer_thickness = 6; // Increased thickness
bolt_diameter = 2.5; // Adjusted for better alignment
bolt_length = 12; // Lengthened bolts
nut_diameter = 4.5; // Increased nut size
nut_thickness = 2.5; // Adjusted nut thickness
hole_spacing = 10; // Adjusted hole spacing

// Central Shaft
module central_shaft() {
    difference() {
        cylinder(h=shaft_length, d=shaft_diameter, center=true);
        cylinder(h=shaft_length+2, d=bolt_diameter, center=true);
    }
}

// Left Shaft
module left_shaft() {
    translate([-shaft_length/2, 0, 0])
    difference() {
        union() {
            cylinder(h=shaft_length/2, d=shaft_diameter, center=true);
            translate([0, 0, -shaft_length/4]) // More pronounced step
            cylinder(h=shaft_length/4, d=flange_diameter, center=true);
        }
        cylinder(h=shaft_length, d=bolt_diameter, center=true);
    }
}

// Right Shaft
module right_shaft() {
    translate([shaft_length/2, 0, 0])
    difference() {
        union() {
            cylinder(h=shaft_length/2, d=shaft_diameter, center=true);
            translate([0, 0, -shaft_length/4]) // More pronounced step
            cylinder(h=shaft_length/4, d=flange_diameter, center=true);
        }
        cylinder(h=shaft_length, d=bolt_diameter, center=true);
    }
}

// Flange Plate
module flange_plate() {
    difference() {
        cylinder(h=flange_thickness, d=flange_diameter, center=true);
        cylinder(h=flange_thickness+2, d=bolt_diameter, center=true);
        for (i = [0:3]) {
            rotate([0, 0, i * 90])
            translate([hole_spacing, 0, 0])
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
    union() {
        cylinder(h=bolt_length, d=bolt_diameter, center=true);
        translate([0, 0, bolt_length/2])
        cylinder(h=nut_thickness, d=nut_diameter, center=true);
    }
}

// Assembly
module coupling() {
    central_shaft();
    
    left_shaft();
    right_shaft();
    
    translate([-shaft_length/2, 0, 0]) flange_plate();
    translate([-shaft_length/2 - spacer_thickness, 0, 0]) spacer_ring();
    translate([-shaft_length/2 - spacer_thickness - flange_thickness, 0, 0]) flange_plate();
    
    translate([shaft_length/2, 0, 0]) flange_plate();
    translate([shaft_length/2 + spacer_thickness, 0, 0]) spacer_ring();
    translate([shaft_length/2 + spacer_thickness + flange_thickness, 0, 0]) flange_plate();
    
    for (i = [0:3]) {
        rotate([0, 0, i * 90])
        translate([-shaft_length/2 - spacer_thickness/2, hole_spacing, 0])
        bolt();
        
        rotate([0, 0, i * 90])
        translate([shaft_length/2 + spacer_thickness/2, hole_spacing, 0])
        bolt();
    }
}

// Render the coupling
coupling();

