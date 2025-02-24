
// Parameters
central_cylinder_diameter = 50;
central_cylinder_length = 60;
flange_diameter = 70;
flange_thickness = 5;
spacer_ring_thickness = 3;
bolt_diameter = 5;
bolt_length = 15;
nut_diameter = 8;
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

// Central Cylinder
module central_cylinder() {
    cylinder(d=central_cylinder_diameter, h=central_cylinder_length, center=true);
}

// Flange Plate
module flange_plate() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true);
        // Bolt holes
        bolt_positions() {
            cylinder(d=bolt_diameter, h=flange_thickness+2, center=true);
        }
    }
}

// Spacer Ring
module spacer_ring() {
    difference() {
        cylinder(d=flange_diameter, h=spacer_ring_thickness, center=true);
        cylinder(d=central_cylinder_diameter, h=spacer_ring_thickness+2, center=true);
    }
}

// Bolt
module bolt() {
    translate([0, 0, -bolt_length/2])
        cylinder(d=bolt_diameter, h=bolt_length, center=true);
}

// Nut
module nut() {
    cylinder(d=nut_diameter, h=5, $fn=6);
}

// Assembly
module coupling() {
    // Central Cylinder
    central_cylinder();
    
    // Flange Plates
    translate([0, 0, central_cylinder_length/2 + spacer_ring_thickness + flange_thickness/2])
        flange_plate();
    translate([0, 0, -central_cylinder_length/2 - spacer_ring_thickness - flange_thickness/2])
        flange_plate();
    
    // Spacer Rings
    translate([0, 0, central_cylinder_length/2 + spacer_ring_thickness/2])
        spacer_ring();
    translate([0, 0, -central_cylinder_length/2 - spacer_ring_thickness/2])
        spacer_ring();
    
    // Bolts and Nuts
    bolt_positions() {
        translate([0, 0, central_cylinder_length/2 + spacer_ring_thickness + flange_thickness])
            bolt();
        translate([0, 0, -central_cylinder_length/2 - spacer_ring_thickness - flange_thickness])
            rotate([0, 180, 0]) bolt();
        
        translate([0, 0, central_cylinder_length/2 + spacer_ring_thickness + flange_thickness + bolt_length/2])
            nut();
        translate([0, 0, -central_cylinder_length/2 - spacer_ring_thickness - flange_thickness - bolt_length/2])
            nut();
    }
}

// Render the coupling
coupling();

