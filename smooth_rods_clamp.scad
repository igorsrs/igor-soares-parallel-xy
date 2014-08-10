/*
 * Igor Soares' parallel kinematic XY
 * Smooth rods clamp
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

//mirror([1,0,0])
smooth_rods_clamp($fn=64);

module smooth_rods_clamp(
    lwall=LIGHT_WALL_WIDTH,
    wall=WALL_WIDTH,
    bearing_r=BEARING_DIAMETER/2,
    bearing_screw_r=BEARING_SCREW_DIAMETER/2,
    bearing_screw_rod_d=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    bearing_r=BEARING_DIAMETER/2,
    rod_r=ROD_ACTUAL_DIAMETER/2,
    rod_hole_r=ROD_HOLE_DIAMETER/2)
{
  inner_pos = (rod_hole_r + bearing_screw_rod_d + bearing_screw_r)/cos(45);
  second_pos = -(2*bearing_r)/cos(45) + inner_pos;
  central_hole_start = rod_hole_r/cos(45) + ST;

  w = 2*wall + 2*bearing_screw_r;
  h = 2*lwall + 2*rod_r + 2*rod_hole_r;

  translate([0,0,w/2])  difference() {
    union() {
      translate([-h/2,0,-w/2])
        cube([h, inner_pos + ST, w]);
      translate([-h/2,second_pos,-w/2])
        cube([h, -second_pos + ST, w]);

      translate([0, inner_pos, 0])
        rotate([0,90,0])
          cylinder(r=w/2, h=h, center=true);
      translate([0, second_pos, 0])
        rotate([0,90,0])
          cylinder(r=w/2, h=h, center=true);
    }
    //inner bearing screw
    translate([0, inner_pos, 0])
      rotate([0,90,0])
        #cylinder(r=bearing_screw_r, h=h+1, center=true);

    //outer bearing screw
    translate([0, second_pos, 0])
      rotate([0,90,0])
        #cylinder(r=bearing_screw_r, h=h+1, center=true);

    //smooth rod holes
    for (i=[-1, 1]) {
      translate([i*rod_r, 0, 0])
        rotate([i*45,0,0])
          #cylinder(r=rod_hole_r, h=(w + 2*rod_hole_r +1)/cos(45), center=true);
      translate([i*ST, 0, 0])
        rotate([i*45,0,0])
          #cube([2*rod_hole_r, 2*rod_hole_r, (w + 2*rod_hole_r +1)/cos(45)],
                center=true);
    }

    //centerl hole
    translate([-rod_hole_r,second_pos - w/2 -1,-w/2 -1])
      #cube([2*rod_hole_r,
             -second_pos + w/2 + central_hole_start +1 +ST,
             w +2]);

  }
}

