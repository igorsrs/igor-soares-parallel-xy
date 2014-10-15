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
    hsupp=-0.01,
    vsupp=VERTICAL_SUPPORT_WALL,
    screw_r=3.7/2,
    screw_nut_width=6.7,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushing_wall=LINEAR_BUSHING_WALL,
    total_len=100,
    bed_screw_r=3.7/2,
    bed_screws_room=6,
    bed_screws_separation=40,
    vertical_screws_separation=70,
    vertical_screw_r=5.7/2,
    vertical_screw_head_r=12/2,
    support_h=30)
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

      for(i=[-1,1])
        translate([
                   -bushing_r - lwall + wall/2,
                   -bushing_r - lwall,
                   bushing_l + 2*bushing_wall + bushings_separation/2 -
                     i*vertical_screws_separation/2])
         rotate([45,0,0])
           cube([wall,
                 (lwall + 2*vertical_screw_head_r)/cos(45),
                 (lwall + 2*vertical_screw_head_r)/cos(45)],
                 center=true);
      translate([-bushing_r - lwall, -bushing_r -lwall, 0])
        cube([wall,
              bushing_r + lwall,
              2*bushing_wall + 2*bushing_l + bushings_separation]);
    }
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
      num_screws=1);
    translate([0, 0, bushing_l + 2*bushing_wall - ST])
      linear_bushing_housing_negative(
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
          num_screws=1);

    translate([bushing_r,
               -(bushing_r + lwall) -1,
               bushing_l + 2*bushing_wall + bushings_separation/2 -
                   vertical_screws_separation/2])
      #cube([screw_r +1,
             2*(bushing_r + lwall) +2,
             vertical_screws_separation]);
    translate([bushing_r,
               -(bushing_r + lwall) -1,
               bushing_l + 2*bushing_wall + bushings_separation/2 -
                   vertical_screws_separation/2])
      rotate([0,45,0])
        #cube([screw_r +1,
               2*(bushing_r + lwall) +2,
               2*screw_r]);
    translate([bushing_r,
               -(bushing_r + lwall) -1,
               bushing_l + 2*bushing_wall + bushings_separation/2 +
                   vertical_screws_separation/2])
      rotate([0,45,0])
        #cube([screw_r +1,
               2*(bushing_r + lwall) +2,
               2*screw_r]);

    for(i=[-1,1])
      translate([
                 -bushing_r - lwall + wall/2,
                 -bushing_r - lwall - vertical_screw_head_r,
                 bushing_l + 2*bushing_wall + bushings_separation/2 -
                   i*vertical_screws_separation/2])
       rotate([0,90,0])
         #cylinder(r=vertical_screw_r, h=wall+1, center=true);

    translate([0,0,-ST]) mirror([0,0,1])
      #cylinder(r=bushing_r + lwall + vertical_screw_head_r + wall,
               h=bushing_l);
    translate([0,0,2*(bushing_l + 2*bushing_wall) + bushings_separation+ST])
      #cylinder(r=bushing_r + lwall + vertical_screw_head_r + wall,
               h=bushing_l);
  }
}
