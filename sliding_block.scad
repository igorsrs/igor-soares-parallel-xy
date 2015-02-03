/*
 * Igor Soares' parallel kinematic XY
 * Sliding block
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

/*
mirror([1,0,0])
sliding_block_rod_clamp(
    wire_clamp=true,
    $fn=64,
    rod_distance=4.0,
    wire_pos_from_bearing_center=-BEARING_DIAMETER/2,
    wire_h=1.5*ROD_HOLE_DIAMETER + LIGHT_WALL_WIDTH + BEARING_WIDTH/2 + 1,
    second_wire_h=1.5*ROD_HOLE_DIAMETER + LIGHT_WALL_WIDTH +
                  3*BEARING_WIDTH/2 + 1.5
);
*/
mirror([1,0,0])
sliding_block_rod_clamp(
    wire_clamp=true,
    $fn=64,
    rod_distance=3.0,
    wire_pos_from_bearing_center=-BEARING_DIAMETER/2,
    wire_h=0.5*ROD_HOLE_DIAMETER + LIGHT_WALL_WIDTH + 3*BEARING_WIDTH/2 + 1.5,
    second_wire_h=0.5*ROD_HOLE_DIAMETER + LIGHT_WALL_WIDTH +
                  BEARING_WIDTH/2 + 1
);

/*
sliding_block_rod_clamp_internal(
    wire_clamp=true,
    $fn=64,
    rod_distance=4.0,
    wire_pos_from_bearing_center=-BEARING_DIAMETER/2,
    wire_h=1.5*ROD_HOLE_DIAMETER + LIGHT_WALL_WIDTH + BEARING_WIDTH/2 + 1,
    second_wire_h=1.5*ROD_HOLE_DIAMETER + LIGHT_WALL_WIDTH +
                  3*BEARING_WIDTH/2 + 1.5
);
*/
/*
sliding_block_rod_clamp_internal(
    wire_clamp=true,
    $fn=64,
    rod_distance=3.0,
    wire_pos_from_bearing_center=-BEARING_DIAMETER/2,
    wire_h=0.5*ROD_HOLE_DIAMETER + LIGHT_WALL_WIDTH + 3*BEARING_WIDTH/2 + 1.5,
    second_wire_h=0.5*ROD_HOLE_DIAMETER + LIGHT_WALL_WIDTH +
                  BEARING_WIDTH/2 + 1
);
*/

