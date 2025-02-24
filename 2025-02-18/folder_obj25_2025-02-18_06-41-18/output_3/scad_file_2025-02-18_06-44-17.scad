
// Parameters
hub_diameter = 20;
hub_length = 15;
bore_diameter = 8;
slot_width = 2;
slot_depth = 8;
fastener_diameter = 3;
fastener_length = 10;
flexible_element_length = 20;
flexible_element_diameter = 18;
slot_count = 6;
clamping_slot_depth = 5;
clamping_slot_width = 3;
chamfer_size = 2;

// Clamping Hub Module with distinct slots
module clamping_hub() {
    difference() {
        // Main cylindrical hub
        cylinder(h = hub_length, d = hub_diameter, center = true);
        
        // Central bore
        cylinder(h = hub_length + 2, d = bore_diameter, center = true);
        
        // Clamping slots
        for (i = [0:1]) {
            rotate([0, 0, i * 180])
                translate([hub_diameter / 4, 0, 0])
                rotate([0, 90, 0])
                cube([clamping_slot_depth, clamping_slot_width, hub_length], center = true);
        }
        
        // Fastener holes
        for (i = [0:1]) {
            rotate([0, 0, i * 180])
                translate([hub_diameter / 4, 0, 0])
                rotate([0, 90, 0])
                cylinder(h = hub_diameter + 2, d = fastener_diameter, center = true);
        }
    }
}

// Flexible Element Module with slotted cuts
module flexible_element() {
    difference() {
        // Main cylindrical body
        cylinder(h = flexible_element_length, d = flexible_element_diameter, center = true);
        
        // Slotted cuts for flexibility
        for (i = [0:slot_count-1]) {
            rotate([0, 0, i * (360 / slot_count)])
                translate([flexible_element_diameter / 4, 0, 0])
                rotate([0, 90, 0])
                cube([slot_depth, slot_width, flexible_element_length], center = true);
        }
    }
}

// Fastener Module with proper size and positioning
module fastener() {
    union() {
        // Main fastener body
        cylinder(h = fastener_length, d = fastener_diameter, center = true);
        
        // Hexagonal head
        translate([0, 0, fastener_length / 2])
            cylinder(h = 2, d1 = fastener_diameter * 1.2, d2 = fastener_diameter, $fn = 6, center = false);
    }
}

// Assembly
module flexible_coupling() {
    // Clamping Hub 1
    translate([0, 0, -flexible_element_length / 2 - hub_length / 2])
        clamping_hub();
    
    // Clamping Hub 2
    translate([0, 0, flexible_element_length / 2 + hub_length / 2])
        clamping_hub();
    
    // Flexible Element
    flexible_element();
    
    // Fasteners for Clamping Hub 1
    for (i = [0:1]) {
        rotate([0, 0, i * 180])
            translate([hub_diameter / 4, 0, -flexible_element_length / 2 - hub_length / 2])
            rotate([0, 90, 0])
            fastener();
    }
    
    // Fasteners for Clamping Hub 2
    for (i = [0:1]) {
        rotate([0, 0, i * 180])
            translate([hub_diameter / 4, 0, flexible_element_length / 2 + hub_length / 2])
            rotate([0, 90, 0])
            fastener();
    }
}

// Render the complete assembly
flexible_coupling();

