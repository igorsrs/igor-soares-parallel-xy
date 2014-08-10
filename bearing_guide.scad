/*
 * Igor Soares' parallel kinematic XY
 * Bearing Guide
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

bearing_guide($fn=128);
module bearing_guide(
  min_wall=VERTICAL_SUPPORT_WALL,
  bearing_r=BEARING_DIAMETER/2,
  bearing_guide_h=BEARING_GUIDE_H,
  guide_angle=BEARING_GUIDE_ANGLE)
{
  rminor=bearing_r + min_wall;
  rmajor=rminor + (bearing_guide_h/2)*sin(guide_angle);

  difference() {
    union() {
      cylinder(r1=rmajor, r2=rminor, h=bearing_guide_h/2 + ST);
      translate([0,0, bearing_guide_h/2 - ST])
        cylinder(r2=rmajor, r1=rminor, h=bearing_guide_h/2 + ST);
    }
    translate([0,0,-1])
      #cylinder(r=bearing_r, h=bearing_guide_h + 2);
  }
}

