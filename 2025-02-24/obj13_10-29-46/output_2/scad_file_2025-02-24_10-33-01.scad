
// Parameters
outer_diameter = 50;
outer_length = 60;
wall_thickness = 5;
inner_hub_diameter = 30;
inner_hub_length = 25;
shaft_hole_diameter = 10;
elastomer_thickness = 5;
tooth_count = 40;
tooth_depth = 2;
tooth_width = 2;
tooth_height = 2;

// Outer Casing with smoother cylindrical shape and better integration
module outer_casing() {
    difference() {
        cylinder(d=outer_diameter, h=outer_length, center=true, $fn=100);
        cylinder(d=outer_diameter - 2 * wall_thickness, h=outer_length, center=true, $fn=100);
        
        // Add fine teeth on the inner surface
        for (i = [0:tooth_count-1]) {
            rotate([0, 0, i * 360 / tooth_count])
                translate([(outer_diameter - wall_thickness) / 2, 0, 0])
                cylinder(d=tooth_width, h=outer_length, center=true, $fn=20);
        }
    }
}

// Inner Hub with proper alignment and engagement
module inner_hub() {
    difference() {
        cylinder(d=inner_hub_diameter, h=inner_hub_length, center=true, $fn=100);
        cylinder(d=shaft_hole_diameter, h=inner_hub_length + 2, center=true, $fn=100);
        
        // Add fine teeth on the outer surface
        for (i = [0:tooth_count-1]) {
            rotate([0, 0, i * 360 / tooth_count])
                translate([(inner_hub_diameter + tooth_depth) / 2, 0, 0])
                cylinder(d=tooth_width, h=inner_hub_length, center=true, $fn=20);
        }
    }
}

// Elastomeric Coupling Element with more pronounced grooves
module elastomeric_coupling_element() {
    difference() {
        cylinder(d=inner_hub_diameter + 2 * elastomer_thickness, h=inner_hub_length, center=true, $fn=100);
        cylinder(d=inner_hub_diameter, h=inner_hub_length + 2, center=true, $fn=100);
        
        // Add fine teeth on the outer surface
        for (i = [0:tooth_count-1]) {
            rotate([0, 0, i * 360 / tooth_count])
                translate([(inner_hub_diameter + elastomer_thickness) / 2, 0, 0])
                cylinder(d=tooth_width, h=inner_hub_length, center=true, $fn=20);
        }
        
        // Add fine teeth on the inner surface
        for (i = [0:tooth_count-1]) {
            rotate([0, 0, i * 360 / tooth_count])
                translate([(inner_hub_diameter) / 2, 0, 0])
                cylinder(d=tooth_width, h=inner_hub_length, center=true, $fn=20);
        }
    }
}

// Assemble the coupling with proper alignment
module flexible_coupling() {
    outer_casing();
    
    translate([0, 0, inner_hub_length / 2 + elastomer_thickness / 2])
        inner_hub();
    
    translate([0, 0, -inner_hub_length / 2 - elastomer_thickness / 2])
        inner_hub();
    
    elastomeric_coupling_element();
}

// Render the model
flexible_coupling();

