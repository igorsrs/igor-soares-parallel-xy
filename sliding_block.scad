/*
 * Igor Soares' parallel kinematic XY
 * Sliding block
 * (C) 2014 by Ígor Bruno Pereira Soares
 *
 * This project is free: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This project is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this project.  If not, see <http://www.gnu.org/licenses/>.
 */

include <configuration.scad>

if(false)
rotate([180,0,0])
sliding_block_bushing_clamp(
    wire_clamp=false,
    $fn=64);
if(false)
rotate([180,0,0])
sliding_block_bushing_clamp(
    wire_clamp=true,
    $fn=64,
    wire_pos_from_bearing_center=-BEARING_DIAMETER/2,
    wire_h=LIGHT_WALL_WIDTH + 3*BEARING_WIDTH/2 + 1
);
if(false)
rotate([180,0,0])
sliding_block_bushing_clamp(
    wire_clamp=true,
    $fn=64,
    wire_pos_from_bearing_center=BEARING_DIAMETER/2,
    wire_h=LIGHT_WALL_WIDTH + 3*BEARING_WIDTH/2 + 1
);

if(false)
rotate([180,0,0])
sliding_block_rod_clamp(
    wire_clamp=false,
    $fn=64);
if(false)
rotate([180,0,0])
sliding_block_rod_clamp(
    wire_clamp=true,
    $fn=64,
    wire_pos_from_bearing_center=BEARING_DIAMETER/2,
    wire_h=LIGHT_WALL_WIDTH + BEARING_WIDTH/2 + 1
);
//if(false)
rotate([180,0,0])
sliding_block_rod_clamp(
    wire_clamp=true,
    $fn=64,
    wire_pos_from_bearing_center=-BEARING_DIAMETER/2,
    wire_h=LIGHT_WALL_WIDTH + BEARING_WIDTH/2 + 1
);

if(false)
wire_spool($fn=64, wall=(WALL_WIDTH + LIGHT_WALL_WIDTH)/2);

module wire_guide(
        wall=1,
        lwall=1,
        vsupp = 0.5,
        hsupp=0.4,
        screw_r=1,
        sc_head_r=20,
        x_pos=1,
        y_len=30,
        nut_width=8.0,
        nut_h=2.5,
        wire_hole=1.5,
        h=10)
{
  l = -x_pos + wall;

  difference() {
    union() {
      translate([0,y_len - lwall, 0])
        cube([l, 2*sc_head_r + 2*lwall, h + wire_hole + wall]);
      translate([l, y_len + sc_head_r, 0])
        cylinder(r=sc_head_r, h=h + wire_hole + wall);
    }
    translate([l, y_len + sc_head_r, nut_h -1])
      #cylinder(r=screw_r, h=h+ wire_hole + wall + 1);
    translate([l, y_len + sc_head_r, -1])
      #cylinder(r=nut_width/sqrt(3), h=nut_h+1, $fn=6);
    translate([-1, y_len - ST, -1]) mirror([0,1,0])
      #cube([2*l +2, lwall, wire_hole + h + 1]);
    translate([-1, y_len  + 2*sc_head_r + ST, -1])
      #cube([2*l +2, lwall, wire_hole + h + 1]);
  }
}
module sliding_block_rod_clamp(
    wire_clamp=false,
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    rod_r=ROD_HOLE_DIAMETER/2,
    bearing_pos=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    bearing_r=BEARING_DIAMETER/2,
    bearing_screw_r=BEARING_SCREW_DIAMETER/2,
    bearing_screw_rod_d=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    screw_r=ROD_CLAMP_SCREW_DIAMETER/2,
    screw_head_r=11.4/2,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    wire_pos_from_bearing_center=BEARING_DIAMETER/2,
    wire_h=LIGHT_WALL_WIDTH + BEARING_WIDTH/2 + 0.5,
    wire_hole=1.5)
{
  h=rod_r + lwall;

  wire_h_pos = rod_r + (wire_h + (rod_r - bushing_r));

  bearing_pos = (rod_r + bearing_screw_rod_d + bearing_screw_r) - 2*bearing_r;

  screws_y_dist = bushing_r + screw_r + ST;
  wire_y_pos = (wire_pos_from_bearing_center > 0) ?
                 bearing_pos + wire_pos_from_bearing_center :
                 bearing_pos + wire_pos_from_bearing_center - 2*screw_head_r - 2*lwall;
  left_pos = min(wire_y_pos,
                 -screws_y_dist - screw_r - lwall);

  screws_x_dist = 2*rod_r + 2*screw_r + ST;
  x_len = screws_x_dist + 2*screw_r + 2*lwall;

  y_len = screws_y_dist + screw_r + lwall - left_pos;

  screw_pos = [ -x_len/2 + lwall + screw_r, lwall + screw_r];

 union() {
  difference() {
    union() {
      translate([-x_len/2, left_pos, 0])
        cube([x_len, y_len, h]);

      if(wire_clamp)
      for(i=[0,1]) mirror([i,0,0])
        translate([-screw_pos[0], 0 ,0 ])
          wire_guide(wall=wall, lwall=lwall, h=wire_h_pos,
                     x_pos=-screw_head_r,
                     vsupp=vsupp,
                     hsupp=hsupp,
                     y_len=wire_y_pos,
                     wire_hole=wire_hole,
                     screw_r=screw_r, sc_head_r=screw_head_r + lwall);
    }
    //rod
    translate([0, left_pos -1, 0]) rotate([-90,0,0])
      #cylinder(r=rod_r, h=y_len +2);

    //screws
    for (f=[ [0,-1], [1,-1], [0,1], [1,1] ])
      translate([screw_pos[0] + f[0]*screws_x_dist,
                 f[1]*screws_y_dist,
                 -1])
      {
        if (wire_clamp) union() {
        #cylinder(r=screw_r, h=h+1 - hsupp);
        translate([0,0,rod_r + lwall +1 + ST])
          #cylinder(r=screw_head_r, h=2*wall +1);
        } else {
          #cylinder(r=screw_r, h=h+2);
        }
      }
  }
  if (wire_clamp) union() {
    for (i=[0:4]) translate([-x_len/2 + i*(x_len-vsupp)/4, left_pos, rod_r + lwall - ST])
      cube([vsupp, y_len, wire_h_pos + wire_hole + wall - rod_r - lwall + ST]);
    translate([-x_len/2, left_pos + y_len - vsupp, rod_r + ST])
      cube([x_len, vsupp, wire_h_pos + wire_hole + wall - rod_r - ST]);
  }
 }
}

