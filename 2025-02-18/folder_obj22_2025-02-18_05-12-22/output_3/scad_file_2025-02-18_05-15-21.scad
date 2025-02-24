```openscad
// Parameters
shaft_length = 40; 
shaft_diameter = 20; 
shaft_hole_diameter = 8;
shaft_wider_end_diameter = 24; // Adjusted for a smoother transition
shaft_wider_end_thickness = 6; 
flange_diameter = 40; 
flange_thickness = 4; // Thinner for a more accurate representation
bolt_hole_diameter = 5;
bolt_count = 6;
bolt_length = 18; 
bolt_diameter = 5;
nut_diameter = 10; 
nut_thickness = 5;
diaphragm_thickness = 2; // Thinner for better flexibility
diaphragm_diameter = 38; 
bolt_circle_radius = 15; 

// Function to create a simplified shaft
module shaft() {
    difference() {
        cylinder(h = shaft_length, d = shaft_diameter, center = true);
        cylinder(h = shaft_length + 2, d = shaft_hole_diameter, center = true);
    }
    // Wider end with smoother transition
    translate([0, 0, -shaft_length/2])
        cylinder(h = shaft_wider_end_thickness, d = shaft_wider_end_diameter, center = false);
}

// Function to create a refined flange plate
module flange_plate() {
    difference() {
        cylinder(h = flange_thickness, d = flange_diameter, center = true);
        cylinder(h = flange_thickness + 2, d = shaft_hole_diameter, center = true);
        
        // Bolt holes
        for (i = [0:bolt_count-1]) {
            angle = i * 360 / bolt_count;
            translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), 0])
                cylinder(h = flange_thickness + 2, d = bolt_hole_diameter, center = true);
        }
    }
}

// Function to create a visible flexible diaphragm
module flexible_diaphragm() {
    difference() {
        cylinder(h = diaphragm_thickness, d = diaphragm_diameter, center = true);
        cylinder(h = diaphragm_thickness + 2, d = shaft_hole_diameter, center = true);
        
        // Bolt holes
        for (i = [0:bolt_count-1]) {
            angle = i * 360 / bolt_count;
            translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), 0])
                cylinder(h = diaphragm_thickness + 2, d = bolt_hole_diameter, center = true);
        }
    }
}

// Function to create distinct bolts
module bolt() {
    union() {
        cylinder(h = bolt_length, d = bolt_diameter, center = true);
        translate([0, 0, bolt_length/2])
            cylinder(h = 2, d = bolt_diameter + 2, center = false); // Bolt head
    }
}

// Function to create distinct hexagonal nuts
module nut() {
    cylinder(h = nut_thickness, d = nut_diameter, center = true, $fn=6);
}

// Assembly
module coupling_assembly() {
    // Left Shaft
    translate([0, 0, -shaft_length/2 - flange_thickness])
        shaft();
    
    // Right Shaft
    translate([0, 0, shaft_length/2 + flange_thickness])
        shaft();
    
    // Left Flange Plate
    translate([0, 0, -flange_thickness/2])
        flange_plate();
    
    // Right Flange Plate
    translate([0, 0, flange_thickness/2])
        flange_plate();
    
    // Flexible Diaphragm
    translate([0, 0, 0])
        flexible_diaphragm();
    
    // Bolts and Nuts
    for (i = [0:bolt_count-1]) {
        angle = i * 360 / bolt_count;
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), -bolt_length/2])
            bolt();
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), bolt_length/2])
            nut();
    }
}

// Render the coupling assembly
coupling_assembly();
```

