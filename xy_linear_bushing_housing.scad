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


xy_linear_bushing_housing($fn=64,
                          lwall=3.0,
                          total_len=95,
                          vertical_screws_separation=80,
                          dual_bushing=true,
                          lwall=3.0);
/*
xy_linear_bushing_housing($fn=64,
                          lwall=3.0,
                          total_len=50,
                          vertical_screws_separation=35,
                          dual_bushing=false,
                          lwall=3.0);
*/

module xy_linear_bushing_housing(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    bushing_r=15.0/2 -0.1,
    bushing_l=24.4,
    bushing_wall=1.0,
    total_len=100,
    bed_screw_r=3.7/2,
    bed_screws_room=6,
    bed_screws_separation=40,
    vertical_screws_separation=85,
    vertical_screw_r=5.2/2,
    vertical_screw_head_r=13/2,
    dual_bushing=true,
    support_h=30)
{

  bushings_positions = dual_bushing ? 
                           [0, total_len - 2*wall - bushing_l] :
                           [total_len/2 - wall - bushing_l/2];
  difference() {
    union() {
      translate([0, - wall - bushing_r, 0])
        cube([total_len, 2*(wall + bushing_r), lwall + ST]);
      for(xi=bushings_positions)
        for(yi=[0, wall + 2*bushing_r - bushing_wall])
          translate([xi, yi - wall - bushing_r, 0])
            cube([bushing_l + 2*wall,
                  wall + bushing_wall,
                  lwall + (1+cos(45))*bushing_r]);
      for(i=[-1,1])
        translate([total_len/2 - i*vertical_screws_separation/2, bushing_r, 0])
          difference()
      {
        union() {
          translate([-wall-vertical_screw_r, 0, 0])
            cube([2*(wall + vertical_screw_r),
                  wall+ vertical_screw_head_r,
                  wall]);
          translate([0, wall + vertical_screw_head_r - ST, 0])
            cylinder(r=wall + vertical_screw_r, h=wall);
        }
        translate([0, wall + vertical_screw_head_r - ST, -1])
          #cylinder(r= vertical_screw_r, h=wall+2);
      }
    }

    translate([-1, 0, lwall + bushing_r]) rotate([0,90,0])
      #cylinder(r=bushing_r - bushing_wall, h=total_len +2);
    for(xi=bushings_positions)
      translate([xi + wall, 0, lwall + bushing_r]) rotate([0,90,0])
        #cylinder(r=bushing_r, h=bushing_l);
  }
}