module sliding_block_bushing_clamp(
    wire_clamp=false,
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    rod_r=ROD_HOLE_DIAMETER/2,
    bearing_pos=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    bearing_r=BEARING_DIAMETER/2,
    bearing_screw_r=BEARING_SCREW_DIAMETER/2,
    bearing_screw_rod_d=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    screw_r=ROD_CLAMP_SCREW_DIAMETER/2,
    screw_head_r=11.4/2,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    wire_pos_from_bearing_center=BEARING_DIAMETER/2,
    wire_h=LIGHT_WALL_WIDTH + BEARING_WIDTH/2 + 0.5,
    wire_hole=1.5,
    strech_screw_r=5.0/2,
    strech_screw_head_r=5.7,
    strech_screw_nut_access_room=9.5,
    strech_screw_nut_access_h=5,
    strech_screw_nut_width=8.0,
    strech_screw_nut_h=3.0,
    bushing_wall=LINEAR_BUSHING_WALL)
{
  h=wall + lwall;

  strech_pos_h = h - lwall + strech_screw_nut_access_h;
  screws_x_dist = 2*rod_r + 2*screw_r + ST;
  x_len = screws_x_dist + 2*screw_r + 2*lwall;
  x_len_bushing = bushing_l + 2*lwall;
  x_len_total = max(x_len, x_len_bushing);

  left_pos = min(bearing_pos + wire_pos_from_bearing_center,
                 -screws_y_dist - screw_r - lwall);

  screws_y_dist = 2*bushing_r + 2*screw_r + ST;

  //y_len = screws_y_dist + screw_r + lwall - left_pos;
  y_len = screws_y_dist + 2*screw_r + 2*lwall;

  screw_pos = [ -x_len/2 + lwall + screw_r, lwall + screw_r];
  bushing_encl_r= bushing_r + lwall;

  wire_h_pos = rod_r + (wire_h + (rod_r - bushing_r));
  wire_y_pos = bearing_pos + wire_pos_from_bearing_center;

  x_len_total2 = max(x_len_total, 6*screw_head_r + 2*wall);
union() {
  difference() {
    union() {
      translate([-x_len/2, 0, 0])
        cube([x_len, y_len, h]);

      if(wire_clamp)
      translate([-wall/2, 0, 0])
        cube([wall, y_len, wire_h_pos + wire_hole + wall]);

      translate([-x_len/2, y_len/2 - bushing_encl_r*cos(45), 0])
        cube([x_len_total, 2*bushing_encl_r*cos(45), h]);

      if(wire_clamp)
      for(i=[0,1]) mirror([i,0,0])
        translate([-screw_pos[0], 0 , strech_pos_h])
          wire_guide(wall=wall, lwall=lwall,
                     h=wire_h_pos - strech_pos_h,
                     x_pos=-screw_head_r,
                     vsupp=vsupp,
                     hsupp=hsupp,
                     y_len=wire_y_pos,
                     wire_hole=wire_hole,
                     sc_head_r=strech_screw_head_r,
                     screw_r=screw_r, screw_head_r=screw_head_r);

      if(wire_clamp)
      translate([screw_pos[0] - screw_head_r - wall,
                 wire_y_pos,
                 0])
        cube([2*(-screw_pos[0] + screw_head_r + wall),
              2*screw_head_r,
              wire_h_pos]);

      intersection() {
        translate([-x_len/2, 0, 0])
          cube([bushing_l + 2*lwall, y_len, h]);
        translate([-x_len/2 -1, y_len/2, h - (lwall + bushing_r)])
          rotate([0,90,0])
            cylinder(r=bushing_encl_r, h=x_len_bushing +2);
      }
    }
    //bushing
    translate([-x_len_total2/2 -1, y_len/2, h -(lwall + bushing_r)]) rotate([0,90,0])
      #cylinder(r=bushing_r - bushing_wall, h=x_len_total2 +2);
    translate([-x_len/2 + lwall, y_len/2, h - (lwall + bushing_r)])
      rotate([0,90,0])
        #cylinder(r=bushing_r, h=bushing_l);

    //screws
    for (f=[ [0,0], [1,0], [0,1], [1,1] ])
      translate([screw_pos[0] + f[0]*screws_x_dist,
                 screw_pos[1] + f[1]*screws_y_dist,
                 0])
        union()
    {
      if(wire_clamp) {
        translate([0,0,-1])
          #cylinder(r=screw_r, h=h+1 - 2*hsupp);
        translate([0,0,h+ST])
          #cylinder(r=screw_head_r, h=wire_h_pos + wall);
      } else {
        translate([0,0,-1])
          #cylinder(r=screw_r, h=h+2);
      }
    }

    // access to strecher screw nuts
    if(wire_clamp)
    for(i=[0,1]) mirror([i,0,0])
    translate([-screw_pos[0] + screw_head_r + wall,
               wire_y_pos + screw_head_r,
               -1])
      union()
    {
      #cylinder(r=strech_screw_nut_access_room/2, h=strech_pos_h + 1 + ST);
      #cylinder(r=strech_screw_nut_width/(2*cos(30)),
                h=strech_pos_h + 1 + strech_screw_nut_h,
                $fn=6);
      #cylinder(r=strech_screw_r,
                h=wire_h_pos + wire_hole + wall + 2);
    }
  }

  if(wire_clamp)
  translate([-x_len/2, 0, (h - lwall)])
    cube([vsupp, y_len, wire_h_pos + wire_hole + wall - (h - lwall)]);
  if(wire_clamp)
  translate([x_len/2 - vsupp, 0, (h - lwall)])
    cube([vsupp, y_len, wire_h_pos + wire_hole + wall - (h - lwall)]);
}
}

