
// Parameters
shaft_diameter = 10;
central_craft_diameter = 30;
central_craft_length = 40; // Shortened to match the original model
flange_diameter = 40;
flange_thickness = 8; // Increased thickness for accuracy
spacer_thickness = 3; // Adjusted for better definition
bolt_hole_diameter = 5;
bolt_diameter = 4;
bolt_length = 25; // Increased length for better visibility
num_bolts = 6;
bolt_circle_radius = 15;
nut_diameter = 6;
nut_thickness = 3;

// Function to create a flange plate with correct bolt holes
module flange_plate() {
    difference() {
        cylinder(d=flange_diameter, h=flange_thickness, center=true);
        cylinder(d=shaft_diameter, h=flange_thickness + 1, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), 0])
                cylinder(d=bolt_hole_diameter, h=flange_thickness + 1, center=true);
        }
    }
}

// Function to create a spacer ring
module spacer_ring() {
    difference() {
        cylinder(d=flange_diameter, h=spacer_thickness, center=true);
        cylinder(d=shaft_diameter, h=spacer_thickness + 1, center=true);
    }
}

// Function to create a bolt with a nut
module bolt_with_nut() {
    union() {
        cylinder(d=bolt_diameter, h=bolt_length, center=true);
        translate([0, 0, bolt_length / 2])
            cylinder(d=nut_diameter, h=nut_thickness, center=true, $fn=6);
    }
}

// Function to create the central craft with mounting points
module central_craft() {
    difference() {
        cylinder(d=central_craft_diameter, h=central_craft_length, center=true);
        cylinder(d=shaft_diameter, h=central_craft_length + 1, center=true);
    }
}

// Function to create the input and output crafts with correct bolt holes
module input_output_craft() {
    difference() {
        union() {
            cylinder(d=central_craft_diameter, h=flange_thickness, center=true);
            translate([0, 0, -flange_thickness / 2])
                cylinder(d=central_craft_diameter, h=flange_thickness, center=true);
        }
        cylinder(d=shaft_diameter, h=flange_thickness * 2 + 1, center=true);
        for (i = [0:num_bolts-1]) {
            angle = i * 360 / num_bolts;
            translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), 0])
                cylinder(d=bolt_hole_diameter, h=flange_thickness + 1, center=true);
        }
    }
}

// Assembly
module flexible_coupling() {
    central_craft();
    
    translate([0, 0, central_craft_length / 2 + flange_thickness / 2])
        input_output_craft();
    
    translate([0, 0, -central_craft_length / 2 - flange_thickness / 2])
        input_output_craft();
    
    translate([0, 0, central_craft_length / 2 + flange_thickness + spacer_thickness / 2])
        spacer_ring();
    
    translate([0, 0, -central_craft_length / 2 - flange_thickness - spacer_thickness / 2])
        spacer_ring();
    
    translate([0, 0, central_craft_length / 2 + flange_thickness + spacer_thickness + flange_thickness / 2])
        flange_plate();
    
    translate([0, 0, -central_craft_length / 2 - flange_thickness - spacer_thickness - flange_thickness / 2])
        flange_plate();
    
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), central_craft_length / 2 + flange_thickness + spacer_thickness])
            rotate([90, 0, angle])
                bolt_with_nut();
        
        translate([bolt_circle_radius * cos(angle), bolt_circle_radius * sin(angle), -central_craft_length / 2 - flange_thickness - spacer_thickness])
            rotate([90, 0, angle])
                bolt_with_nut();
    }
}

// Render the model
flexible_coupling();

