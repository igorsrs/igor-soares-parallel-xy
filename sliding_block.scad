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

sliding_block_bushing_clamp(
    wire_clamp=true,
    $fn=64,
    wire_pos_from_bearing_center=BEARING_DIAMETER/2,
    wire_h=LIGHT_WALL_WIDTH + 3*BEARING_WIDTH/2 + 2
);

//mirror([0,1,0])
//sliding_block_bushing_clamp(
//    wire_clamp=true,
//    $fn=64,
//    wire_pos_from_bearing_center=-BEARING_DIAMETER/2,
//    wire_h=LIGHT_WALL_WIDTH + 3*BEARING_WIDTH/2 + 2
//);

//sliding_block_rod_clamp(
//    wire_clamp=true,
//    $fn=64,
//    wire_pos_from_bearing_center=BEARING_DIAMETER/2,
//    wire_h=LIGHT_WALL_WIDTH + BEARING_WIDTH/2 + 1
//);

//sliding_block_rod_clamp(
//    wire_clamp=true,
//    $fn=64,
//    wire_pos_from_bearing_center=-BEARING_DIAMETER/2,
//    wire_h=LIGHT_WALL_WIDTH + BEARING_WIDTH/2 + 1
//);

//translate([0,-5,0])
//wire_spool($fn=64, wall=(WALL_WIDTH + LIGHT_WALL_WIDTH)/2);

module wire_guide(
        wall=1,
        lwall=1,
        vsupp = 0.5,
        hsupp=0.4,
        screw_r=1,
        sc_head_r=20,
        x_pos=1,
        y_len=30,
        nut_width=8.0,
        nut_h=2.5,
        wire_hole=1.5,
        h=10)
{
  l = -x_pos + wall;

  difference() {
    union() {
      translate([0,y_len - lwall, 0])
        cube([l, 2*sc_head_r + 2*lwall, h + wire_hole + wall]);
      translate([l, y_len + sc_head_r, 0])
        cylinder(r=sc_head_r, h=h + wire_hole + wall);
    }
    translate([l, y_len + sc_head_r, nut_h -1])
      #cylinder(r=screw_r, h=h+ wire_hole + wall + 1);
    translate([l, y_len + sc_head_r, -1])
      #cylinder(r=nut_width/sqrt(3), h=nut_h+1, $fn=6);
    translate([-1, y_len - ST, -1]) mirror([0,1,0])
      #cube([2*l +2, lwall, wire_hole + h + 1]);
    translate([-1, y_len  + 2*sc_head_r + ST, -1])
      #cube([2*l +2, lwall, wire_hole + h + 1]);
  }
}

