// These control the smoothness of the render.
// 1.5 is recommended for modeling as a good compromise between speed and quality.
// Pick a smaller number for better quality if you are rendering for a print.
// Pick a larger number to reduce quality, but also reduce time to render changes.
$fa=1.5;
$fs=1.5;

// This creates the through piece that defines the slots in each wall.
// It builds up a slot from a narrow relief rectangle for the very top, plus the slot rectangle,
// and circles for nice rounded ends. These are extruded as a mass to be 2mm greater than the rail_width
// and offset on the Y axis to cleanly pierce each side wall.
module slot_carve_out()
{
	tslot_height=slot_height-slot_width;
	relief_rail_height=slot_offset+(slot_width/2);

	translate([(segment_length/2)-0.5, -1, rail_height-(relief_rail_height-1)])
		cube([1, rail_width+2, relief_rail_height]);
	translate([(segment_length/2)-(slot_width/2), -1, ((rail_height-slot_offset)-(tslot_height))])
		cube([slot_width, rail_width+2, tslot_height]);
	translate([segment_length/2, -1, rail_height-slot_offset])
		rotate([-90,0,0])
			cylinder(h=rail_width+2, r=slot_width/2);
	translate([segment_length/2, -1, (rail_height-(slot_offset+tslot_height))])
		rotate([-90,0,0])
			cylinder(h=rail_width+2, r=slot_width/2);
}

// Wall relief was added to the full segment_length of each segment at the base of the slot to provide a fulcrum
// for flexing the tangs at each slot to ease cable placement. Without these reliefs, the wall_thickness were too stiff.
module wall_relief()
{
	relief_v_offset = rail_height - (slot_height + slot_offset - slot_width);
	relief_bedment = wall_thickness + (wall_thickness / 2);
	translate([segment_length+1, relief_bedment, relief_v_offset])
		rotate([0,-90,0])
			cylinder(h=segment_length+2, r=wall_thickness);
	translate([segment_length+1, rail_width-relief_bedment, relief_v_offset])
		rotate([0,-90,0])
			cylinder(h=segment_length+2, r=wall_thickness);
}

// One mounting screw_hole hole at each slot. I don't think anyone will print a single segment to really mount,
// so the single screw_hole hole per segment should be fine.
module mounting_hole()
{
	translate([(segment_length/2), rail_width/2, -1])
		cylinder(h=floor_thinkness+2, r=screw_hole);
}

// A slot segment is built of up a cube, with a slightly narrower and longer cube carved out of it.
// Then the slots are carved out and mounting hole is created in the floor_thinkness, centered on the slot.
// The Base cube is the first element of the difference, and the material taken away is in the union.
module slot_segment()
{
	difference()
	{
		cube([segment_length, rail_width, rail_height]);
		union()
		{
			translate([-1,  wall_thickness,  floor_thinkness])
				cube([segment_length+2, rail_width-(wall_thickness*2), rail_height]);
			slot_carve_out();
			wall_relief();
			mounting_hole();
		}
	}
}

// We need a hat to clip on top to contain the cables.
// Neatness counts...
module cover_segment()
{
	cover_edge_height=slot_offset+slot_width;
	peg_radius=(slot_width/2)-0.2;
	// Main cover slab
	cube([segment_length, cover_width, cover_thickness]);
	// Side rail
	translate([0, 0, cover_thickness])
	{
		cube([segment_length, cover_overhang, cover_edge_height]);
		translate([segment_length/2, cover_overhang, cover_edge_height-peg_radius])
			rotate([-90,0,0])
				cylinder(h=wall_thickness, r=peg_radius);
	}
	// Side rail
	translate([0, cover_width-cover_overhang, cover_thickness])
	{
		cube([segment_length, cover_overhang, cover_edge_height]);
		translate([segment_length/2, -wall_thickness, cover_edge_height-peg_radius])
			rotate([-90,0,0])
				cylinder(h=wall_thickness, r=peg_radius);
	}
}

// Change these paramaters to create your segment
segment_length=50;
rail_width=50;
rail_height=50;
wall_thickness=2;
floor_thinkness=3;

slot_offset=5;
slot_width=5;
slot_height=rail_height-(10+slot_offset);

screw_hole=3;

cover_thickness=1;
cover_overhang=1;
cover_width=rail_width+(cover_overhang*2);

// Generate both rail and cover
// segments count from a to b ([a,i,b] below) inclusive. So the number of segments is (b-a)+1
for(segment = [0:1:4]) {
	offset = segment*((segment_length/2)+(slot_width/2));
	translate([offset, 0, 0])
		slot_segment();
	translate([offset, -(cover_width+10), 0])
		cover_segment();
}

// vim: sw=4:ts=4:noet:
