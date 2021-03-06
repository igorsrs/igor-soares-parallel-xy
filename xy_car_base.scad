/*
 * Igor Soares' parallel kinematic XY
 * XY car base
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

HOTEND_POSITION = [40, 8];
HOTEND_HOLE = 30;
HOTEND_SCREW_DISTANCE = 25;
EXTRUDER_SCREWS = 4.5;
EXTRUDER_SCEWS_NUT_WIDTH = 7.2;
EXTRUDER_SCEWS_NUT_H = 4;
X_SCREWS_POSITIONS = [0, 80];
Y_SCREWS_POSITIONS = [15, 50];
BUSHING_HOUSING_SCREW_DIAMETER = 5.4;

mirror([1,0,0])
xy_car_base($fn=64, extruder_angle=90);

module xy_car_base(
  wall=WALL_WIDTH,
  lwall=LIGHT_WALL_WIDTH,
  hsupp=HORIZONTAL_SUPPORT_WALL,
  screws_distance=HOTEND_SCREW_DISTANCE,
  extruder_screw_r=EXTRUDER_SCREWS/2,
  extruder_screw_nut_r=6.7/(2*cos(30)),
  extruder_screw_nut_h=EXTRUDER_SCEWS_NUT_H,
  x_screws=X_SCREWS_POSITIONS,
  y_screws=Y_SCREWS_POSITIONS,
  screw_r=BUSHING_HOUSING_SCREW_DIAMETER/2,
  hotend_pos=HOTEND_POSITION,
  hotend_hole_r=HOTEND_HOLE/2,
  extruder_angle=45)
{
  l = screw_r + wall;
  lh = 2*wall + 2*extruder_screw_r;
  hotend_pos_angle = atan2(hotend_pos[1], hotend_pos[0]);
  difference() {
    union() {
      //plate
      linear_extrude(height=lwall, convexity=10) {
        polygon(
          points=[
            //[-l, y_screws[0]],
            //[l, y_screws[0]],
            [x_screws[1], -l],
            [x_screws[1], l],
            [l, y_screws[1]],
            [-l, y_screws[1]],
            [-l,-l]
            //[x_screws[0], l],
            //[x_screws[0], -l],
          ],
          paths=[[0,1,2,3,4,5,6,7]],
          convexity=10
        );
      }

      //screws
      for (pos=[ [x_screws[0], 0], [x_screws[1], 0],
                 [0, y_screws[0]], [0, y_screws[1]] ])
      translate([pos[0], pos[1], 0])
        cylinder(r=l, h=wall);

      //x reinforcement to the screws
      translate([x_screws[0], -wall/2, 0])
        cube([x_screws[1] - x_screws[0], wall, wall]);
      translate([-wall/2, y_screws[0], 0])
        cube([wall, y_screws[1] - y_screws[0], wall]);

      //hotend hole
      difference() {
        translate([hotend_pos[0], hotend_pos[1], 0])
          cylinder(r=hotend_hole_r + wall, h=wall);
        translate([x_screws[1] + l, l,-1])
          rotate([0,0, 90 + atan2(x_screws[1] - l, y_screws[1] - l)])
            translate([0, wall, 0]) mirror([0,1,])
              cube([
                sqrt(y_screws[1]*y_screws[1] + x_screws[1]*x_screws[1]),
                max(x_screws[1], y_screws[1]),
                wall +2]);
      }

      //hotend hole reinforcements
      translate([x_screws[1] + l, l,0])
        rotate([0,0, 90 + atan2(x_screws[1], y_screws[1])])
          translate([0, wall/2, 0])
            cube([
                sqrt(y_screws[1]*y_screws[1] + x_screws[1]*x_screws[1]),
                wall, wall]);
      rotate([0,0,hotend_pos_angle]) translate([0, -wall/2, 0])
        cube([sqrt(hotend_pos[0]*hotend_pos[0] + hotend_pos[1]*hotend_pos[1]),
              wall,
              wall]);

      //hotend screws
      translate([hotend_pos[0], hotend_pos[1], 0])
        rotate([0,0,extruder_angle]) union()
      {
          translate([0, 0, wall/2])
          cube([lh, 2*screws_distance, wall], center=true);
          for(i=[-1,1])
            translate([0, i*screws_distance, 0])
              cylinder(r=(extruder_screw_nut_r + wall),
                       h=2*lwall + extruder_screw_nut_h);
      }
    }
    //base screws
    for (pos=[ [x_screws[0], 0], [x_screws[1], 0],
               [0, y_screws[0]], [0, y_screws[1]] ])
    translate([pos[0], pos[1], -1])
      #cylinder(r=screw_r, h=wall +2);

   //hotend hole
   translate([hotend_pos[0], hotend_pos[1], -1])
      #cylinder(r=hotend_hole_r, h=2*lwall + extruder_screw_nut_h +2);
   translate([hotend_pos[0] + ST, hotend_pos[1] + ST, -1])
     rotate([0,0,90+0*hotend_pos_angle])
       translate([0,-hotend_hole_r,0])
         #cube([x_screws[1] + y_screws[1], 2*hotend_hole_r,
                2*lwall + extruder_screw_nut_h +2]);

    //hotend screws
    translate([hotend_pos[0], hotend_pos[1], 0])
      rotate([0,0,extruder_angle]) union()
    {
        for(i=[-1,1])
          translate([0, i*screws_distance, 0]) {
            translate([0,0,-1])
              #cylinder(r=extruder_screw_r,
                        h=lwall + 1 + extruder_screw_nut_h/2);
            translate([0, 0, lwall + extruder_screw_nut_h + hsupp])
              #cylinder(r=extruder_screw_r,
                        h=2*lwall + 1 + extruder_screw_nut_h/2);
          }
    }

    //hotend screw nuts
    translate([hotend_pos[0], hotend_pos[1], 0])
      rotate([0,0,extruder_angle]) union()
    {
        for(i=[-1,1])
          translate([0, i*screws_distance, lwall]) {
            rotate([0,0,90 + 30])//hotend_pos_angle - extruder_angle])
              #cylinder(r=extruder_screw_nut_r, h=extruder_screw_nut_h, $fn=6);
            translate([0, -extruder_screw_nut_r*cos(30), 0])
              rotate([0,0,0])//hotend_pos_angle - extruder_angle])
                #cube([x_screws[1] + y_screws[1],
                       2*extruder_screw_nut_r*cos(30) + ST,
                       extruder_screw_nut_h + ST]);
      }
    }
  }
}

