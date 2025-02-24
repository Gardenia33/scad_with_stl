
// Clamp Hub Module with refined shape and fastener cutouts
module clamp_hub() {
    difference() {
        cylinder(h=10, d=20, $fn=100); // Increased smoothness
        translate([0,0,-1]) cylinder(h=12, d=5, $fn=100); // Shaft hole
        translate([0,0,5]) cube([20, 5, 10], center=true); // Clamp cut
        
        // Adding fastener holes with refined positioning
        translate([8, 0, 5]) rotate([0,90,0]) cylinder(h=10, d=3, $fn=100);
        translate([-8, 0, 5]) rotate([0,90,0]) cylinder(h=10, d=3, $fn=100);
    }
}

// Flexible Element Module with curved cutouts for flexibility
module flexible_element() {
    difference() {
        cylinder(h=3, d=15, $fn=100);
        translate([0,0,-1]) cylinder(h=5, d=5, $fn=100); // Central hole
        
        // Adding curved cutouts for flexibility with improved smoothness
        for (i = [0:120:360]) {
            rotate([0,0,i]) translate([7,0,0]) cylinder(h=3, d=5, $fn=100);
        }
    }
}

// Spacer Pin Module with proper cylindrical shape
module spacer_pin() {
    cylinder(h=10, d=3, $fn=100);
}

// Fastener Screw Module with correct screw head shape
module fastener_screw() {
    union() {
        cylinder(h=8, d=3, $fn=100);
        translate([0,0,8]) cylinder(h=2, d=5, $fn=100);
    }
}

// Assemble the coupling with correct positioning
module flexible_coupling() {
    translate([0, 0, -10]) clamp_hub();
    translate([0, 0, 10]) clamp_hub();
    
    translate([0, 0, -3]) flexible_element();
    translate([0, 0, 0]) flexible_element();
    translate([0, 0, 3]) flexible_element();
    
    translate([7, 0, -3]) spacer_pin();
    translate([7, 0, 0]) spacer_pin();
    translate([7, 0, 3]) spacer_pin();
    
    translate([-8, 0, -3]) fastener_screw();
    translate([-8, 0, 0]) fastener_screw();
    translate([-8, 0, 3]) fastener_screw();
}

// Render the model
flexible_coupling();

