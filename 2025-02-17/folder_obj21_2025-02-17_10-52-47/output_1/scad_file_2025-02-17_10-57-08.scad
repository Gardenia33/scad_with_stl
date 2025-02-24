// Parameters (adjusted for smoother surfaces, refined dimensions, and better matching of original model)
central_cylinder_diameter = 50;
central_cylinder_length = 60;
flange_diameter = 70;
flange_thickness = 3; // Reduced thickness for a closer match to original
spacer_ring_thickness = 5; // Increased thickness for more distinct rings
bolt_diameter = 4; // Reduced diameter for less protrusion
bolt_length = 10; // Shorter bolts to sit more flush
nut_diameter = 10; // Enlarged nuts for better definition
num_bolts = 8;
bolt_circle_radius = 30;

// Function to position bolts in a circular pattern
module bolt_positions() {
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), 0])
            children();
    }
}

// Central Cylinder (smoother surface via $fn)
module central_cylinder() {
    cylinder(d=central_cylinder_diameter, h=central_cylinder_length, center=true, $fn=100);
}

// Flange Plate with refined thickness and smoother edges (using $fn)
module flange_plate() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true, $fn=100);
        // Bolt holes
        bolt_positions() {
            cylinder(d=bolt_diameter, h=flange_thickness+2, center=true, $fn=100);
        }
    }
}

// Spacer Ring (made more distinct)
module spacer_ring() {
    difference() {
        cylinder(d=flange_diameter, h=spacer_ring_thickness, center=true, $fn=100);
        cylinder(d=central_cylinder_diameter, h=spacer_ring_thickness+2, center=true, $fn=100);
    }
}

// Bolt (refined size)
module bolt() {
    translate([0, 0, -bolt_length/2])
        cylinder(d=bolt_diameter, h=bolt_length, center=true, $fn=100);
}

// Nut (resized and refined)
module nut() {
    cylinder(d=nut_diameter, h=5, $fn=6);
}

// Assembly
module coupling() {
    // Central Cylinder
    central_cylinder();
    
    // Flange Plates (top and bottom)
    translate([0, 0, central_cylinder_length/2 + spacer_ring_thickness + flange_thickness/2])
        flange_plate();
    translate([0, 0, -central_cylinder_length/2 - spacer_ring_thickness - flange_thickness/2])
        flange_plate();
    
    // Spacer Rings (top and bottom)
    translate([0, 0, central_cylinder_length/2 + spacer_ring_thickness/2])
        spacer_ring();
    translate([0, 0, -central_cylinder_length/2 - spacer_ring_thickness/2])
        spacer_ring();
    
    // Bolts and Nuts (adjusted to be more flush)
    bolt_positions() {
        // Top bolt
        translate([0, 0, central_cylinder_length/2 + spacer_ring_thickness + flange_thickness - bolt_length/2])
            bolt();
        // Bottom bolt
        translate([0, 0, -central_cylinder_length/2 - spacer_ring_thickness - flange_thickness + bolt_length/2])
            rotate([0, 180, 0]) bolt();
        
        // Top nut
        translate([0, 0, (central_cylinder_length/2 + spacer_ring_thickness + flange_thickness) + bolt_length/2])
            nut();
        // Bottom nut
        translate([0, 0, (-central_cylinder_length/2 - spacer_ring_thickness - flange_thickness) - bolt_length/2])
            nut();
    }
}

// Render the coupling
coupling();
