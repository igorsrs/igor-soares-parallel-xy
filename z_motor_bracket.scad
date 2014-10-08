/*
 * Igor Soares' parallel kinematic XY
 * Z motor bracket
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
use <linear_bushing_housing.scad>

z_motor_bracket($fn=64);

module z_motor_bracket(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL*2,
    vsupp=VERTICAL_SUPPORT_WALL,
    screw_mount=MOTOR_SCREW_MOUNT,
    screw_r=MOTOR_SCREW_DIAMETER/2,
    screw_clearance=MOTOR_SCREW_DIAMETER,
    clamp_screw=5.7/2,
    clamp_width=18,
    clamp_size=2*WALL_WIDTH,
    h_distance=70,
    l_distance=30)
{
  clamp_total_r = clamp_width/2 + wall;
  clamp_h = screw_mount + 2*screw_clearance + 2*wall;

  mount_h_center = screw_mount/2 + screw_clearance + wall;

  angle = 90 +atan2(h_distance, clamp_total_r +l_distance +
                                screw_mount/2 + screw_clearance);
  difference() {
    union() {
      cylinder(r=clamp_total_r, h=clamp_h);
      translate([0, -clamp_total_r, 0])
        cube([clamp_total_r + clamp_size, 2*clamp_total_r, clamp_h]);

      //h distance
      translate([-h_distance, clamp_total_r - wall, 0])
        cube([h_distance, wall, clamp_h]);
      translate([-h_distance, -clamp_total_r, 0])
        cube([h_distance, 2*clamp_total_r - ST, wall]);
      //translate([-h_distance, -clamp_total_r, clamp_h - wall])
      //  cube([h_distance, 2*clamp_total_r - ST, wall]);
      //translate([-h_distance, -clamp_total_r, 0])
      //  cube([vsupp, 2*clamp_total_r - ST, clamp_h]);

      //motor_mount
      translate([-h_distance, clamp_total_r - ST, 0])
        cube([wall, l_distance + screw_mount/2 + screw_clearance,
              screw_mount + 2*screw_clearance + 2*wall]);
      difference() {
        translate([wall,0,0]) rotate([0,0,angle]) union() {
          cube([h_distance/abs(cos(angle)), wall, wall]);
          translate([0,0,clamp_h-wall])
            cube([h_distance/abs(cos(angle)), wall, wall]);
        }
      }

    }
    translate([0,0,-1])
      #cylinder(r=clamp_width/2 - lwall, h=clamp_h +2);
    translate([clamp_screw + lwall, -clamp_width/2, -1])
      #cube([clamp_width + clamp_size, clamp_width, clamp_h+2]);
    translate([0, -(clamp_width - 2*lwall)/2, -1])
      #cube([clamp_width + clamp_size, clamp_width-2*lwall, clamp_h+2]);

    translate([0, -clamp_total_r -1, clamp_h/2]) rotate([-90,0,0])
      #cylinder(r=clamp_screw, h=2*clamp_total_r +2);

    translate([-h_distance - 1, clamp_total_r + l_distance, mount_h_center])
      rotate([0,90,0]) union()
    {
      #cylinder(r=screw_mount/2, h=wall+2);
      for(i=[-1,1]) for(j=[-1,1]) translate([i*screw_mount/2, j*screw_mount/2, 0])
        #cylinder(r=screw_r, h=wall+2);
    }
  }
}