module sliding_block_rod_clamp_internal(
    wire_clamp=false,
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    rod_r=ROD_HOLE_DIAMETER/2,
    rod_distance=3.0,
    bearing_pos=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    bearing_r=-BEARING_DIAMETER/2,
    bearing_screw_r=BEARING_SCREW_DIAMETER/2,
    bearing_screw_rod_d=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    screw_r=3.7/2,
    screw_head_r=8/2,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushings_distance=10.0,
    wire_pos_from_bearing_center=BEARING_DIAMETER/2,
    wire_h=1.5*ROD_HOLE_DIAMETER + LIGHT_WALL_WIDTH + BEARING_WIDTH/2 + 0.5,
    second_wire_h=1.5*ROD_HOLE_DIAMETER + LIGHT_WALL_WIDTH +
                  2*BEARING_WIDTH/2 +1.5,
    wire_hole=1.5,
    strech_screw_r=5.0/2,
    strech_screw_head_r=11.4/2,
    strech_screw_length=50.0,
    strech_support_wall=2*WALL_WIDTH+ 5.0,
    bushing_wall=LINEAR_BUSHING_WALL)
{
  wire_h_pos = wire_h;

  inner_pos = (rod_r + bearing_pos + bearing_screw_r);
  wire_y_pos = -inner_pos - wire_pos_from_bearing_center;

  wire_wall_pos = wire_y_pos;

  housing_r = bushing_r + lwall;
  total_h = 2*lwall + 2*bushing_l + bushings_distance;

  difference() {
    union() {
      mirror([0,1,0])
        base_sliding_block_positive(
          wall=wall,
          lwall=lwall,
          hsupp=hsupp,
          vsupp=vsupp,
          rod_r=rod_r,
          rod_distance=rod_distance,
          screw_r=screw_r,
          bushing_r=bushing_r,
          bushing_l=bushing_l,
          bushings_distance=bushings_distance,
          bushing_wall=bushing_wall);

      rotate([0,0,180]) union() {
          //wire contact wall
          translate([wire_wall_pos,
                     wire_h_pos - wire_hole/2 - wall,
                     0])
            cube([wall, 2*wall + wire_hole, 2*wall + wire_hole]);
          translate([wire_wall_pos,
                     wire_h_pos - wire_hole/2 - wall,
                     0])
            cube([housing_r - wire_wall_pos + wall, wall, total_h]);
          for (hi=[0, total_h/2 - wall/2, total_h - wall])
            translate([housing_r, -housing_r, hi])
              cube([wall,housing_r + wire_h_pos - wire_hole/2 + ST,wall]);

          translate([wire_wall_pos + ST,
                     wire_h_pos - wire_hole/2 - wall + ST,
                     0])
            cube([wire_h_pos - wire_hole - 0.5*wall, wall, 5.5*wall]);
          translate([wire_wall_pos + 2*wall + ST,
                     wire_h_pos - wire_hole/2 + wall - vsupp + ST,
                     0])
            cube([wall, vsupp, 5*wall]);
          for (i=[0.5,2,3.5,5])
            translate([wire_wall_pos + 5*wall/2,
                       wire_h_pos - wire_hole/2,
                       i*wall]) rotate([-90,0,0])
              cylinder(r=wall/2, h=wall);
      }
    }
    mirror([0,1,0])
      base_sliding_block_negative(
        wall=wall,
        lwall=lwall,
        hsupp=hsupp,
        vsupp=vsupp,
        rod_r=rod_r,
        rod_distance=rod_distance,
        screw_r=screw_r,
        bushing_r=bushing_r,
        bushing_l=bushing_l,
        bushings_distance=bushings_distance,
        bushing_wall=bushing_wall);
    rotate([0,0,180]) union(){
      translate([wire_y_pos, wire_h_pos - wire_hole/2, wall])
        translate([-ST,0,0])
          #cube([wall + 2*ST, wire_hole, wire_hole]);

      //wires
      translate([wire_y_pos, wire_h_pos, 2*wall + wire_hole])
        #cylinder(r=wire_hole, h=total_h - 2*wall - wire_hole +1);
    }
  }
}

