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

sliding_block_rod_clamp($fn=64);

module wire_guide(
        wall=1,
        lwall=1,
        hsupp=-0.1,
        vsupp = 0.5,
        screw_r=1,
        screw_head_r=1,
        h=10)
{
  difference() {
    union() {
      translate([- wall, - wall, h+ wall])
        rotate([-90,0,0])
        cylinder(r=wall, h=3*wall);
      translate([-2*wall, - wall, 0])
        cube([2*wall + lwall, wall, h + wall]);
      translate([-2*wall, wall, 0])
        cube([2*wall + lwall, wall, h + wall]);

      translate([- wall - screw_head_r, 0, 0]) difference() {
        union() {
          translate([0, -screw_head_r - vsupp, 0])
            cylinder(r=screw_head_r + vsupp, h=h + 2*wall);
          translate([-screw_head_r - vsupp, -screw_head_r - vsupp, h + wall])
            cube([2*(screw_head_r + vsupp),
                  2*screw_head_r + wall + 2*vsupp,
                  wall]);
          translate([0, screw_head_r +wall + vsupp, 0])
            cylinder(r=screw_head_r + vsupp, h=h + 2*wall);
        }
        translate([-screw_head_r - vsupp - ST, -screw_head_r, -1])
          #cube([2*(screw_head_r + vsupp) - vsupp,
                 2*screw_head_r + wall,
                 h + wall +1]);
      }
    }
    translate([- wall - screw_head_r, - screw_head_r - vsupp + ST, -1])
      #cylinder(r=screw_head_r, h=h + wall +1);
    translate([- wall - screw_head_r, screw_head_r +wall + vsupp -ST, -1])
      #cylinder(r=screw_head_r, h=h + wall +1);

    translate([- wall - screw_head_r,
               - screw_head_r -vsupp + ST,
               h + wall + hsupp])
      #cylinder(r=screw_r, h=wall +1);
    translate([- wall - screw_head_r,
               screw_head_r +wall +vsupp -ST,
               h + wall + hsupp])
      #cylinder(r=screw_r, h=wall +1);
  }
}
module sliding_block_rod_clamp(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    rod_r=ROD_HOLE_DIAMETER/2,
    bearing_pos=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    bearing_r=BEARING_DIAMETER/2,
    bearing_screw_r=BEARING_SCREW_DIAMETER/2,
    bearing_screw_rod_d=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    screw_r=ROD_CLAMP_SCREW_DIAMETER/2,
    screw_head_r=12.0/2,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    wire_pos_from_bearing_center=BEARING_DIAMETER/2,
    wire_h=LIGHT_WALL_WIDTH + BEARING_WIDTH/2 + 0.5,
    wire_hole=LIGHT_WALL_WIDTH)
{
  h=rod_r + lwall;

  wire_h_pos = rod_r + (wire_h + (rod_r - bushing_r));

  bearing_pos = (rod_r + bearing_screw_rod_d + bearing_screw_r) - 2*bearing_r;

  screws_y_dist = bushing_r + screw_r + ST;
  wire_y_pos = bearing_pos + wire_pos_from_bearing_center;
  left_pos = min(bearing_pos + wire_pos_from_bearing_center,
                 -screws_y_dist - screw_r - lwall);

  screws_x_dist = 2*rod_r + 2*screw_r + ST;
  x_len = screws_x_dist + 2*screw_r + 2*lwall;

  y_len = screws_y_dist + screw_r + lwall - left_pos;

  screw_pos = [ -x_len/2 + lwall + screw_r, lwall + screw_r];

  difference() {
    union() {
      translate([-x_len/2, left_pos, 0])
        cube([x_len, y_len, h]);

      translate([-x_len/2, wire_y_pos, 0])
        wire_guide(wall=wall, lwall=lwall, h=wire_h_pos,
                   screw_r=screw_r, screw_head_r=screw_head_r);
    }
    //rod
    translate([0, left_pos -1, 0]) rotate([-90,0,0])
      #cylinder(r=rod_r, h=y_len +2);

    //screws
    for (f=[ [0,-1], [1,-1], [0,1], [1,1] ])
      translate([screw_pos[0] + f[0]*screws_x_dist,
                 f[1]*screws_y_dist,
                 -1])
        #cylinder(r=screw_r, h=h+2);

      translate([-x_len/2 -1, wire_y_pos - ST, wire_h_pos])
        rotate([0,90,0])
          #cylinder(r=wire_hole/2, h=x_len);
  }
}

module sliding_block_bushing_clamp(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    rod_r=ROD_HOLE_DIAMETER/2,
    bearing_pos=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    bearing_r=BEARING_SCREW_DIAMETER/2,
    screw_r=ROD_CLAMP_SCREW_DIAMETER/2,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushing_wall=LINEAR_BUSHING_WALL)
{
  h=wall + lwall;

  screws_x_dist = 2*rod_r + 2*screw_r + ST;
  x_len = screws_x_dist + 2*screw_r + 2*lwall;
  x_len_bushing = bushing_l + 2*lwall;
  x_len_total = max(x_len, x_len_bushing);

  screws_y_dist = 2*bushing_r + 2*screw_r + ST;
  y_len = screws_y_dist + 2*screw_r + 2*lwall;

  screw_pos = [ -x_len/2 + lwall + screw_r, lwall + screw_r];
  bushing_encl_r= bushing_r + lwall;

  difference() {
    union() {
      translate([-x_len/2, 0, 0])
        cube([x_len, y_len, h]);

      translate([-x_len/2, y_len/2 - bushing_encl_r*cos(45), 0])
        cube([x_len_total, 2*bushing_encl_r*cos(45), h]);

      intersection() {
        translate([-x_len/2, 0, 0])
          cube([bushing_l + 2*lwall, y_len, h]);
        translate([-x_len/2 -1, y_len/2, lwall + bushing_r]) rotate([0,90,0])
          cylinder(r=bushing_encl_r, h=x_len_bushing +2);
      }
    }
    //bushing
    translate([-x_len/2 -1, y_len/2, lwall + bushing_r]) rotate([0,90,0])
      #cylinder(r=bushing_r - bushing_wall, h=x_len_total +2);
    translate([-x_len/2 + lwall, y_len/2, lwall + bushing_r]) rotate([0,90,0])
      #cylinder(r=bushing_r, h=bushing_l);

    //screws
    for (f=[ [0,0], [1,0], [0,1], [1,1] ])
      translate([screw_pos[0] + f[0]*screws_x_dist,
                 screw_pos[1] + f[1]*screws_y_dist,
                 -1])
        #cylinder(r=screw_r, h=h+2);
  }
}