module wire_spool(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    rod_r=ROD_HOLE_DIAMETER/2,
    screw_r=5.0/2,
    screw_head_r=5.7)
{
  l = lwall+ rod_r + screw_r + screw_head_r + wall;
  union() {
    difference() {
      union() {
        translate([-l, -wall, wall/2]) rotate([0,90,0]) {
          cylinder(r=wall/2, h=2*l);
          translate([-wall/2, 0, 0])
            cube([wall, wall, 2*l]);
          translate([0, wall, 0])
            cylinder(r=wall/2, h=2*l);
        }
        for (i=[-1,1]) translate([i*l, 0, 0]) {
            cylinder(r=screw_r + wall, h=wall);
            mirror([0,1,0]) translate([-screw_r - wall, 0, 0])
              cube([2*(screw_r+ wall), wall + screw_r, wall]);
        }
        translate([-wall , -wall/2, ST])
          cylinder(r1=wall/2, r2=1.5*wall/2, h=wall+ lwall);
      }
      for (i=[-1,1]) translate([i*l, 0, -1]) {
          #cylinder(r=screw_r, h=wall +2);
          mirror([0,1,0]) translate([-screw_r, 0, 0])
            #cube([2*screw_r, wall + screw_r +1, wall+2]);
      }
    }
  }
}
