
// Parameters
coupling_diameter = 30;
coupling_height = 15;
bore_diameter = 10;
fastening_hole_diameter = 5;
fastening_hole_offset = 10;
slit_width = 2;
slit_depth = 8;
flexible_element_thickness = 2;
screw_diameter = 4;
screw_head_diameter = 6;
screw_length = 8;
groove_depth = 3;
groove_width = 4;

// Coupling Half
module coupling_half() {
    difference() {
        cylinder(d=coupling_diameter, h=coupling_height, $fn=100);
        
        // Central bore
        cylinder(d=bore_diameter, h=coupling_height + 2, $fn=100);
        
        // Fastening holes
        for (i = [0:120:360]) {
            rotate([0, 0, i])
                translate([fastening_hole_offset, 0, 0])
                cylinder(d=fastening_hole_diameter, h=coupling_height + 2, $fn=50);
        }
        
        // Slits for flexibility
        for (i = [0:180:360]) {
            rotate([0, 0, i])
                translate([-coupling_diameter/2, 0, coupling_height/2])
                cube([coupling_diameter, slit_width, slit_depth], center=true);
        }
        
        // Grooves for additional flexibility
        for (i = [0:180:360]) {
            rotate([0, 0, i])
                translate([-coupling_diameter/2, 0, coupling_height/4])
                cube([coupling_diameter, groove_width, groove_depth], center=true);
        }
    }
}

// Flexible Element
module flexible_element() {
    difference() {
        cylinder(d=coupling_diameter, h=flexible_element_thickness, $fn=100);
        
        // Central bore
        cylinder(d=bore_diameter, h=flexible_element_thickness + 2, $fn=100);
        
        // Cutouts for flexibility
        for (i = [0:120:360]) {
            rotate([0, 0, i])
                translate([fastening_hole_offset, 0, 0])
                cylinder(d=fastening_hole_diameter, h=flexible_element_thickness + 2, $fn=50);
        }
        
        // Slits for flexibility
        for (i = [0:180:360]) {
            rotate([0, 0, i])
                translate([-coupling_diameter/2, 0, 0])
                cube([coupling_diameter, slit_width, flexible_element_thickness], center=true);
        }
    }
}

// Clamping Screw
module clamping_screw() {
    union() {
        cylinder(d=screw_diameter, h=screw_length, $fn=50);
        translate([0, 0, screw_length])
            cylinder(d=screw_head_diameter, h=2, $fn=50);
    }
}

// Assembly
module flexible_coupling() {
    translate([0, 0, coupling_height])
        coupling_half();
    
    translate([0, 0, coupling_height / 2 + flexible_element_thickness / 2])
        flexible_element();
    
    translate([0, 0, 0])
        coupling_half();
    
    // Clamping screws
    for (i = [0:180:360]) {
        rotate([0, 0, i])
            translate([fastening_hole_offset, 0, coupling_height - 2])
            clamping_screw();
        
        rotate([0, 0, i])
            translate([fastening_hole_offset, 0, 2])
            clamping_screw();
    }
}

// Render the model
flexible_coupling();

