
// Clamp Hub Module
module clamp_hub() {
    difference() {
        cylinder(h=10, d=20);
        translate([0,0,-1]) cylinder(h=12, d=5); // Shaft hole
        translate([0,0,5]) cube([20, 5, 10], center=true); // Clamp cut
    }
}

// Flexible Element Module
module flexible_element() {
    difference() {
        cylinder(h=3, d=15);
        translate([0,0,-1]) cylinder(h=5, d=5); // Central hole
    }
}

// Spacer Pin Module
module spacer_pin() {
    cylinder(h=10, d=3);
}

// Fastener Screw Module
module fastener_screw() {
    union() {
        cylinder(h=8, d=3);
        translate([0,0,8]) cylinder(h=2, d=5);
    }
}

// Assemble the coupling
module flexible_coupling() {
    translate([0, 0, -10]) clamp_hub();
    translate([0, 0, 10]) clamp_hub();
    
    translate([0, 0, -3]) flexible_element();
    translate([0, 0, 0]) flexible_element();
    translate([0, 0, 3]) flexible_element();
    
    translate([7, 0, -3]) spacer_pin();
    translate([7, 0, 0]) spacer_pin();
    translate([7, 0, 3]) spacer_pin();
    
    translate([-7, 0, -3]) fastener_screw();
    translate([-7, 0, 0]) fastener_screw();
    translate([-7, 0, 3]) fastener_screw();
}

// Render the model
flexible_coupling();

