// These control the smoothness of the render.
// 1.5 is recommended for modeling as a good compromise between speed and quality.
// Pick a smaller number for better quality if you are rendering for a print.
// Pick a larger number to reduce quality, but also reduce time to render changes.
$fa=1.5;
$fs=1.5;

// This creates the through piece that defines the slots in each wall.
// It builds up a slot from a narrow relief rectangle for the very top, plus the slot rectangle,
// and circles for nice rounded ends. These are extruded as a mass to be 2mm greater than the width
// and offset on the Y axis to cleanly pierce each side wall.
module slot_carve_out(offset=0, length=25, width=25, height=25, walls=2, floor=3, slot_height=15, slot_width=5)
{
	tslot_height=slot_height-slot_width;
	relief_height=5+(slot_width/2);

	translate([offset+(length/2)-0.5,-1,height-(relief_height-1)])
		cube([1,width+2,relief_height]);
	translate([offset+(length/2)-(slot_width/2),-1,((height-5)-(tslot_height))])
		cube([slot_width,width+2,tslot_height]);
	translate([offset+length/2, -1, height-5])
		rotate([-90,0,0])
			cylinder(h=width+2, r=slot_width/2);
	translate([offset+length/2, -1, (height-(5+tslot_height))])
		rotate([-90,0,0])
			cylinder(h=width+2, r=slot_width/2);
}

// Wall relief was added to the full length of each segment at the base of the slot to provide a fulcrum
// for flexing the tangs at each slot to ease cable placement. Without these reliefs, the walls were too stiff.
module wall_relief(offset=0, length=25, width=25, height=25, walls=2, floor=3, slot_height=15, slot_width=5)
{
	union()
	{
		translate([offset+length+1, walls+(walls/2), height-slot_height])
			rotate([0,-90,0])
				cylinder(h=length+2, r=walls);
		translate([offset+length+1, width-(walls+walls/2), height-slot_height])
			rotate([0,-90,0])
				cylinder(h=length+2, r=walls);
	}
}

// One mounting screw hole at each slot. I don't think anyone will print a single segment to really mount,
// so the single screw hole per segment should be fine.
module mounting_hole(offset=0, length=25, width=25, floor=3, screw_size)
{
	translate([offset+(length/2), width/2, -1])
		cylinder(h=floor+2, r=screw_size);
}

// A slot segment is built of up a cube, with a slightly narrower and longer cube carved out of it.
// Then the slots are carved out and mounting hole is created in the floor, centered on the slot.
// The Base cube is the first element of the difference, and the material taken away is in the union.
module slot_segment(offset=0, length=25, width=25, height=25, walls=2, floor=3, slot_height=15, slot_width=5, screw=3)
{
	difference()
	{
		translate([offset,0,0])
			cube([length,width,height]);
		union()
		{
			translate([offset-1,walls,floor])
				cube([length+2,width-(walls*2),height]);
			slot_carve_out(offset, length, width, height, walls, floor, slot_height, slot_width);
			wall_relief(offset, length, width, height, walls, floor, slot_height, slot_width);
			mounting_hole(offset, length, width, height, walls, floor, 3);
		}
	}
}

// Change these paramaters to create your segment
length=50;
width=50;
height=50;
walls=2;
floor=3;
slot_height=30;
slot_width=5;
screw=3;

// segments count from a to b ([a,i,b] below) inclusive. So the number of segments is (b-a)+1
for(i = [0:1:4]) {
	offset = i*((length/2)+(slot_width/2));
	slot_segment(offset, length, width, height, walls, floor, slot_height, slot_width, screw);
}
