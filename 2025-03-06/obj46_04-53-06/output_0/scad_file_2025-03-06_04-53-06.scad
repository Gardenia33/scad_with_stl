
// Parameters
coupling_diameter = 30;
coupling_height = 20;
bore_diameter = 10;
fastening_hole_diameter = 5;
fastening_hole_offset = 10;
slit_width = 2;
slit_depth = coupling_diameter / 2;
flexible_element_thickness = 2;
screw_diameter = 4;
screw_head_diameter = 6;
screw_length = 10;

// Coupling Half Module
module coupling_half() {
    difference() {
        cylinder(d=coupling_diameter, h=coupling_height, center=true);
        
        // Central bore
        cylinder(d=bore_diameter, h=coupling_height + 2, center=true);
        
        // Fastening holes
        for (i = [0:3]) {
            rotate([0, 0, i * 90])
                translate([fastening_hole_offset, 0, 0])
                    cylinder(d=fastening_hole_diameter, h=coupling_height + 2, center=true);
        }
        
        // Slit for clamping
        translate([-slit_width / 2, 0, 0])
            cube([slit_width, slit_depth, coupling_height + 2], center=true);
    }
}

// Flexible Element Module
module flexible_element() {
    difference() {
        cylinder(d=coupling_diameter, h=flexible_element_thickness, center=true);
        cylinder(d=bore_diameter, h=flexible_element_thickness + 2, center=true);
    }
}

// Clamping Screw Module
module clamping_screw() {
    union() {
        cylinder(d=screw_diameter, h=screw_length, center=true);
        translate([0, 0, screw_length / 2])
            cylinder(d=screw_head_diameter, h=screw_diameter, center=true);
    }
}

// Fastening Screw Module
module fastening_screw() {
    cylinder(d=screw_diameter, h=coupling_height * 2 + flexible_element_thickness, center=true);
}

// Assembly
module coupling_assembly() {
    translate([0, 0, coupling_height / 2])
        coupling_half();
    
    translate([0, 0, -coupling_height / 2 - flexible_element_thickness])
        flexible_element();
    
    translate([0, 0, -coupling_height - flexible_element_thickness - coupling_height / 2])
        coupling_half();
    
    // Fastening screws
    for (i = [0:3]) {
        rotate([0, 0, i * 90])
            translate([fastening_hole_offset, 0, 0])
                fastening_screw();
    }
    
    // Clamping screws
    translate([-slit_width / 2, 0, coupling_height / 2])
        clamping_screw();
    
    translate([-slit_width / 2, 0, -coupling_height - flexible_element_thickness - coupling_height / 2])
        clamping_screw();
}

// Render the assembly
coupling_assembly();

