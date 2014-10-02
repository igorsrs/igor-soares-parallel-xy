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

mirror([0,1,0])
z_car($fn=64);

module z_car(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL*2,
    vsupp=VERTICAL_SUPPORT_WALL,
    screw_r=3.7/2,
    screw_nut_width=6.7,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushing_wall=LINEAR_BUSHING_WALL,
    total_len=100,
    bed_screw_r=3.7/2,
    bed_screws_room=6,
    bed_screws_separation=40)
{
  bushings_separation = total_len - 2*bushing_l - 4*bushing_wall;
  bed_base_len = bushing_r + lwall + bed_screws_room + bed_screws_separation +
                 bed_screws_room;
  screws_pos = [
    [
      -(bushing_r + lwall + bed_screws_room),
      bushing_r + lwall + bed_screws_room,
      0
    ], [
      -bed_screws_separation - (bushing_r + lwall + bed_screws_room),
      bushing_r + lwall + bed_screws_room,
      0
    ]
  ];


  difference() {
    union() {
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
        num_screws=1);

      translate([0, 0, bushing_l + 2*bushing_wall - ST])
        linear_bushing_housing_positive(
          wall=wall,
          lwall=lwall,
          hsupp=hsupp,
          vsupp=vsupp,
          screw_r=screw_r,
          screw_nut_width=screw_nut_width,
          bushing_r=bushing_r,
          bushing_l=bushings_separation - 2*bushing_wall + 2*ST,
          bushing_wall=bushing_wall,
          num_screws=0);

      translate([0, 0, 2*(bushing_l + 2*bushing_wall) + bushings_separation])
        mirror([0,0,1])
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
            num_screws=1);

      translate([-bed_base_len, bushing_r + lwall - wall, ST])
        difference()
      {
         cube([bed_base_len, wall, bed_base_len + wall]);
         translate([0,-1,wall + ST]) rotate([0,-45,0])
          #cube([bed_base_len*sqrt(2), wall +2, bed_base_len*sqrt(2)]);
      }
      translate([-bed_base_len, bushing_r + lwall - wall, ST])
         cube([bed_base_len, wall + bed_screws_room, wall]);
      for (sp=screws_pos)
        translate(sp){
          cylinder(r=bed_screws_room - ST, h=wall);
      }
    }
    #linear_bushing_housing_negative(
      wall=wall,
      lwall=lwall,
      hsupp=hsupp,
      vsupp=vsupp,
      screw_r=screw_r,
      screw_nut_width=screw_nut_width,
      bushing_r=bushing_r,
      bushing_l=bushing_l,
      bushing_wall=bushing_wall,
      num_screws=1);
    translate([0, 0, bushing_l + 2*bushing_wall - ST])
      #linear_bushing_housing_negative(
        wall=wall,
        lwall=lwall,
        hsupp=hsupp,
        vsupp=vsupp,
        screw_r=screw_r,
        screw_nut_width=screw_nut_width,
        bushing_r=bushing_r,
        bushing_l=bushings_separation - 2*bushing_wall + 2*ST,
        bushing_wall=bushing_wall,
        num_screws=0);
      translate([0, 0, 2*(bushing_l + 2*bushing_wall) + bushings_separation])
        mirror([0,0,1])
          #linear_bushing_housing_negative(
            wall=wall,
            lwall=lwall,
            hsupp=hsupp,
            vsupp=vsupp,
            screw_r=screw_r,
            screw_nut_width=screw_nut_width,
            bushing_r=bushing_r,
            bushing_l=bushing_l,
            bushing_wall=bushing_wall,
            num_screws=1);

      for (sp=screws_pos)
        translate(sp) translate([0,0,-1]){
          #cylinder(r=bed_screw_r - ST, h=wall+2);
      }
  }
}
