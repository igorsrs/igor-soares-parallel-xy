/*
 * Igor Soares' parallel kinematic XY
 * Motor bracket
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

motor_bracket($fn=64);

module motor_bracket(
    lwall=LIGHT_WALL_WIDTH,
    wall=WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    bearing_r=BEARING_DIAMETER/2,
    bearing_screw_r=BEARING_SCREW_DIAMETER/2,
    bearing_screw_nut_width=BEARING_SCREW_NUT_WIDTH,
    bearing_width=BEARING_WIDTH,
    motor_screw_r=MOTOR_SCREW_DIAMETER/2,
    motor_size=MOTOR_SIZE,
    motor_screw_mount=MOTOR_SCREW_MOUNT,
    motor_support_screw_r=MOTOR_SUPPORT_SCREW_DIAMETER/2,
    motor_support_screws_d=MOTOR_SUPPORT_SCREWS_DISTANCE)
{
  screws_distance = 2*bearing_r/cos(45);
  w = 2*bearing_screw_r + 2*wall;
  h = wall;

  w_supp = 2*motor_support_screw_r + 2*wall;

  difference() {
    union() {
      for (a=[0,180]) rotate([0,0,a]) {
        translate([-ST, -w/2, 0])
          cube([screws_distance/2 + ST, w, h]);
      }
      translate([-motor_support_screws_d/sqrt(2) + screws_distance/2, 0, 0])
        for (a=[0,180]) rotate([0,0,a])
      {
        translate([-w_supp/2, 0, 0])
          cube([w_supp, motor_support_screws_d/sqrt(2), h]);
        translate([0, motor_support_screws_d/sqrt(2), 0])
          cylinder(r=w_supp/2, h=h);
      }
      translate([screws_distance/2, 0, 0])
        cylinder(r=w/2, h=h);

      translate([-screws_distance/2, 0, 0])
        cylinder(r=bearing_screw_nut_width/sqrt(3)+ wall,
                 h=h + bearing_width,
                 $fn=6);
    }
    translate([screws_distance/2, 0, -1])
      #cylinder(r=bearing_screw_r, h=h+bearing_width +2);
    translate([-motor_support_screws_d/sqrt(2) + screws_distance/2, 0, 0])
      for (a=[0,180]) rotate([0,0,a])
    {
      translate([0, motor_support_screws_d/sqrt(2), -1])
        #cylinder(r=motor_support_screw_r, h=h+2);
    }

    translate([-screws_distance/2, 0, -1])
      #cylinder(r=bearing_screw_nut_width/sqrt(3), h=bearing_width +1, $fn=6);

    translate([-screws_distance/2, 0, bearing_width + hsupp])
      #cylinder(r=bearing_screw_r, h=h +1);
  }
}

