/*
 * Igor Soares' parallel kinematic XY
 * Sliding blockscren tensioner
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

//tensioner($fn=64);
screw_hosing($fn=64);

module tensioner(
    strech_support_width=2*WALL_WIDTH+ 5.0 - 0.4,
    width= 13,
    screw_r=5.0/2,
    wire_grip_w=2.5,
    wire_grip_r1=(2*WALL_WIDTH + 5.0 - 0.4)/2 - 1.5,
    wire_grip_r2=(2*WALL_WIDTH + 5.0 - 0.4)/2  + 0,
    wire_upper_space=1,
    wire_lat_space=0.5)
{
  difference() {
    union() {
      cube([strech_support_width - wire_grip_w,
            strech_support_width,
            width]);

      intersection() {
        translate([strech_support_width - wire_grip_w -ST,
                   strech_support_width/2,
                   0])
          rotate([0,90,0])
            cylinder(r1=wire_grip_r1, r2=wire_grip_r2, h=wire_grip_w);
        translate([strech_support_width - wire_grip_w -ST, wire_lat_space, 0])
          cube([wire_grip_w +2*ST,
                strech_support_width - 2*wire_lat_space,
                wire_grip_r2 + 2*ST]);
      }
      intersection() {
        translate([strech_support_width - wire_grip_w -ST,
                   0,
                   wire_grip_r1 + wire_upper_space])
          rotate([0,-45,0])
            cube([strech_support_width*sqrt(2),
                  strech_support_width,
                  strech_support_width*sqrt(2)]);
        translate([strech_support_width - wire_grip_w -ST, 0, 0])
          cube([wire_grip_w +2*ST, strech_support_width, width + 2*ST]);
      }
    }
    translate([strech_support_width/2, strech_support_width/2, -1])
      #cylinder(r=screw_r, h=width +2);
  }
}

module screw_hosing(
  screw_r=5.0/2,
  screw_nut_w=8.1,
  screw_nut_h=3.5,
  screw_nut_access_hole=10.5,
  wall=4.5,
  lower_wall=2,
  grip_hole=0.8,
  h=9)
{
  nut_r = screw_nut_w/sqrt(3);
  n_g = floor( 3.1415*(screw_r + wall)/(2*grip_hole) );

  difference() {
    union() {
      cylinder(r=screw_r + wall, h=h);
    }
    translate([0,0,-1])
      #cylinder(r=screw_r, h=h+2);
    translate([0,0,lower_wall])
      #cylinder(r=nut_r, h=h, $fn=6);
    translate([0, 0, lower_wall + screw_nut_h])
      #cylinder(r=screw_nut_access_hole/2, h=h);

    for(i=[1:n_g]) rotate([0,0,(360/n_g)*i])
      translate([screw_r + wall, 0, -1])
        #cylinder(r=grip_hole, h=h+2);
  }
}
