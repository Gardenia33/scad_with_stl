
// Parameters
hub_diameter = 30;
hub_height = 10; // Shortened to match the original model
bore_diameter = 10;
fastening_hole_diameter = 5;
fastening_hole_offset = 8; // Adjusted hole positions
slit_width = 2;
slit_depth = hub_diameter / 2; // Extended slit depth
spacer_thickness = 2;
spacer_wavy_amplitude = 2; // Increased for better flexibility
spacer_wavy_frequency = 4; // Adjusted for a more distinct wavy shape
screw_diameter = 4;
screw_length = 20;

// Module for a single hub
module hub() {
    difference() {
        cylinder(d=hub_diameter, h=hub_height, center=true);
        
        // Central bore
        cylinder(d=bore_diameter, h=hub_height + 2, center=true);
        
        // Fastening holes
        for (i = [0:3]) {
            rotate([0, 0, i * 90])
                translate([fastening_hole_offset, 0, 0])
                cylinder(d=fastening_hole_diameter, h=hub_height + 2, center=true);
        }
        
        // Slit for clamping flexibility (extended depth)
        translate([-hub_diameter/2, 0, 0])
            cube([hub_diameter, slit_width, hub_height + 2], center=true);
        
        // Additional cut to extend slit towards the center
        translate([-slit_depth, 0, 0])
            cube([slit_depth, slit_width, hub_height + 2], center=true);
    }
}

// Module for the flexible spacer
module flexible_spacer() {
    difference() {
        cylinder(d=hub_diameter - 2, h=spacer_thickness, center=true);
        
        // Central bore
        cylinder(d=bore_diameter, h=spacer_thickness + 2, center=true);
        
        // Wavy profile (more distinct)
        for (i = [0:spacer_wavy_frequency-1]) {
            rotate([0, 0, i * (360 / spacer_wavy_frequency)])
                translate([hub_diameter/4, 0, 0])
                scale([1, 0.5, 1])
                cylinder(d=spacer_wavy_amplitude * 2, h=spacer_thickness + 2, center=true);
        }
    }
}

// Module for a fastening screw
module fastening_screw() {
    translate([0, 0, -hub_height/2])
        cylinder(d=screw_diameter, h=screw_length, center=true);
}

// Assembly
module flexible_coupling() {
    translate([0, 0, hub_height])
        hub();
    
    // Fastening screws (top layer, correctly positioned)
    for (i = [0:3]) {
        rotate([0, 0, i * 90])
            translate([fastening_hole_offset, 0, hub_height])
            fastening_screw();
    }
    
    // Flexible spacer
    translate([0, 0, hub_height/2])
        flexible_spacer();
    
    // Fastening screws (bottom layer, correctly positioned)
    for (i = [0:3]) {
        rotate([0, 0, i * 90])
            translate([fastening_hole_offset, 0, hub_height/2])
            fastening_screw();
    }
    
    // Bottom hub
    hub();
}

// Render the full model
flexible_coupling();

