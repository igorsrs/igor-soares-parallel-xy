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

//motor_bracket_lower_decker($fn=64);

//translate([14,0, 2*WALL_WIDTH +BEARING_WIDTH])
motor_bracket_upper_decker($fn=64);

module motor_bracket_upper_decker(
    lwall=LIGHT_WALL_WIDTH,
    wall=WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    bearing_screw_r=BEARING_SCREW_DIAMETER/2,
    bearing_screw_nut_width=BEARING_SCREW_NUT_WIDTH,
    motor_screw_r=MOTOR_SCREW_DIAMETER/2,
    motor_size=MOTOR_SIZE,
    motor_screw_mount=MOTOR_SCREW_MOUNT,
    motor_support_screw_r=MOTOR_SUPPORT_SCREW_DIAMETER/2,
    motor_support_screws_d=MOTOR_SUPPORT_SCREWS_DISTANCE)
{
  extra_spacing = 5;
  main_screw_streching = 2*wall*sin(15);
  screws_distance = 2*bearing_r/cos(45);

  main_w = 2*bearing_screw_r + 2*wall;
  secondary_w = 2*motor_support_screw_r + main_screw_streching + 2*wall;

  h = wall;
  motor_pos = 0  - motor_size/2
                 -bearing_screw_nut_width/2 - extra_spacing
                 -main_screw_streching/2;

  motor_central_r = motor_screw_mount/sqrt(2) - motor_screw_r - lwall;
  motor_mount_r = motor_central_r + wall;

  difference() {
    union() {
      // main screw arm
      translate([motor_pos, -main_w/2, 0])
        cube([-motor_pos + main_screw_streching/2, main_w,h]);
      translate([main_screw_streching/2, 0, 0])
        cylinder(r=main_w/2, h=h);

      //secondary screw arms
      translate([-motor_support_screws_d/sqrt(2) - secondary_w/2,
                 -motor_support_screws_d/sqrt(2),
                 0])
        cube([secondary_w, motor_support_screws_d*sqrt(2), h]);
      for (i=[-1,1])
        translate([-motor_support_screws_d/sqrt(2),
                   -i*motor_support_screws_d/sqrt(2),
                   0])
          streched_cylinder(r=main_w/2, h=h, strech=main_screw_streching);

      //motor mount
      translate([motor_pos,0, 0]) union() {
        cylinder(r=motor_mount_r, h=h);
        for (a=[45,135,225,315]) rotate([0,0,a])
          translate([motor_screw_mount/sqrt(2), 0, 0])
            cylinder(r=motor_screw_r+wall, h=h);
      }
    }
    //main screw
    translate([0, 0, -1]) {
      #streched_cylinder(r=bearing_screw_r, h=h+2, strech=main_screw_streching);
    }

    //secondary screws
    translate([-motor_support_screws_d/sqrt(2), 0, 0])
      for (a=[0,180]) rotate([0,0,a])
    {
      translate([0, motor_support_screws_d/sqrt(2), -1])
        #streched_cylinder(r=motor_support_screw_r,
                           h=h+2,
                           strech=main_screw_streching);
    }

    //motor mount
    translate([motor_pos,0, -1]) {
      #cylinder(r=motor_central_r, h=h+2);
      for (a=[45,135,225,315]) rotate([0,0,a]) {
        translate([motor_screw_mount/sqrt(2), 0, 0])
          #cylinder(r=motor_screw_r, h=h+2);
      }
    }
  }
}

module streched_cylinder(r=10, h=10, strech=0) {
  union() {
    translate([-strech/2, 0, 0])
      cylinder(r=r, h=h);
    translate([-strech/2, -r, 0])
      cube([strech, 2*r, h]);
    translate([strech/2, 0, 0])
      cylinder(r=r, h=h);
  }
}

module motor_bracket_lower_decker(
    lwall=LIGHT_WALL_WIDTH,
    wall=WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    bearing_r=BEARING_DIAMETER/2,
    bearing_screw_r=BEARING_SCREW_DIAMETER/2,
    bearing_screw_nut_width=BEARING_SCREW_NUT_WIDTH,
    bearing_width=BEARING_WIDTH,
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