module screw_wall(
         wall=5,
         lwall=2,
         vsupp=-0.1,
         screw_r=2,
         screw_head_r=4,
         screw_nut_width=7,
         screw_nut_h = 3.5,
         screws_separation  = 10,
         total_len = 20)
{
  w = 2*screw_head_r + 2*wall;

  screws_block_l = screws_separation + screw_nut_width/cos(30);

  difference() {
    union() {
      cube([w, wall + screw_nut_h, total_len]);
    }
    translate([w/2, -1, total_len/2]) rotate([-90,0,0])
      #cylinder(r=screw_head_r, h=screw_nut_h + wall + 2);

    translate([w/2, vsupp, total_len/2])
      rotate([-90,0,0])
        union()
    {
      for(i=[-1,1]) translate([0, i*screws_separation/2, 0]) union() {
        //rotate([0,0,30])
        //  #cylinder(r=screw_nut_width/(2*cos(30)), h=screw_nut_h -vsupp, $fn=6);
        translate([0,0,screw_nut_h])
          #cylinder(r=screw_r, h=wall - 2*vsupp);
      }
      translate([-screw_r, -screws_separation/2, screw_nut_h])
        #cube([2*screw_r, screws_separation, wall -2*vsupp]);
      translate([-screw_nut_width/2,
                 -screws_block_l/2,
                 0])
        #cube([screw_nut_width, screws_block_l, screw_nut_h -vsupp]);
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
    bearing_pos=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    bearing_r=BEARING_DIAMETER/2,
    bearing_screw_r=BEARING_SCREW_DIAMETER/2,
    bearing_screw_rod_d=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    screw_r=3.7/2,
    screw_head_r=8/2,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    wire_pos_from_bearing_center=BEARING_DIAMETER/2,
    wire_h=LIGHT_WALL_WIDTH + BEARING_WIDTH/2 + 0.5,
    wire_hole=1.5,
    strech_screw_r=ROD_CLAMP_SCREW_DIAMETER/2,
    strech_screw_head_r=11.4/2,
    strech_screw_nut_access_room=9.5,
    strech_screw_nut_access_h=5,
    strech_screw_nut_width=8.0,
    strech_screw_nut_h=3.0,
    bushing_wall=LINEAR_BUSHING_WALL)
{
  wire_h_pos = 3*rod_r + wire_h;

  inner_pos = (rod_r + bearing_pos + bearing_screw_r);
  second_pos = -(2*bearing_r) + inner_pos;
  wire_y_pos = -second_pos - wire_pos_from_bearing_center;

  wire_wall_pos = (wire_pos_from_bearing_center > 0) ?
                    wire_y_pos - wall:
                    wire_y_pos;

  screw_wall_pos = (wire_pos_from_bearing_center > 0 ) ?
                      wire_wall_pos - 2*strech_screw_head_r - wall - ST :
                      wire_wall_pos;
  screw_wall_h = (wire_pos_from_bearing_center > 0 ) ?
                   wire_h_pos + 2*wall :
                   wire_h_pos;
  strech_screws_pos = lwall + strech_screw_head_r;
  strech_screws_distance = 15;
  strech_screw_hole_pos = (-strech_screws_pos + vsupp)/2;

  difference() {
    union() {
      base_sliding_block_positive(
          wall=wall,
          lwall=lwall,
          hsupp=hsupp,
          vsupp=vsupp,
          rod_r=rod_r,
          screw_r=screw_r,
          bushing_r=bushing_r,
          bushing_l=bushing_l,
          bushing_wall=bushing_wall);

      rotate([0,0,180]) difference() {
        union() {
          //wire representation
          translate([wire_y_pos, wire_h_pos, -1])
            %cylinder(r=1, h=bushing_l + 2*bushing_wall + 2);

          //wire contact wall
          translate([wire_wall_pos, 0, 0])
            cube([wall, screw_wall_h + wall + ST, bushing_l + 2*bushing_wall]);
          translate([wire_y_pos - lwall, wire_h_pos, 0])
            cube([2*lwall, wall, bushing_l + 2*bushing_wall]);
          translate([0, -2*lwall, 0])
            cube([wire_y_pos + wall, bushing_r + lwall, bushing_l + 2*bushing_wall]);
          if (wire_pos_from_bearing_center < 0)
            translate([0, bushing_r - lwall- ST, 2*lwall + 2*rod_r - ST])
              cube([wire_y_pos + wall, lwall + 2*rod_r + vsupp, lwall]);

          //strech screws wall
          translate([screw_wall_pos, screw_wall_h, 0]) {
            screw_wall(
              wall=wall,
              lwall=lwall,
              vsupp=-0.1,
              screw_r=strech_screw_r,
              screw_head_r=strech_screw_head_r,
              screw_nut_width=strech_screw_nut_width,
              screw_nut_h = strech_screw_nut_h,
              screws_separation  = strech_screws_distance,
              total_len=strech_screws_distance + 2*strech_screw_head_r + lwall
            );
          }
        }

        translate([wire_wall_pos + vsupp, bushing_r - lwall, -1])
          #cube([wall -2*vsupp, 2*lwall + 2*rod_r, 2*rod_r + lwall +1 - ST]);

      }
    }

    base_sliding_block_negative(
        wall=wall,
        lwall=lwall,
        hsupp=hsupp,
        vsupp=vsupp,
        rod_r=rod_r,
        screw_r=screw_r,
        bushing_r=bushing_r,
        bushing_l=bushing_l,
        bushing_wall=bushing_wall);
  }

}

module sliding_block_bushing_clamp(
    wire_clamp=false,
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    rod_r=ROD_HOLE_DIAMETER/2,
    bearing_pos=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    bearing_r=BEARING_DIAMETER/2,
    bearing_screw_r=BEARING_SCREW_DIAMETER/2,
    bearing_screw_rod_d=INNER_BEARING_SCREW_DISTANCE_TO_ROD,
    screw_r=ROD_CLAMP_SCREW_DIAMETER/2,
    screw_head_r=11.4/2,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    wire_pos_from_bearing_center=BEARING_DIAMETER/2,
    wire_h=LIGHT_WALL_WIDTH + BEARING_WIDTH/2 + 0.5,
    wire_hole=1.5,
    strech_screw_r=ROD_CLAMP_SCREW_DIAMETER/2,
    strech_screw_head_r=11.4/2,
    strech_screw_nut_access_room=9.5,
    strech_screw_nut_access_h=5,
    strech_screw_nut_width=8.0,
    strech_screw_nut_h=3.0,
    bushing_wall=LINEAR_BUSHING_WALL)
{
  wire_h_pos = rod_r + wire_h;

  inner_pos = (rod_r + bearing_pos + bearing_screw_r);
  second_pos = -(2*bearing_r) + inner_pos;
  wire_y_pos = second_pos + wire_pos_from_bearing_center;

  wire_wall_pos = (wire_pos_from_bearing_center > 0) ?
                    wire_y_pos :
                    wire_y_pos - wall;

  screw_wall_pos = wire_wall_pos - 2*strech_screw_head_r - lwall;
  strech_screws_pos = lwall + strech_screw_head_r;
  strech_screws_distance = 15;
  strech_screw_hole_pos = (-strech_screws_pos + vsupp)/2;
union() {
  difference() {
    union() {
      base_sliding_block_positive(
          wall=wall,
          lwall=lwall,
          hsupp=hsupp,
          vsupp=vsupp,
          rod_r=rod_r,
          screw_r=screw_r,
          bushing_r=bushing_r,
          bushing_l=2*bushing_l + wall,
          bushing_wall=bushing_wall);

      //wire representation
      translate([wire_y_pos, wire_h_pos, -1])
        %cylinder(r=1, h=bushing_l + 2*bushing_wall + 2);

      //wire contact wall
      translate([wire_wall_pos, 0, 0])
        cube([wall, wire_h_pos + wall + ST, bushing_l + 2*bushing_wall]);
      translate([wire_y_pos - lwall, wire_h_pos, 0])
        cube([2*lwall, wall, bushing_l + 2*bushing_wall]);
      translate([wire_y_pos - ST, 0, 0])
        cube([-wire_y_pos, bushing_r + lwall, bushing_l + 2*bushing_wall]);

      //strech screws wall
      translate([screw_wall_pos + (
        (wire_pos_from_bearing_center > 0) ?
           2*strech_screw_head_r + lwall + wall : -wall),
                 wire_h_pos,
                 0])
            screw_wall(
              wall=wall,
              lwall=lwall,
              vsupp=-0.1,
              screw_r=strech_screw_r,
              screw_head_r=strech_screw_head_r,
              screw_nut_width=strech_screw_nut_width,
              screw_nut_h = strech_screw_nut_h,
              screws_separation  = strech_screws_distance,
              total_len=strech_screws_distance + 2*strech_screw_head_r + lwall
            );

        if (wire_pos_from_bearing_center > 0) union() {
          translate([wire_y_pos, bushing_r + lwall - ST, 0])
            cube([strech_screw_head_r + 2*wall - strech_screw_nut_width/2,
                  wire_h_pos - bushing_r,
                  lwall]);
          translate([wire_y_pos + wall, bushing_r + lwall - ST,
                     2*strech_screw_head_r + lwall + strech_screws_distance - lwall])
            cube([strech_screw_head_r + wall - strech_screw_nut_width/2,
                  wire_h_pos - bushing_r,
                  lwall]);
        }
    }

    base_sliding_block_negative(
        wall=wall,
        lwall=lwall,
        hsupp=hsupp,
        vsupp=vsupp,
        rod_r=rod_r,
        screw_r=screw_r,
        bushing_r=bushing_r,
        bushing_l=2*bushing_l + wall,
        bushing_wall=bushing_wall);
  }
  translate([0,0, bushing_l + bushing_wall]) difference() {
    union() {
      cylinder(r=bushing_r + ST, h=wall);
      translate([0, -(bushing_r - bushing_wall), 0])
        cube([bushing_r + lwall - ST, 2*(bushing_r - bushing_wall), wall +2]);
    }
    translate([0,0,vsupp])
      cylinder(r=bushing_r-bushing_wall, h=wall +2);
    translate([0, -(bushing_r - bushing_wall), vsupp])
      #cube([bushing_r + lwall, 2*(bushing_r - bushing_wall), wall +2]);
  }
}
}

module wire_spool(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    rod_r=ROD_HOLE_DIAMETER/2,
    screw_r=ROD_CLAMP_SCREW_DIAMETER/2,
    strech_screws_distance = 15,
    screw_head_r=11.4/2,
    wire_hole=1)
{
  difference() {
    union() {
      cylinder(r=screw_r + wall, h=lwall + ST);
      translate([0,0,lwall - ST])
        cylinder(r1=screw_r + wall, r2=screw_r + lwall, h=wall/2 + 2*ST);
      translate([0,0,lwall + wall/2 - ST])
        cylinder(r2=screw_r + wall, r1=screw_r + lwall, h=wall/2 + ST);

      //wire knot place
      translate([0, 0, 0])
        cube([lwall, screw_r + wall + lwall, lwall]);
    }
    translate([0,0,-1])
      #cylinder(r=screw_r, h=lwall + wall + 2);
    translate([0,0,-1])
      #cylinder(r=screw_r, h=lwall + wall + 2);
  }
}

module base_sliding_block_positive(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    rod_r=ROD_HOLE_DIAMETER/2,
    screw_r=3.7/2,
    screw_nut_width=6.7,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushing_wall=LINEAR_BUSHING_WALL)
{
  is_double = (2*rod_r + (2 + 2*cos(45))*lwall + screw_r) < bushing_l/2;
  rod_clamp_h = is_double ? 2*(lwall + screw_r)/cos(45) : 0;

  union() {
    //bushing
    cylinder(r=bushing_r + lwall, h=bushing_l + 2*bushing_wall);
    translate([0, -bushing_r - lwall, 0])
      cube([(bushing_r + screw_r),
            2*(bushing_r + lwall),
            bushing_l + 2*bushing_wall]);
    //bushing screw
    translate([(bushing_r + screw_r),
               0,
               (lwall+screw_r)/cos(45)])
      rotate([0,45,0])
        cube([2*(screw_r + lwall), 2*(bushing_r + lwall), 2*(screw_r + lwall)],
             center=true);

    if(is_double)
      translate([(bushing_r + screw_r),
                 0,
                 bushing_l + 2*bushing_wall - (lwall+screw_r)/cos(45)])
        rotate([0,45,0])
          cube([2*(screw_r + lwall), 2*(bushing_r + lwall), 2*(screw_r + lwall)],
               center=true);

    //rod clamp
    translate([-bushing_r - lwall,
               -bushing_r- 2*rod_r - vsupp,
               rod_clamp_h])
      cube([2*bushing_r + screw_r + lwall,
            vsupp + 2*rod_r + bushing_r,
            2*rod_r + 2*lwall]);

    //rod clamp screw
    translate([bushing_r - screw_r - 2*lwall,
               -bushing_r - 2*rod_r - screw_r,
               rod_clamp_h])
      cube([2*screw_r + 2*lwall, 2*screw_r + 2*lwall, 2*rod_r + 2*lwall]);
    translate([bushing_r - lwall, -bushing_r - 2*rod_r - screw_r, rod_clamp_h])
      cylinder(r=screw_r + lwall, h=2*rod_r + 2*lwall);

    //support
    if (is_double) union() {
      translate([-bushing_r - lwall,
                 -bushing_r- 2*rod_r - vsupp,
                 0])
        cube([lwall, bushing_r + 2*rod_r + lwall, rod_clamp_h + ST]);
      translate([-bushing_r - lwall,
                 -bushing_r- 2*rod_r - vsupp - 2*screw_r - lwall,
                 0])
        cube([vsupp, bushing_r + 2*rod_r + lwall, rod_clamp_h + ST]);
      translate([bushing_r + screw_r - vsupp,
                 -bushing_r- 2*rod_r - vsupp - 2*screw_r - lwall,
                 0])
        cube([vsupp,bushing_r + 2*rod_r + lwall, rod_clamp_h + ST]);
      translate([-bushing_r - lwall,
                 -bushing_r- 2*rod_r - vsupp - 2*screw_r - lwall,
                 rod_clamp_h - hsupp - ST])
        cube([2*bushing_r + lwall + screw_r, bushing_r + 2*rod_r + lwall, hsupp]);
    }
  }
}

module base_sliding_block_negative(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    rod_r=ROD_HOLE_DIAMETER/2,
    screw_r=3.7/2,
    screw_head_r=7.5/2,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushing_wall=LINEAR_BUSHING_WALL)
{
  is_double = (2*rod_r + (2 + 2*cos(45))*lwall + screw_r) < bushing_l/2;
  rod_clamp_h = is_double ? 2*(lwall + screw_r)/cos(45) : 0;
  
  union() {
    //rod
    translate([-bushing_r - lwall + vsupp,
               -bushing_r - rod_r -ST,
               rod_clamp_h + lwall + rod_r])
      rotate([0,90,0])
        cylinder(r=rod_r, h=2*bushing_r + screw_r + lwall - 2*vsupp);

    translate([-bushing_r - lwall - vsupp,
               -bushing_r - rod_r -ST,
               rod_clamp_h + lwall + rod_r])
      rotate([0,90,0])
        cylinder(r=0.3*rod_r, h=2*bushing_r + screw_r + lwall + 2*vsupp);

    //rod screw
    translate([bushing_r - lwall, -bushing_r - 2*rod_r - screw_r, rod_clamp_h])
      union()
    {
      translate([0, 0, is_double ? vsupp : -ST])
        cylinder(r=screw_r, h = rod_r + lwall - vsupp);
      translate([0, 0, rod_r + 2*lwall + hsupp])
        cylinder(r=screw_r, h = rod_r + lwall +1);
      translate([0, 0, rod_r -ST])
        cylinder(r=screw_r + lwall - vsupp, h=2*lwall);
      translate([0, 0, 2*rod_r + 2*lwall + ST])
        #cylinder(r=screw_head_r, h = bushing_l);
    }

    //bushing
    translate([0,0,-1])
      cylinder(r=bushing_r - bushing_wall, h=bushing_l + bushing_wall + 1 - ST);
    translate([0,0,bushing_l + bushing_wall + hsupp])
      cylinder(r=bushing_r - bushing_wall, h=bushing_wall + 1);
    translate([0,0,bushing_wall])
      cylinder(r=bushing_r, h=bushing_l);

    //bushing access
    translate([0, -bushing_r + bushing_wall, 0])
      union()
    {
      translate([0,0,-1])
        cube([(bushing_r + lwall) + (2*screw_r + wall)/cos(45) +1,
               2*(bushing_r -bushing_wall),
               bushing_l + bushing_wall +1 - ST]);
      translate([0, 0, bushing_l + bushing_wall + hsupp])
        cube([(bushing_r + lwall) + (2*screw_r + wall)/cos(45) +1,
               2*(bushing_r -bushing_wall),
               bushing_wall +1]);
    }

    //bushing screw
    translate([(bushing_r + screw_r),
               0,
               (lwall+screw_r)/cos(45)])
      rotate([90,0,0])
        cylinder(r=screw_r, h=2*bushing_r + 2*lwall +2, center=true);

    if(is_double)
      translate([(bushing_r + screw_r),
                 0,
                 bushing_l + 2*bushing_wall - (lwall+screw_r)/cos(45)])
        rotate([90,0,0])
          cylinder(r=screw_r, h=2*bushing_r + 2*lwall +2, center=true);
  }
}

module base_sliding_block(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=HORIZONTAL_SUPPORT_WALL,
    vsupp=VERTICAL_SUPPORT_WALL,
    rod_r=ROD_HOLE_DIAMETER/2,
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
        screw_r=screw_r,
        bushing_r=bushing_r,
        bushing_l=bushing_l,
        bushing_wall=bushing_wall);

    #base_sliding_block_negative(
        wall=wall,
        lwall=lwall,
        hsupp=hsupp,
        vsupp=vsupp,
        rod_r=rod_r,
        screw_r=screw_r,
        bushing_r=bushing_r,
        bushing_l=bushing_l,
        bushing_wall=bushing_wall);
  }
}
