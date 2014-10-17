/*
 * Igor Soares' parallel kinematic XY
 * Linear bushing housing
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

xy_linear_bushing_housing($fn=64);

module xy_linear_bushing_housing(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    extra_gap=1,
    hsupp=-0.01,
    vsupp=VERTICAL_SUPPORT_WALL,
    screw_r=3.7/2,
    screw_nut_width=6.7,
    bushing_r=10.4/2,
    bushing_l=8.3,
    bushing_wall=0.5,
    total_len=125,
    bed_screw_r=3.7/2,
    bed_screws_room=6,
    bed_screws_separation=40,
    vertical_screws_separation=85,
    vertical_screw_r=5.2/2,
    vertical_screw_head_r=13/2,
    support_h=30)
{

  difference() {
    union() {
      translate([0, - lwall - bushing_r, 0])
        cube([total_len, 2*(lwall + bushing_r), bushing_r + wall - lwall]);
      for(i=[-1,1])
        translate([total_len/2 - i*vertical_screws_separation/2, 0, 0])
          difference()
      {
        union() {
          translate([-wall-vertical_screw_r, 0, 0])
            cube([2*(wall + vertical_screw_r), bushing_r + lwall + vertical_screw_head_r, wall]);
          translate([0, bushing_r + lwall + vertical_screw_head_r - ST, 0])
            cylinder(r=wall + vertical_screw_r, h=wall);
        }
        translate([0, bushing_r + lwall + vertical_screw_head_r - ST, -1])
          #cylinder(r= vertical_screw_r, h=wall+2);
      }
    }
    translate([-1, 0, wall + bushing_r]) rotate([0,90,0])
      #cylinder(r=bushing_r - bushing_wall, h=total_len +2);
    translate([lwall, 0, wall + bushing_r]) rotate([0,90,0])
      #cylinder(r=bushing_r, h=bushing_l);
    translate([lwall, -lwall - bushing_r -1, -1])
      #cube([bushing_l, 2*(lwall + bushing_r) +2, lwall + extra_gap + 1]);
    translate([total_len - lwall, 0, wall + bushing_r]) rotate([0,-90,0])
      #cylinder(r=bushing_r, h=bushing_l);
    translate([total_len - bushing_l -lwall, -lwall - bushing_r -1, -1])
      #cube([bushing_l, 2*(lwall + bushing_r) +2, lwall + extra_gap + 1]);
  }
}