module sliding_block_rod_clamp(
    wire_clamp=false,
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    rod_r=ROD_HOLE_DIAMETER/2,
    rod_distance=3.0,
    bearing_pos=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    bearing_r=BEARING_DIAMETER/2,
    bearing_screw_r=BEARING_SCREW_DIAMETER/2,
    bearing_screw_rod_d=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    screw_r=3.7/2,
    screw_head_r=8/2,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushings_distance=3.0,
    wire_pos_from_bearing_center=BEARING_DIAMETER/2,
    wire_h=1.5*ROD_HOLE_DIAMETER + LIGHT_WALL_WIDTH + BEARING_WIDTH/2 + 0.5,
    second_wire_h=1.5*ROD_HOLE_DIAMETER + LIGHT_WALL_WIDTH +
                  2*BEARING_WIDTH/2 +1.5,
    wire_hole=1.5,
    strech_screw_r=4.4/2,
    strech_screw_nut_r=(6.7/(2*cos(30))),
    strech_screw_nut_h=3,
    strech_screw_head_r=11.4/2,
    strech_screw_length=50.0,
    strech_support_wall=2*5+ 4.4,
    bushing_wall=LINEAR_BUSHING_WALL)
{
  wire_h_pos = wire_h;

  inner_pos = (rod_r + bearing_pos + bearing_screw_r);
  second_pos = -(2*bearing_r) + inner_pos;
  wire_y_pos = -second_pos - wire_pos_from_bearing_center;

  lowest_wire = (second_wire_h < wire_h) ? second_wire_h : wire_h;

  wire_wall_pos = (wire_pos_from_bearing_center > 0) ?
                    wire_y_pos - wall + wire_hole:
                    wire_y_pos - wire_hole;

  screw_wall_pos = max(second_wire_h, wire_h) + wire_hole;
  screw_wall_h = strech_support_wall + wire_hole/2 + wall;
  strech_screws_pos = lwall + strech_screw_head_r;
  strech_screws_distance = 15;
  strech_screw_hole_pos = (-strech_screws_pos + vsupp)/2;

  housing_r = bushing_r + lwall;
  total_h = 2*lwall + 2*bushing_l + bushings_distance;

  bushing_supp_pos = sqrt(
      (bushing_r + lwall)*(bushing_r + lwall) -
      bushing_r*bushing_r
  );

  difference() {
    union() {
      mirror([0,1,0])
        base_sliding_block_positive(
          wall=wall,
          lwall=lwall,
          hsupp=hsupp,
          vsupp=vsupp,
          rod_r=rod_r,
          rod_distance=rod_distance,
          screw_r=screw_r,
          bushing_r=bushing_r,
          bushing_l=bushing_l,
          bushings_distance=bushings_distance,
          bushing_wall=bushing_wall);

      rotate([0,0,180])
        union() {
          //wire contact wall
          translate([wire_wall_pos - 2*lwall - 2*strech_support_wall,
                     screw_wall_pos,
                     wall])
            cube([2*lwall + 2*strech_support_wall, wall, total_h - wall - ST]);

          for(i=[0:3])
            translate([wire_wall_pos -
                        (i/3.0)*(2*lwall + 2*strech_support_wall - 2*wall) - 1.5*wall,
                       screw_wall_pos + wall/2,
                       0])
              cylinder(r=wall/2, h=wall);

          translate([wire_y_pos - wall,
                     wire_h_pos - wire_hole/2 - wall,
                     0])
            cube([wall,
                  screw_wall_pos - wire_h_pos + wall + wire_hole,
                  total_h]);

          translate([wire_wall_pos,
                     screw_wall_pos + (wall - lwall),
                     total_h]) mirror([0,0,1])
            rotate([0,0,90]) difference()
          {
            cube([strech_support_wall + lwall,
                   2*lwall + 2*strech_support_wall,
                   2*wall + wire_hole + strech_support_wall*sqrt(2)]);
            translate([strech_support_wall + lwall, -1, wall + ST])
              rotate([0,-45,0])
                cube([2*strech_support_wall + wall,
                      2*lwall + 2*strech_support_wall+ 2,
                      2*strech_support_wall + wall]);
            translate([lwall + ST, lwall, wall +ST])
              cube([2*strech_support_wall + wall,
                    2*strech_support_wall,
                    2*strech_support_wall + wall]);
            translate([lwall + strech_support_wall/2,
                       lwall + strech_support_wall/2,
                       -1])
              #cylinder(r=strech_screw_r, h=wall + 1 - hsupp);
            translate([lwall + strech_support_wall/2,
                       lwall + 3*strech_support_wall/2,
                       -1])
              #cylinder(r=strech_screw_r, h=wall + 1 - hsupp);

            //screw nuts
            //translate([lwall + strech_support_wall/2,
            //           lwall + strech_support_wall/2,
            //           wall])
            //  rotate([0,0,30])
            //    #cylinder(r=strech_screw_nut_r, h=strech_screw_nut_h +1, $fn=6);
            //translate([lwall + strech_support_wall/2,
            //           lwall + 3*strech_support_wall/2,
            //           wall])
            //  rotate([0,0,30])
            //    #cylinder(r=strech_screw_nut_r, h=strech_screw_nut_h +1, $fn=6);

            // wire path holes
            //translate([wall + ST, lwall, -1])
            //  #cube([2*wire_hole,
            //         2*strech_support_wall,
            //         wall + wire_hole +1 - ST]);
            //translate([lwall + 2*ST, lwall + strech_support_wall/2 - wire_hole, -1])
            //  #cube([2*wire_hole,
            //         2*wire_hole,
            //         2*wall + wire_hole +2]);
            //translate([lwall + 2*ST,
            //           lwall + 1.5*strech_support_wall - wire_hole + ST,
            //           -1])
            //  #cube([2*wire_hole,
            //         2*wire_hole,
            //         2*wall + wire_hole +2]);
          }


          //support
          for(hs=[2*wall + 2*wire_hole, total_h/2 + 0.5*wall + wire_hole,
                  total_h - wall])
            translate([0, -bushing_r, hs]) {
              linear_extrude(height=wall, convexity = 10, twist = 0)
                polygon(points=[ [bushing_r + wall, -rod_distance - ST],
                                 [bushing_r + wall + lwall, -rod_distance - ST],
                                 [wire_wall_pos + 2*ST,
                                  screw_wall_pos + bushing_r + ST],
                                 [bushing_r + lwall,
                                  screw_wall_pos + bushing_r + ST],
                                 //[wire_y_pos + 2*ST,
                                 //   lowest_wire + bushing_r - wire_hole - ST],
                                 [bushing_r + lwall, bushing_r] ] );
          }
        }
        //wire ends
    }

    mirror([0,1,0])
      base_sliding_block_negative(
        wall=wall,
        lwall=lwall,
        hsupp=hsupp,
        vsupp=vsupp,
        rod_r=rod_r,
        rod_distance=rod_distance,
        screw_r=screw_r,
        bushing_r=bushing_r,
        bushing_l=bushing_l,
        bushings_distance=bushings_distance,
        bushing_wall=bushing_wall);

    rotate([0,0,180]) union(){
      translate([wire_y_pos - wall, wire_h_pos - wire_hole/2, 0])
        mirror([(wire_pos_from_bearing_center >0) ? 1 : 0,0,0])
          union()
      {
          translate([-1,0,wall])
            #cube([wall + 2, wire_hole, wire_hole]);
          translate([-1,0, 2*wall + wire_hole])
            #cube([wall + 2, wire_hole, wire_hole]);
      }

      translate([wire_y_pos, screw_wall_pos -1, 0])
        mirror([(wire_pos_from_bearing_center >0) ? 1 : 0,0,0])
          union()
      {
          translate([-wall - 3*wire_hole,0,wall + lwall])
            #cube([2*wire_hole, wall + wire_hole +1, 2*wire_hole]);
          translate([-2*strech_support_wall - 2*lwall - wire_hole + wall,0,wall + lwall])
            #cube([2*wire_hole, wall + wire_hole +1, 2*wire_hole]);
      }

      translate([wire_y_pos, wire_h_pos, 3*wall + 2*wire_hole])
        #cylinder(r=wire_hole, h=total_h - 2*wall - wire_hole +1);

      translate([wire_y_pos, second_wire_h, -1])
        #cylinder(r=wire_hole, h=total_h +2);
    }
  }
}

