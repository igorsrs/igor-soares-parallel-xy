/*
 * Reprap Darwin Remix
 * Line Spool
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

include <screws/polyScrewThread.scad>
include <configuration.scad>

PI=3.141592;

THREAD_PITCH = 2;
THREAD_ANGLE = 45;
INNER_DIAMETER = 40./PI;
DEFAILT_SPOOL_H=16;
INNER_SHAFT_DIAMETER = 5.3;

$fn=64;
line_spool();

module line_spool(
        lwall=LIGHT_WALL_WIDTH,
        wall=LIGHT_WALL_WIDTH + 0.01,
        hsupp=HORIZONTAL_SUPPORT_WALL,
        vsupp=VERTICAL_SUPPORT_WALL,
        thread_inner_diameter=INNER_DIAMETER,
        thread_pitch=THREAD_PITCH,
        thread_angle=THREAD_ANGLE,
        spool_h=DEFAILT_SPOOL_H,
        inner_shaft_diameter=INNER_SHAFT_DIAMETER,
        screw_r=3.2/2,
        screw_head_r=5./2,
        screw_nut_width=5.3,
        screw_nut_h=1.5,
        wire_hole=1.1)
{
  outer_diameter = thread_inner_diameter + (thread_pitch/2)*cos(thread_angle);
  clamp_h = 2*screw_head_r + 2*lwall;

  precision = ceil(PI*outer_diameter/ (($fn) ? $fn : 16));

  union() {
    difference() {
      union() {
        rotate([0,0,90])
        screw_thread(outer_diameter,
                     thread_pitch,
                     thread_angle,
                     spool_h,
                     precision,   // Resolution, one face each "PI/2" mm of the perimeter, 
                     0);  // Countersink style:

        translate([0,0,spool_h + 2*hsupp])
          cylinder(r=inner_shaft_diameter/2 + lwall, h=clamp_h - 2*hsupp);

        //vertical support
        translate([0,0,spool_h -ST]) difference() {
          cylinder(r=inner_shaft_diameter/2 + lwall, h=2*hsupp + 2*ST);
          translate([0,0,-1])
            cylinder(r=inner_shaft_diameter/2 + lwall - vsupp,
                     h=2*hsupp +1);
        }

        translate([0,0,spool_h -ST]) difference() {
          cylinder(r=inner_shaft_diameter/2 + lwall + vsupp+ wall, h=clamp_h);
          translate([0,0,-1])
            cylinder(r=inner_shaft_diameter/2 + lwall + vsupp,
                     h=clamp_h +2);
          translate([-(inner_shaft_diameter/2 + 2*lwall + wall) -1,
                     -(inner_shaft_diameter/2 + 2*lwall + wall) -1,
                     -1])
            cube([2*(inner_shaft_diameter/2 + 2*lwall + wall) +1,
                   (inner_shaft_diameter/2 + 2*lwall + wall) +1,
                   clamp_h +2]);
        }
        translate([-wall/2,0,spool_h -ST])
          cube([wall, inner_shaft_diameter/2 + 2*lwall, clamp_h]); 

        translate([lwall/2,
                   -inner_shaft_diameter/2 - lwall - screw_head_r,
                   spool_h])
          cube([inner_shaft_diameter/2 + lwall/2,
                inner_shaft_diameter/2 + lwall + screw_head_r,
                clamp_h]);

        translate([-inner_shaft_diameter/2 - lwall,
                   -inner_shaft_diameter/2 - lwall - screw_head_r,
                   spool_h])
          cube([inner_shaft_diameter/2 + lwall/2,
                inner_shaft_diameter/2 + lwall + screw_head_r,
                clamp_h]);

        translate([-inner_shaft_diameter/2 - lwall,
                   -inner_shaft_diameter/2 - screw_r - lwall,
                   spool_h + clamp_h/2])
          rotate([0, 90, 0])
            cylinder(r=screw_head_r + lwall - hsupp,
                     h=inner_shaft_diameter/2 + lwall/2);
        translate([lwall/2,
                   -inner_shaft_diameter/2 - screw_r - lwall,
                   spool_h + clamp_h/2])
          rotate([0, 90, 0])
            cylinder(r=screw_head_r + lwall - hsupp,
                     h=inner_shaft_diameter/2 + lwall/2);
      }
      translate([0,0,-1])
        #cylinder(r=inner_shaft_diameter/2, h=spool_h +clamp_h+2);

      //wire hole
      translate([-wire_hole/2, 0, -1])
        #cube([wire_hole, inner_shaft_diameter/2 + wire_hole, spool_h/2 +1]);
      translate([-wire_hole/2, 0, spool_h/2 - wire_hole + 1])
        #cube([wire_hole, outer_diameter/2 +1, wire_hole]);

      translate([-lwall/2, -inner_shaft_diameter/2 -lwall -1, spool_h + 3*hsupp])
        #cube([lwall, inner_shaft_diameter/2 + lwall +1, clamp_h]);

      translate([lwall/2 + vsupp,
                 -inner_shaft_diameter/2 - lwall - screw_head_r -1,
                 spool_h])
        #cube([inner_shaft_diameter/2 + lwall/2 - 2*vsupp,
               inner_shaft_diameter/2 + lwall + screw_head_r + 1 + ST,
               2*hsupp]);
      translate([-inner_shaft_diameter/2 - lwall + vsupp,
                 -inner_shaft_diameter/2 - lwall - screw_head_r - 1,
                 spool_h])
        #cube([inner_shaft_diameter/2 + lwall/2 - 2*vsupp,
               inner_shaft_diameter/2 + lwall + screw_head_r + 1 + ST,
               2*hsupp]);
      //screw
      translate([-inner_shaft_diameter/2 - lwall - 1,
                 -inner_shaft_diameter/2 - screw_r - lwall,
                 spool_h + clamp_h/2])
        rotate([0, 90, 0])
          #cylinder(r=screw_r, h=inner_shaft_diameter + 2*lwall +2);
      translate([-inner_shaft_diameter/2 - lwall - 1,
                 -inner_shaft_diameter/2 - screw_r - lwall,
                 spool_h + clamp_h/2])
        rotate([0, 90, 0]) rotate([0,0,30])
          #cylinder(r=screw_nut_width/(2*cos(30)),
                    h=screw_nut_h +1,
                    $fn=6);
    }
    translate([0,0,spool_h + 2*hsupp +ST])
      cylinder(r=inner_shaft_diameter/2 + lwall, h=hsupp);
  }
}

