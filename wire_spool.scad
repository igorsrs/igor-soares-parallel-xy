ST = 0.01;

wire_spool($fn=64);

module wire_spool(
  screw_r=3.7/2,
  width=2*4 + 3.7,
  base_h=3,
  wire_slit_h=2,
  wire_slit_r=3.7/2 + 2.5,
  wire_grip_r=3/2,
  wire_grip_h=5,
  total_h=12)
{
  dr = width/2 - wire_slit_r;
  difference() {
    union() {
      cylinder(r=wire_slit_r, h=total_h);
      translate([0,0,base_h/2])
        cube([width, width, base_h], center=true);
      translate([0,0,base_h])
        cylinder(r1=width/2, r2=wire_slit_r, h=dr);
      translate([0,0,base_h + dr +wire_slit_h])
        cylinder(r2=width/2, r1=wire_slit_r, h=dr);
      translate([0,0,base_h + 2*dr +wire_slit_h])
        cylinder(r=width/2, h=total_h - (base_h + 2*dr +wire_slit_h) - ST);
      translate([wire_slit_r,
                 0,
                 base_h + dr + wire_slit_h + 2/sqrt(2)*wire_grip_r])
        rotate([0,45,0])
          cylinder(r=wire_grip_r, h=wire_grip_h);
    }
    translate([0,0,-1])
      #cylinder(r=screw_r, h=total_h +2);
  }
}