module base_sliding_block_positive(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    rod_r=ROD_HOLE_DIAMETER/2,
    rod_distance=LIGHT_WALL_WIDTH,
    bushings_distance=3.0,
    screw_r=3.7/2,
    screw_nut_width=6.7,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushing_wall=LINEAR_BUSHING_WALL)
{
  is_double = true;
  rod_clamp_h = 0;
  h = 2*bushing_l + 2*lwall + bushings_distance;

  union() {
    //bushing
    cylinder(r=bushing_r + lwall, h=h);
    translate([0, -bushing_r - lwall, 0])
      cube([(bushing_r + screw_r),
            2*(bushing_r + lwall),
            h]);
    translate([-bushing_r - wall, -bushing_r - rod_distance, 0])
      cube([(2*bushing_r + screw_r + wall),
            (bushing_r + rod_distance),
            h]);

    //rod clamp
    translate([-bushing_r - wall,
               -bushing_r- 2*rod_r - rod_distance,
               rod_clamp_h])
      cube([2*bushing_r + screw_r + wall,
            vsupp + 2*rod_r + bushing_r + rod_distance,
            2*rod_r + 2*lwall]);

    //rod clamp screw
    translate([bushing_r - screw_r - 2*lwall,
               -bushing_r - 2*rod_r - rod_distance - screw_r,
               rod_clamp_h])
      cube([2*screw_r + 2*lwall, 2*screw_r + 2*lwall, 2*rod_r + 2*lwall]);
    translate([bushing_r - lwall,
               -bushing_r - 2*rod_r - rod_distance- screw_r,
               rod_clamp_h])
      cylinder(r=screw_r + lwall, h=2*rod_r + 2*lwall);
  }
}

