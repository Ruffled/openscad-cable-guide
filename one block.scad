$fa=1.5;
$fs=1.5;

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

module mounting_hole(offset=0, length=25, width=25, floor=3, screw_size)
{
    translate([offset+(length/2), width/2, -1])
        cylinder(h=floor+2, r=screw_size);
}

module slot_segment(offset=0, length=25, width=25, height=25, walls=2, floor=3, slot_height=15, slot_width=5)
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
