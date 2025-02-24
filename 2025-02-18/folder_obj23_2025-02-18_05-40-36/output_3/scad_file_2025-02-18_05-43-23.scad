
// Parameters
shaft_diameter = 10; // Adjusted to match original model
shaft_length = 30; // Adjusted length for proper proportions
flange_diameter = 18; // Adjusted for correct fit
flange_thickness = 3; // Reduced thickness to match original
spacer_thickness = 5; // Adjusted thickness for proper spacing
bolt_diameter = 2; // Adjusted for better alignment
bolt_length = 10; // Adjusted bolt length
nut_diameter = 4; // Adjusted nut size
nut_thickness = 2; // Adjusted nut thickness
hole_spacing = 9; // Adjusted hole spacing

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
            translate([0, 0, -shaft_length/4]) 
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
            translate([0, 0, -shaft_length/4]) 
            cylinder(h=shaft_length/4, d=flange_diameter, center=true);
        }
        cylinder(h=shaft_length, d=bolt_diameter, center=true);
    }
}

// Flange Plate
module flange_plate() {
    difference() {
        cylinder(h=flange_thickness, d=flange_diameter, center=true);
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