module base_sliding_block_negative(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    rod_r=ROD_HOLE_DIAMETER/2,
    rod_distance=LIGHT_WALL_WIDTH,
    bushings_distance=3.0,
    screw_r=3.7/2,
    screw_head_r=7.5/2,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushing_wall=LINEAR_BUSHING_WALL)
{
  is_double = false;
  rod_clamp_h = 0;
  h = 2*bushing_l + 2*lwall + bushings_distance;

  union() {
    //rod
    translate([-bushing_r - wall + vsupp,
               -bushing_r - rod_r - rod_distance,
               rod_clamp_h + lwall + rod_r])
      rotate([0,90,0])
        cylinder(r=rod_r, h=2*bushing_r + screw_r + wall - 2*vsupp);

    translate([-bushing_r - wall - vsupp,
               -bushing_r - rod_r - rod_distance,
               rod_clamp_h + lwall + rod_r])
      rotate([0,90,0])
        cylinder(r=0.3*rod_r, h=2*bushing_r + screw_r + wall + 2*vsupp);

    //rod screw
    translate([bushing_r - lwall,
               -bushing_r - 2*rod_r - rod_distance- screw_r,
               rod_clamp_h])
      union()
    {
      translate([0, 0, is_double ? vsupp : -ST])
        cylinder(r=screw_r, h = rod_r + lwall - vsupp);
      translate([0, 0, rod_r + 2*lwall + hsupp])
        cylinder(r=screw_r, h = rod_r + lwall +1);
      translate([0, 0, rod_r -ST])
        cylinder(r=screw_r + lwall - vsupp, h=2*lwall);
      translate([0, 0, 2*rod_r + 2*lwall + ST])
        cylinder(r=screw_head_r, h = bushing_l);
    }

    //bushing
    translate([0,0,-1])
      cylinder(r=bushing_r - bushing_wall, h=h +2);
    translate([0,0,-1]) difference() {
      cylinder(r=bushing_r, h=h +2);
      translate([-bushing_r - 1, -bushing_r -1, -1])
        cube([2*bushing_r +2, bushing_wall +1, h+4]);
    }
    for(i=[0, bushing_l +  bushings_distance]) translate([0,0,i]) {
      translate([0,0,lwall])
        #cylinder(r=bushing_r, h=bushing_l);
    }

    //bushing access
    translate([0, -bushing_r + bushing_wall, 0])
      union()
    {
      translate([0,0,-1])
        cube([(bushing_r + lwall) + (2*screw_r + wall)/cos(45) +1,
               2*(bushing_r -bushing_wall),
               h +2]);
    }
  }
}

module base_sliding_block(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    rod_r=ROD_HOLE_DIAMETER/2,
    rod_distance=2.0,
    bushings_distance=50,
    screw_r=3.7/2,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushing_wall=LINEAR_BUSHING_WALL)
{
  difference() {
    base_sliding_block_positive(
        wall=wall,
        lwall=lwall,
        hsupp=hsupp,
        vsupp=vsupp,
        rod_r=rod_r,
        rod_distance=rod_distance,
        bushings_distance=bushings_distance,
        screw_r=screw_r,
        bushing_r=bushing_r,
        bushing_l=bushing_l,
        bushing_wall=bushing_wall);

    base_sliding_block_negative(
        wall=wall,
        lwall=lwall,
        hsupp=hsupp,
        vsupp=vsupp,
        rod_r=rod_r,
        rod_distance=rod_distance,
        bushings_distance=bushings_distance,
        screw_r=screw_r,
        bushing_r=bushing_r,
        bushing_l=bushing_l,
        bushing_wall=bushing_wall);
  }
}
