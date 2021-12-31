$fn=100;

use <smooth_prim.scad>

box();
translate([0,-h-2*wall-8,0])
lid();

// tolerance
tol=0.1;

// Box
// wall thickness
wall=3.5;
// base thickness
base=3;
// top thickness
top=2;
// inner box width
w=132;
w_outer=w+2*wall;
w_center=w_outer/2;
// inner box length
h=85;
h_outer=h+2*wall;
h_center=h_outer/2;
// inner box depth 
d=50;
// outer corner radius
outer_r=6;
// inner corner radius
inner_r=4;
// top lip depth
lip=5;
// top lip thickness
lip_thickness=1.5;
// lid tolerance
lid_tol=0.15;

// Bolt posts
bolt_hole_r=1.6;
post_r=4.5;
post_inset=post_r-tol;
post_h=(h-2*post_inset)/2;
post_w=(w-2*post_inset)/2;
// Counter sinks
nut_width=5.5;
nut_height=2.4;
bolt_head_r=3.1;
bolt_head_height=2.3;


module box() {
    difference() {
        union() {
            difference() {
                union() {
                    SmoothXYCube([w+2*wall,h+2*wall,d+base], outer_r);
                    translate([wall-lip_thickness, wall-lip_thickness, d+base])
                    SmoothXYCube([w+2*lip_thickness, h+2*lip_thickness, lip], inner_r);
                }
                translate([wall, wall, base])
                SmoothXYCube([w,h,d+lip+tol], inner_r);
            }
            translate([w_center, h_center, 0])
            bolt_posts(post_r, d+base+lip);
            //posts(post_r, bolt_hole_r, d+lip);
        }
        translate([w_center, h_center, 0])
        counter_sunk_holes(bolt_hole_r, d+base+lip,
                           "hex", nut_width, nut_height);
    }
}

module lid() {
    difference() {
        union() {
            difference() {
                SmoothXYCube([w+2*wall,h+2*wall,top+lip], outer_r);
                translate([wall-lip_thickness-lid_tol, wall-lip_thickness-lid_tol, top])
                SmoothXYCube([w+2*lip_thickness+2*lid_tol,h+2+lip_thickness+2*lid_tol,lip+tol], inner_r);
            }
            translate([w_center, h_center, 0])
            bolt_posts(post_r, top+lip);
        }
        translate([w_center, h_center, 0]) {
        counter_sunk_holes(bolt_hole_r, top+lip,
                           "circle", bolt_head_r, bolt_head_height);
        }
    }
}

module bolt_posts(radius, height)
{
    for(c = [[-1,1], [-1,-1], [1,1], [1,-1]]) {
        translate([c[0]*post_w, c[1]*post_h, 0])
        cylinder(r=radius,h=height);
    }
}

module counter_sunk_holes(radius, height, type, width, depth){
    for(c = [[-1,1], [-1,-1], [1,1], [1,-1]]) {
        translate([c[0]*post_w, c[1]*post_h, -tol])  
        union() {
            cylinder(r=radius,h=height+tol*2);
            if (type=="hex") {
                cylinder(r=width/2/0.866,h=depth, $fn=6);
            } else if (type=="circle") {
                cylinder(r=width,h=depth+tol);
            }
        }
    }
}