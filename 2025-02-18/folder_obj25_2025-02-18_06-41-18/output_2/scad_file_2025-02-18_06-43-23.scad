
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
chamfer_size = 2; // Added chamfering for smoother edges

// Clamping Hub Module
module clamping_hub() {
    difference() {
        // Main cylindrical hub with chamfered edges
        hull() {
            cylinder(h = hub_length - chamfer_size, d = hub_diameter, center = true);
            translate([0, 0, hub_length / 2 - chamfer_size])
                cylinder(h = chamfer_size, d1 = hub_diameter, d2 = hub_diameter - 4, center = false);
            translate([0, 0, -hub_length / 2])
                cylinder(h = chamfer_size, d1 = hub_diameter - 4, d2 = hub_diameter, center = false);
        }
        
        // Central bore
        cylinder(h = hub_length + 2, d = bore_diameter, center = true);
        
        // Rounded clamping slots
        for (i = [-1, 1]) {
            translate([i * hub_diameter / 4, 0, 0])
                rotate([0, 90, 0])
                hull() {
                    translate([0, 0, -clamping_slot_depth / 2])
                        cylinder(h = clamping_slot_depth, d = clamping_slot_width, center = true);
                    translate([0, 0, clamping_slot_depth / 2])
                        cylinder(h = clamping_slot_depth, d = clamping_slot_width, center = true);
                }
        }
        
        // Fastener holes with proper alignment
        for (i = [-1, 1]) {
            translate([i * hub_diameter / 4, 0, 0])
                rotate([0, 90, 0])
                cylinder(h = hub_diameter + 2, d = fastener_diameter, center = true);
        }
    }
}

// Flexible Element Module
module flexible_element() {
    difference() {
        // Main cylindrical body with smoother shape
        cylinder(h = flexible_element_length, d = flexible_element_diameter, center = true);
        
        // Rounded slotted cuts for flexibility
        for (i = [0:slot_count-1]) {
            rotate([0, 0, i * (360 / slot_count)])
                translate([flexible_element_diameter / 4, 0, 0])
                hull() {
                    translate([0, 0, -flexible_element_length / 2])
                        cylinder(h = flexible_element_length, d = slot_width, center = true);
                    translate([0, 0, flexible_element_length / 2])
                        cylinder(h = flexible_element_length, d = slot_width, center = true);
                }
        }
    }
}

// Fastener Module with Hex Head
module fastener() {
    union() {
        // Main fastener body
        cylinder(h = fastener_length, d = fastener_diameter, center = true);
        
        // Hexagonal head
        translate([0, 0, fastener_length / 2])
            cylinder(h = 2, d1 = fastener_diameter * 1.5, d2 = fastener_diameter, $fn = 6, center = false);
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
    for (i = [-1, 1]) {
        translate([i * hub_diameter / 4, 0, -flexible_element_length / 2 - hub_length / 2])
            rotate([0, 90, 0])
            fastener();
    }
    
    // Fasteners for Clamping Hub 2
    for (i = [-1, 1]) {
        translate([i * hub_diameter / 4, 0, flexible_element_length / 2 + hub_length / 2])
            rotate([0, 90, 0])
            fastener();
    }
}

// Render the complete assembly
flexible_coupling();

