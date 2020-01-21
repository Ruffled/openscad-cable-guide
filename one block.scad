$fa=1.5;
$fs=1.5;

module slot_segment(offset=0, length=25, width=25, height=25, walls=2, floor=3, slot_height=15, slot_width=5)
{
	tslot_height=slot_height-slot_width;
	difference()
	{
	    difference()
	    {
			translate([offset,0,0]) cube([length,width,height]);
			translate([offset-1,walls,floor]) cube([length+2,width-(walls*2),height]);
	    };
	    union()
	    {
			relief_height=5+(slot_width/2);
			translate([offset+(length/2)-0.5,-1,height-(relief_height-1)]) cube([1,width+2,relief_height]);
			translate([offset+(length/2)-(slot_width/2),-1,((height-5)-(tslot_height))]) cube([slot_width,width+2,tslot_height]);
			translate([offset+length/2, -1, height-5]) rotate([-90,0,0]) cylinder(h=width+2, r=slot_width/2);
			translate([offset+length/2, -1, (height-(5+tslot_height))]) rotate([-90,0,0]) cylinder(h=width+2, r=slot_width/2);
	    }
	}
}

length=50;
width=50;
height=50;
walls=2;
floor=3;
slot_height=30;
slot_width=5;
for(i = [0:1:10]) {
	offset = i*((length/2)+(slot_width/2));
	slot_segment(offset, length, width, height, walls, floor, slot_height, slot_width);
}
