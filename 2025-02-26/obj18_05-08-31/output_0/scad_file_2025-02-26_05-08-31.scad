
// Module for central shaft
module central_shaft() {
    difference() {
        union() {
            cylinder(h=40, d=15, center=true);
            translate([0, 0, 0])
                cylinder(h=20, d=20, center=true);
        }
    }
}

// Module for input/output hub
module hub() {
    difference() {
        cylinder(h=15, d=25, center=true);
        cylinder(h=20, d=10, center=true);
    }
}

// Module for spacer ring
module spacer_ring() {
    difference() {
        cylinder(h=2, d=30, center=true);
        cylinder(h=3, d=20, center=true);
    }
}

// Module for flange plate
module flange_plate() {
    difference() {
        cylinder(h=5, d=35, center=true);
        cylinder(h=6, d=15, center=true);
        for (i = [0:3]) {
            rotate([0, 0, i * 90])
                translate([12, 0, 0])
                    cylinder(h=6, d=5, center=true);
        }
    }
}

// Module for bolt
module bolt() {
    union() {
        cylinder(h=20, d=3, center=true);
        translate([0, 0, 10])
            cylinder(h=3, d=6, center=true);
    }
}

// Module for nut
module nut() {
    difference() {
        cylinder(h=3, d=6, center=true);
        cylinder(h=4, d=3, center=true);
    }
}

// Assembly
module flexible_coupling() {
    central_shaft();
    
    translate([0, 0, 20])
        hub();
    translate([0, 0, -20])
        hub();
    
    translate([0, 0, 10])
        spacer_ring();
    translate([0, 0, -10])
        spacer_ring();
    
    translate([0, 0, 15])
        flange_plate();
    translate([0, 0, -15])
        flange_plate();
    translate([0, 0, 5])
        flange_plate();
    translate([0, 0, -5])
        flange_plate();
    
    for (i = [0:3]) {
        rotate([0, 0, i * 90])
            translate([12, 0, 15])
                bolt();
        rotate([0, 0, i * 90])
            translate([12, 0, -15])
                bolt();
    }
    
    for (i = [0:3]) {
        rotate([0, 0, i * 90])
            translate([12, 0, 25])
                nut();
        rotate([0, 0, i * 90])
            translate([12, 0, -25])
                nut();
    }
}

// Render the model
flexible_coupling();

