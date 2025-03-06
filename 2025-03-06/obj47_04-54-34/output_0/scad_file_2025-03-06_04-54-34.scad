
// Parameters
clamp_diameter = 30;
clamp_height = 15;
bore_diameter = 10;
hole_diameter = 6;
slit_width = 2;
flexible_element_thickness = 2;
screw_diameter = 4;
screw_length = 10;

// Clamp Half Module
module clamp_half() {
    difference() {
        cylinder(d=clamp_diameter, h=clamp_height, center=true);
        
        // Central bore
        cylinder(d=bore_diameter, h=clamp_height + 2, center=true);
        
        // Side holes
        translate([clamp_diameter/4, 0, 0])
            cylinder(d=hole_diameter, h=clamp_height + 2, center=true);
        translate([-clamp_diameter/4, 0, 0])
            cylinder(d=hole_diameter, h=clamp_height + 2, center=true);
        
        // Slit for clamping
        translate([clamp_diameter/2, 0, 0])
            cube([clamp_diameter, slit_width, clamp_height + 2], center=true);
    }
}

// Flexible Element Module
module flexible_element() {
    difference() {
        cylinder(d=clamp_diameter - 2, h=flexible_element_thickness, center=true);
        cylinder(d=bore_diameter, h=flexible_element_thickness + 2, center=true);
    }
}

// Fastening Screw Module
module fastening_screw() {
    cylinder(d=screw_diameter, h=screw_length, center=true);
}

// Assembly
module coupling() {
    translate([0, 0, clamp_height])
        clamp_half();
    
    translate([0, 0, -clamp_height])
        clamp_half();
    
    translate([0, 0, 0])
        flexible_element();
    
    // Fastening screws
    translate([clamp_diameter/4, 0, clamp_height])
        fastening_screw();
    translate([-clamp_diameter/4, 0, clamp_height])
        fastening_screw();
    translate([clamp_diameter/4, 0, -clamp_height])
        fastening_screw();
    translate([-clamp_diameter/4, 0, -clamp_height])
        fastening_screw();
}

// Render the coupling
coupling();

