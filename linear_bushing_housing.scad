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

linear_bushing_housing($fn=64);

module linear_bushing_housing_positive(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    screw_r=3.7/2,
    screw_nut_width=6.7,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushing_wall=LINEAR_BUSHING_WALL,
    num_screws=1)
{
  union() {
    //bushing
    cylinder(r=bushing_r + lwall, h=bushing_l + 2*bushing_wall);
    translate([0, -bushing_r - lwall, 0])
      cube([(bushing_r + screw_r),
            2*(bushing_r + lwall),
            bushing_l + 2*bushing_wall]);
    //bushing screws
    if(num_screws >= 1)
      translate([(bushing_r + screw_r),
                 0,
                 (lwall+screw_r)/cos(45)])
        rotate([0,45,0])
          cube([2*(screw_r + lwall), 2*(bushing_r + lwall), 2*(screw_r + lwall)],
               center=true);
    if(num_screws >= 2)
      translate([(bushing_r + screw_r),
                 0,
                 bushing_l + 2*bushing_wall - (lwall+screw_r)/cos(45)])
        rotate([0,45,0])
          cube([2*(screw_r + lwall), 2*(bushing_r + lwall), 2*(screw_r + lwall)],
               center=true);
  }
}

module linear_bushing_housing_negative(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    screw_r=3.7/2,
    screw_nut_width=6.7,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushing_wall=LINEAR_BUSHING_WALL,
    num_screws=1)
{
  union() {
    //bushing
    translate([0,0,-ST])
      cylinder(r=bushing_r - bushing_wall, h=bushing_l + bushing_wall);
    translate([0,0,bushing_l + bushing_wall + hsupp])
      cylinder(r=bushing_r - bushing_wall, h=bushing_wall + ST);
    translate([0,0,bushing_wall])
      cylinder(r=bushing_r, h=bushing_l);

    //bushing access
    translate([0, -bushing_r + bushing_wall, 0])
      union()
    {
      translate([0,0,-ST])
        cube([(bushing_r + lwall) + (2*screw_r + wall)/cos(45) +1,
               2*(bushing_r -bushing_wall),
               bushing_l + bushing_wall]);
      translate([0, 0, bushing_l + bushing_wall + hsupp])
        cube([(bushing_r + lwall) + (2*screw_r + wall)/cos(45) +1,
               2*(bushing_r -bushing_wall),
               bushing_wall +ST]);
    }
    //bushing screws
    if(num_screws >= 1)
      translate([(bushing_r + screw_r),
                 0,
                 (lwall+screw_r)/cos(45)])
        rotate([90,0,0])
          cylinder(r=screw_r, h=2*bushing_r + 2*lwall +2, center=true);

    if(num_screws >= 2)
      translate([(bushing_r + screw_r),
                 0,
                 bushing_l + 2*bushing_wall - (lwall+screw_r)/cos(45)])
        rotate([90,0,0])
          cylinder(r=screw_r, h=2*bushing_r + 2*lwall +2, center=true);
  }
}

module linear_bushing_housing(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    screw_r=3.7/2,
    screw_nut_width=6.7,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushing_wall=LINEAR_BUSHING_WALL,
    num_screws=1)
{
  difference() {
    linear_bushing_housing_positive(
      wall=wall,
      lwall=lwall,
      hsupp=hsupp,
      vsupp=vsupp,
      screw_r=screw_r,
      screw_nut_width=screw_nut_width,
      bushing_r=bushing_r,
      bushing_l=bushing_l,
      bushing_wall=bushing_wall,
      num_screws=num_screws);
    linear_bushing_housing_negative(
      wall=wall,
      lwall=lwall,
      hsupp=hsupp,
      vsupp=vsupp,
      screw_r=screw_r,
      screw_nut_width=screw_nut_width,
      bushing_r=bushing_r,
      bushing_l=bushing_l,
      bushing_wall=bushing_wall,
      num_screws=num_screws);
  }
}
