/*
 * Igor Soares' parallel kinematic XY
 * Frame vertex
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

mirror([0,1,0])
frame_vertex_with_support($fn=64, wall=FRAME_VERTICE_WALL_WIDTH);

module frame_vertex_with_support(
  wall=WALL_WIDTH,
  lwall=LIGHT_WALL_WIDTH,
  vsupp=VERTICAL_SUPPORT_WALL,
  bearing_screw_r=BEARING_SCREW_DIAMETER/2,
  frame_rod_r=FRAME_ROD_DIAMETER/2,
  bearing_r=BEARING_DIAMETER/2)
{
  h = 2*wall + 4*frame_rod_r + lwall;
  w = max(2*wall + 2*frame_rod_r + lwall + 2*bearing_screw_r,
          2*bearing_r + 2*bearing_screw_r + 2*wall);

  lower_rod_h = wall + frame_rod_r;
  upper_rod_h = lower_rod_h + 2*frame_rod_r + lwall;

  bearing_screw_pos = wall + bearing_screw_r;
  rod_pos = w/2;

  discarded = wall - lwall;

    union() {
      frame_vertex(wall=wall, lwall=lwall,
                   bearing_screw_r=bearing_screw_r,
                   frame_rod_r=frame_rod_r,
                   bearing_r=bearing_r);
      difference() {
        union() {
          translate([-ST, rod_pos - frame_rod_r - wall, discarded])
            cube([w, 2*wall + 2*frame_rod_r, upper_rod_h-discarded]);
          translate([0, rod_pos, upper_rod_h]) rotate([0,90,0])
            cylinder(r=frame_rod_r - ST, h=w);

          translate([rod_pos, 0, lower_rod_h]) rotate([-90,0,0])
            cylinder(r=frame_rod_r - ST, h=w);
        }
        translate([vsupp, vsupp, -1])
          cube([w -2*vsupp, w -2*vsupp, h +2 +ST]);
      }
    }
}

module frame_vertex(
  wall=WALL_WIDTH,
  lwall=LIGHT_WALL_WIDTH,
  bearing_screw_r=BEARING_SCREW_DIAMETER/2,
  frame_rod_r=FRAME_ROD_DIAMETER/2,
  bearing_r=BEARING_DIAMETER/2)
{
  h = 2*wall + 4*frame_rod_r + lwall;
  w = max(2*wall + 2*frame_rod_r + lwall + 2*bearing_screw_r,
          2*bearing_r + 2*bearing_screw_r + 2*wall);

  bearing_screw_pos = wall + bearing_screw_r;

  rod_pos = w/2;
  lower_rod_h = wall + frame_rod_r;
  upper_rod_h = lower_rod_h + 2*frame_rod_r + lwall;

  discarded = wall - lwall;

  intersection() {
    difference() {
      union() {
        translate([bearing_screw_pos, bearing_screw_pos, 0])
          cylinder(r=bearing_screw_r+wall, h=h);

        translate([bearing_screw_pos + 2*bearing_r,
                   bearing_screw_pos + 2*bearing_r,
                   0])
          cylinder(r=bearing_screw_r+wall, h=h);

        translate([rod_pos, 0, lower_rod_h]) rotate([-90,0,0])
          cylinder(r=frame_rod_r + wall, h=w);

        translate([0, rod_pos, upper_rod_h]) rotate([0,90,0])
          cylinder(r=frame_rod_r + wall, h=w);

        //reinforcement arms
        translate([bearing_screw_pos, bearing_screw_pos, discarded -ST])
          rotate([0,0,45]) translate([0, -wall - bearing_screw_r, 0])
            cube([2*bearing_r/cos(45), 2*wall + 2*bearing_screw_r, lwall]);
        translate([bearing_screw_pos, bearing_screw_pos, h-discarded - lwall +ST])
          rotate([0,0,45]) translate([0, -wall - bearing_screw_r, 0])
            cube([2*bearing_r/cos(45), 2*wall + 2*bearing_screw_r, lwall]);
      }

      // bearing rods
      translate([bearing_screw_pos, bearing_screw_pos, -1])
        #cylinder(r=bearing_screw_r, h=h+2);

      translate([bearing_screw_pos + 2*bearing_r,
                 bearing_screw_pos + 2*bearing_r,
                 -1])
        #cylinder(r=bearing_screw_r, h=h+2);

      //frame rods
      translate([rod_pos, -1, lower_rod_h]) rotate([-90,0,0])
        #cylinder(r=frame_rod_r, h=w+2);

      translate([-1, rod_pos, upper_rod_h]) rotate([0,90,0])
        #cylinder(r=frame_rod_r, h=w+2);
    }
    translate([-1, -1, discarded])
      cube([w+2, w+2, h-2*discarded]);
  }
}

