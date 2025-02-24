
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

// Outer Casing
module outer_casing() {
    difference() {
        cylinder(d=outer_diameter, h=outer_length, center=true);
        cylinder(d=outer_diameter - 2 * wall_thickness, h=outer_length, center=true);
    }
}

// Inner Hub
module inner_hub() {
    difference() {
        cylinder(d=inner_hub_diameter, h=inner_hub_length, center=true);
        cylinder(d=shaft_hole_diameter, h=inner_hub_length + 2, center=true);
    }
}

// Elastomeric Coupling Element
module elastomeric_coupling_element() {
    difference() {
        cylinder(d=inner_hub_diameter + 2 * elastomer_thickness, h=inner_hub_length, center=true);
        cylinder(d=inner_hub_diameter, h=inner_hub_length + 2, center=true);
        
        // Create teeth
        for (i = [0:tooth_count-1]) {
            rotate([0, 0, i * 360 / tooth_count])
                translate([(inner_hub_diameter + elastomer_thickness) / 2, 0, 0])
                cylinder(d=tooth_depth, h=inner_hub_length + 2, center=true);
        }
    }
}

// Assemble the coupling
module flexible_coupling() {
    outer_casing();
    
    translate([0, 0, inner_hub_length / 2])
        inner_hub();
    
    translate([0, 0, -inner_hub_length / 2])
        inner_hub();
    
    elastomeric_coupling_element();
}

// Render the model
flexible_coupling();

