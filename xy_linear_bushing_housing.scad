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
//use <linear_bushing_housing.scad>


/*
xy_linear_bushing_housing($fn=64,
                          lwall=2.0,
                          wall=3.0,
                          total_len=92,
                          vertical_screws_separation=80,
                          dual_bushing=true,
                          housing_screw_pos=12 + 3 + 3.7/2 - 0.7);
*/

xy_linear_bushing_housing($fn=64,
                          lwall=2.0,
                          wall=3.0,
                          total_len=47,
                          vertical_screws_separation=35,
                          dual_bushing=false,
                          housing_screw_pos=6,
                          vertical_support_pos=9,
                          vertical_support_h=6.25);


module xy_linear_bushing_housing(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    bushing_r=15.0/2 -0.1,
    bushing_l=24.4,
    bushing_wall=1.0,
    total_len=100,
    vertical_screws_separation=85,
    vertical_screw_r=4.5/2,
    vertical_screw_head_r=12/2,
    dual_bushing=true,
    housing_screw_r=3.7/2,
    housing_screw_pos=12 + WALL_WIDTH + 3.7/2 + 0.7,
    vertical_support_h=LIGHT_WALL_WIDTH + 15.0*(1/2 + cos(45)/2),
    vertical_support_pos=LIGHT_WALL_WIDTH)
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
          union()
      {
        translate([-vertical_screw_head_r, 0, 0])
          translate([0, -bushing_wall, 0])
            cube([2*vertical_screw_head_r,
                  vertical_support_pos + vertical_screw_r + bushing_wall,
                  vertical_support_h]);
        translate([0,
                   vertical_support_pos + vertical_screw_r - ST,
                   0])
          difference() {
            cylinder(r=vertical_screw_head_r, h=vertical_support_h);
            translate([-(wall + vertical_screw_r) -1,
                       -(wall + vertical_screw_r) -1,
                       -1])
              cube([2*(wall + vertical_screw_r) +2,
                     (wall + vertical_screw_r) +1,
                     vertical_support_h +2]);
          }
      }
      for(i=dual_bushing?[-1,1]:[1])
        translate([total_len/2 - i*vertical_screws_separation/2, bushing_r, 0])
          union()
      {
        translate([-wall-vertical_screw_r, 0, 0])
          translate([i*(housing_screw_pos - wall -housing_screw_r),
                     -bushing_wall, ST])
            cube([2*(wall + vertical_screw_r),
                  wall + bushing_wall,
                  2*lwall + 2*bushing_r + 2*housing_screw_r]);
        translate([-wall-vertical_screw_r,
                   -2*bushing_r - wall + bushing_wall,
                   0])
          translate([i*(housing_screw_pos - wall -housing_screw_r),
                     -bushing_wall, ST])
            cube([2*(wall + vertical_screw_r),
                  wall + bushing_wall,
                  2*lwall + 2*bushing_r + 2*housing_screw_r]);
      }
    }

    for(i=[-1,1])
      translate([total_len/2 - i*vertical_screws_separation/2, bushing_r, 0])
    {
      translate([0, vertical_support_pos + vertical_screw_r - ST, -1])
        #cylinder(r= vertical_screw_r, h=vertical_support_h+2);
    }

    for(i=dual_bushing?[-1,1]:[1])
      translate([total_len/2 - i*vertical_screws_separation/2 +
                   i*(housing_screw_pos - wall -housing_screw_r),
                 0,
                 lwall + 2*bushing_r + housing_screw_r])
        rotate([90,0,0])
          #cylinder(r=housing_screw_r, h=2*bushing_r + 2*wall +2, center=true);

    translate([-1, 0, lwall + bushing_r]) rotate([0,90,0])
      #cylinder(r=bushing_r - bushing_wall, h=total_len +2);

    for(xi=bushings_positions)
      translate([xi + wall, 0, lwall + bushing_r]) rotate([0,90,0])
        #cylinder(r=bushing_r, h=bushing_l);
  }
}

