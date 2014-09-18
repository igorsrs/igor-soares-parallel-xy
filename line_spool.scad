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
INNER_DIAMETER = 80./PI;
DEFAILT_SPOOL_H=16;
INNER_SHAFT_DIAMETER = 5.5;

$fn=64;
line_spool();

module line_spool(
        lwall=LIGHT_WALL_WIDTH,
        wall=WALL_WIDTH,
        hsupp=HORIZONTAL_SUPPORT_WALL,
        vsupp=VERTICAL_SUPPORT_WALL,
        thread_inner_diameter=INNER_DIAMETER,
        thread_pitch=THREAD_PITCH,
        thread_angle=THREAD_ANGLE,
        spool_h=DEFAILT_SPOOL_H,
        inner_shaft_diameter=INNER_SHAFT_DIAMETER,
        screw_r=3.7/2,
        screw_head_r=8/2,
        screw_nut_width=7.0,
        screw_nut_h=2)
{
  outer_diameter = thread_inner_diameter + (thread_pitch/2)*cos(thread_angle);
  clamp_h = 2*screw_head_r + 2*lwall;

  precision = ceil(PI*outer_diameter/ (($fn) ? $fn : 16));

  union() {
    difference() {
      union() {
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
          cylinder(r=inner_shaft_diameter/2 + 2*lwall + wall, h=clamp_h);
          translate([0,0,-1])
            cylinder(r=inner_shaft_diameter/2 + 2*lwall,
                     h=clamp_h +2);
          translate([-(inner_shaft_diameter/2 + 2*lwall + wall) -1,
                     -(inner_shaft_diameter/2 + 2*lwall + wall) -1,
                     -1])
            cube([2*(inner_shaft_diameter/2 + 2*lwall + wall) +1,
                   (inner_shaft_diameter/2 + 2*lwall + wall) +1,
                   clamp_h +2]);
        }
        translate([-wall/2,0,spool_h -ST])
          cube([wall, thread_inner_diameter/2 - lwall, clamp_h]); 

        translate([lwall/2, -inner_shaft_diameter/2 - lwall - screw_head_r, spool_h])
          cube([lwall, inner_shaft_diameter/2 + lwall + screw_head_r, clamp_h]);

        translate([-1.5*lwall - screw_nut_h, -inner_shaft_diameter/2 - lwall - screw_head_r, spool_h])
          cube([lwall + screw_nut_h, inner_shaft_diameter/2 + lwall + screw_head_r, clamp_h]);
      }
      translate([0,0,-1])
        #cylinder(r=inner_shaft_diameter/2, h=spool_h +clamp_h+2);
      translate([-lwall/2, -inner_shaft_diameter/2 -lwall -1, spool_h + 3*hsupp])
        #cube([lwall, inner_shaft_diameter/2 + lwall +1, clamp_h]);
    }
    translate([0,0,spool_h + 2*hsupp +ST])
      cylinder(r=inner_shaft_diameter/2 + lwall, h=hsupp);
  }
}

