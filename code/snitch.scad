include<sensor_mounts.scad>;
include<orientation_mounts_and_keys.scad>;

//precision      = 100;

radial_gap     = 0.25 * 1;
cube_gap       = 0.5 * 1;

wall_thickness = 4;
/*************************************************************************************************/
/*************************************************************************************************/
/************************************* <NEW BASE MODULES/> ***************************************/
module cube_peg(length, width, height)
{
    cube(size = [length, width, height], center = true);
}
/*************************************************************************************************/
module radial_peg(radius, height)
{
    cylinder(r = radius, h = height, $fn = precision, center = true);
}
/*************************************************************************************************/
module cube_hole(length, width, height, wall)
{
    difference()
    {
        cube_peg(length + cube_gap + wall, width + cube_gap + wall, height);
        cube_peg(length + cube_gap, width + cube_gap, height);
    }
}
/*************************************************************************************************/
module radial_hole(radius, height, wall)
{
    wall = wall/2;
    difference()
    {
        radial_peg(radius + radial_gap + wall, height);
        radial_peg(radius + radial_gap, height);
    }
}
/*************************************************************************************************/
module cube_lip(length_outer, length_inner, width_outer, width_inner, height)
{
    difference()
    {
        cube(size = [length_outer, width_outer, height], center = true);
        cube(size = [length_inner, width_inner, height], center = true);
    }
}
/*************************************************************************************************/
module cube_lid(length_outer, length_inner, width_outer, width_inner, height)
{
    wall_size = 2;
    difference()
    {
        cube(size = [length_outer + wall_size, width_outer + wall_size, height], center = true);
        cube_lip(length_outer + cube_gap, length_inner - cube_gap, width_outer + cube_gap, width_inner - cube_gap, height);
    }
    translate([0, 0, -height])
    cube(size = [length_outer + wall_size, width_outer + wall_size, height], center = true);
}
/*************************************************************************************************/
module cube_cap(length_outer, width_outer, height, wall)
{
    difference()
    {
        cube_peg(length_outer, width_outer, height);
        translate([0, 0, -wall/2])
        cube_peg(length_outer - wall*2, width_outer - wall*2, height - wall);
    }
}
/*************************************************************************************************/
module radial_lip(radius_outer, radius_inner, height)
{
    difference()
    {
        cylinder(r = radius_outer, h = height, $fn = precision, center = true);
        cylinder(r = radius_inner, h = height, $fn = precision, center = true);
    }
}
/*************************************************************************************************/
module radial_lid(radius_lip_outer, radius_lip_inner, height)
{
    wall_radius = 2;// This is how much material is on the outside of the cap: it has nothing to do with fit.
    difference()
    {
      cylinder(r = radius_lip_outer + wall_radius, h = height, $fn = precision, center = true);
      radial_lip(radius_lip_outer + radial_gap, radius_lip_inner - radial_gap, height);
    }
    translate([0, 0, -height])
    cylinder(r = radius_lip_outer + wall_radius, h = height, $fn = precision, center = true);
}
/*************************************************************************************************/
module radial_cap(radius_peg, height, wall)
{
    difference()
    {
        cylinder(r = radius_peg + wall, h = height + wall, $fn = precision, center = true);
        translate([0, 0, wall/2])
        radial_peg(radius_peg + radial_gap, height);
    }
}
/************************************* </NEW BASE MODULES> *****************************************/
/*********************************** <NEW COMPOSITE MODULES/> **************************************/
/***************************************************************************************************/
//Make a block that places the cutouts for the screen and ports on the Link.
//Use this to stamp a negative onto a sensor platform.  The sensor platform should include holes for wires, and should have guide
//rails for wires leading back to the Link ports.
screen_side            = 70;
strip_length           = 90;
strip_width            = 15;
switch_width           = 10;
cable_thickness        = 8;

tab_width              = 4;
tab_length             = 10;
tab_height             = inner_wall + 5;
sensor_mount_width     = 4 + cube_gap;

mounting_nut_radius    = 9/2;
mounting_nut_height    = 3;
mounting_bolt_radius   = 2;
mounting_peg_height    = 40;
mounting_screw_height  = 8;

new_deck_height = 4;//3;
extra_height = 10 + inner_wall;
peg_radius = ((caster_bolt_radius * 2) + inner_wall)/2 - radial_gap;
peg_height = caster_bolt_length + caster_nut_height + cube_gap + inner_wall + extra_height;
wall_height = caster_nut_height + inner_wall + cube_gap;

module screw_hole(){
    //rotate([0,90,0])
    //translate([screw_separation/2, 0, 0])
    translate([0, screw_separation/2, 0])
    cylinder(r2 = screw_bottom_radius, r1 = screw_top_radius, h = motor_mount_depth, $fn = precision, center = true);
}
/***************************************************************************************************/
module motor_mount(){
    outer_x = motor_mount_length + motor_mount_thickness; 
    outer_y = motor_mount_width + motor_mount_thickness;
    inner_x = motor_mount_length - inner_wall;// + cube_gap; 
    inner_y = motor_mount_width + motor_mount_depth * 2 + cube_gap; 
    motor_z = motor_mount_length;
    
    arc_r   = motor_z * 0.40;
    
    //translate([-(motor_mount_width + motor_mount_thickness*2)/2 + (link_height/2 - inner_wall_depth/2), 0, -(motor_mount_length + mount_to_end + 4)/2])
    difference(){
        cube_peg(inner_x, inner_y, motor_mount_depth);
        screw_hole();
        mirror([0,1,0])screw_hole();
        //translate([-(motor_mount_length + motor_mount_depth)/2, 0, 0])
        //cube_peg(motor_mount_depth, motor_mount_width + cube_gap, motor_mount_length + mount_to_end);
    }
    translate([0, inner_y/2, motor_mount_depth/2])
    cube_peg(inner_x, motor_mount_depth, motor_mount_depth * 2);
    translate([0, -inner_y/2, motor_mount_depth/2])
    cube_peg(inner_x, motor_mount_depth, motor_mount_depth * 2);
 }
/***************************************************************************************************/
/***************************************************************************************************/
/***************************************************************************************************/


/***************************************************************************************************/
module cutout(wall_height){
    cutout_coeff = 0.39;
    linear_extrude(height = wall_height, scale=[1,1], slices=20, twist=0)
    polygon(points=[[0, 0],[-link_side * cutout_coeff, link_side * cutout_coeff],[link_side * cutout_coeff, link_side * cutout_coeff]]);
}
/***************************************************************************************************/

module caster_strip(){
    translate([0, -((caster_nut_radius * 2) + radial_gap + lego_h)/2, (lego_h)/2])
    difference(){
        //cube_peg(lego_h * 11, lego_h, lego_h);
        cube_peg(lego_h * 5, lego_h, lego_h);
        for(i = [-4, -3, -2, 2, 3, 4]){
            for(j = [-1, 1]){
                translate([lego_h * j - lego_h * i, 0, 0])
                //rotate([90, 0, 0])
                radial_peg(lego_r, lego_h * 2);
            }
        }
    }
    
    translate([0, 0, mounting_peg_height/2 - wall_height/2 + (caster_nut_height + cube_gap + inner_wall)])
    caster_housing();
}
/***************************************************************************************************/
module link_box(){
    
    
    //Base
    difference(){
        cube_peg(box_side, box_side, wall_height);
        translate([0, 0, wall_height * 0.25])
        cube_peg(link_side + cube_gap, link_side + cube_gap, wall_height * 1);
        //triangle cutouts
        for(i = [0:3]){
            rotate([0, 0, 90 * i])
            translate([0, inner_wall * 3, -wall_height * 0.5])
            cutout(wall_height * 1);
        }
        //Hole for circle cutout
        translate([0, 0, -wall_height * 0.25])
        radial_peg(link_side * 0.40, wall_height * 0.5);
        /*
        //Motor mount cutout
        translate([0, 0, -(motor_mount_depth + inner_wall/2)])
        cube_peg(box_side, motor_mount_width + motor_mount_depth, motor_mount_depth);*/
    }
    //Circle cutout
    translate([0, 0, -wall_height * 0.37])
    difference(){
        radial_peg(link_side * 0.40, wall_height * 0.25);
        radial_peg(link_side * 0.40 - wall_height * 0.75, wall_height * 0.25);
    }
    
    
 
}

/***************************************************************************************************/
module caster_housing(){
    //Caster Nut Enclosure
    translate([0, 0, -(mounting_peg_height - (caster_nut_height + cube_gap + inner_wall))/2 - (caster_nut_height + cube_gap + inner_wall)/2])
    difference(){  
        //cube_peg((caster_nut_radius * 2) + radial_gap + inner_wall, (caster_nut_radius * 2) + radial_gap + inner_wall, caster_nut_height + cube_gap + inner_wall);
        radial_peg(((caster_nut_radius * 2) + radial_gap + inner_wall)/2, caster_nut_height + cube_gap + inner_wall);

        radial_peg(caster_bolt_radius, caster_bolt_length + cube_gap + inner_wall);
        //translate([0, 0, caster_bolt_length/2 + (caster_nut_height + cube_gap)/2])
        cylinder(r = caster_nut_radius + radial_gap, h = caster_nut_height + cube_gap, $fn = 6, center = true);
        translate([0, (caster_nut_radius + radial_gap), 0])
        cube_peg((caster_nut_radius * 2) + radial_gap, (caster_nut_radius * 2) + radial_gap, caster_nut_height + cube_gap);
    }
}
/***************************************************************************************************/
module mounting_peg(){
    //extra_height = 10 + inner_wall;
   
    difference(){
        radial_peg(peg_radius, mounting_peg_height);//caster_bolt_length +caster_nut_height + cube_gap + mounting_nut_height + cube_gap + inner_wall);
    
        translate([0, 0, mounting_peg_height/2 - (mounting_nut_height + inner_wall/2) ]){
            cylinder(r = mounting_nut_radius + radial_gap, h = mounting_nut_height + cube_gap, $fn = 6, center = true);
            translate([0, (mounting_nut_radius + radial_gap), 0])
            cube_peg((mounting_nut_radius * 2) + cube_gap, (mounting_nut_radius * 2) + cube_gap, mounting_nut_height + cube_gap);
        }
        translate([0, 0, mounting_peg_height/2 - mounting_screw_height/2])
        radial_peg(mounting_bolt_radius + radial_gap, mounting_screw_height);
        
        /*translate([peg_radius * 1.07, 0, -caster_bolt_length * 0.60])
        rotate([90, 0, 0])
        scale([1, 2.5, 1])
        radial_peg(peg_radius * 1.5, peg_radius * 2);*/
    }
}



/***************************************************************************************************/
module motor_mount_face(){   
    
    motor_shaft_radius = 7/2;
    motor_mount_orad   = 4/2;
    motor_mount_irad   = 3/4;
    
    difference(){
        cube_peg(motor_mount_thickness, motor_mount_width, motor_mount_height);
    
        translate([0, 5.5, 0])
        rotate([0, -90, 0])
        cylinder(r1 = motor_mount_irad, r2 = motor_mount_orad, h = motor_mount_thickness + cube_gap, $fn = precision, center = true);
        translate([0, -5.5, 0])
        rotate([0, -90, 0])
        cylinder(r1 = motor_mount_irad, r2 = motor_mount_orad, h = motor_mount_thickness + cube_gap, $fn = precision, center = true);
        translate([0, 0.0, 0])
        rotate([0, 90, 0])
        cylinder(r = motor_shaft_radius, h = motor_mount_thickness + cube_gap, $fn = precision, center = true);
    }
}
/***************************************************************************************************/
module keyed_caster_negative(){
    translate([caster_bolt_radius, 0, 0]){
        radial_peg(((caster_nut_radius * 2) + radial_gap + inner_wall)/2, deck_height * 2);
        
        //translate([caster_bolt_radius, -(mount_key_side * 0.25), 0])
        rotate([0, 0, 180])
        translate([-caster_bolt_radius * 2.5, 0, 0])
        scale([1, 1, inner_wall/40])
        vertical_key();
    }
}

/***************************************************************************************************/
lower_middle_y = botball_radius * 2 - (bumper_top_height + bumper_bottom_height) * 2.8;
//link_box();
//translate([10, 0, -(caster_nut_height + cube_gap + inner_wall)/2])
//mounting_peg();
//motor_mount();
//translate([peg_radius * 2, 0, (4.75)])
//caster_housing();

sensor_deck_radius = 95;//box_side + screw_top_radius * 3;
bumper_radius = box_side/2 + motor_mount_length * 2;//160/2;
bumper_length = 210;
bumper_height = 21;
bumper_ratio = bumper_length / (bumper_radius * 2 * PI);//0.41778172561622525639331987885285;

module frame(base_dim){
    tiny_side   = base_dim;//50.8;
    outer_dim   = tiny_side + lego_h * 2;
    frame_width = outer_dim - tiny_side;//(link_side - lego_h * 4 - lego_r);
    
    difference(){
        cube_peg(outer_dim, outer_dim, lego_h);
        cube_peg(base_dim, base_dim, lego_h);
        for(i = [-1, 1]){
            for(j = [-1, 1]){
                translate([(outer_dim)/2 * i, (outer_dim)/2 * j, 0])
                cube_peg(frame_width/2, frame_width/2, lego_h);
            }
        }
    }
    
    for(i = [-1, 1]){
        for(j = [-1, 1]){
            translate([(outer_dim - frame_width/2)/2 * i, (outer_dim - frame_width/2)/2 * j, 0])
            radial_peg(frame_width/4, lego_h);
        }
    }
}
//Make sure that the added walls bring the total dimensions to 
//box_side
module link_sensor_mount(){
    difference(){
        union(){
            scale([1, 1, 3])
            frame(link_side - lego_h * 4 - lego_r);    
            translate([0, 0, -(lego_h * 1)])
            for(l = [-1:1]){
                rotate([0, 0, 120 * l])
                translate([0,(link_side - lego_h * 2 - lego_r)/4, 0])
                difference(){
                    cube_peg(lego_h * 2, (link_side - lego_h)/2, lego_h);
                    translate([0, lego_h, 0])
                    radial_peg(lego_r, lego_h);
                    translate([0, -lego_h, 0])
                    radial_peg(lego_r, lego_h);
                }
            }
        }
        for(i = [0, 2]){
            for(j = [-4.5,-2.5,2.5,4.5]){
                rotate([0, 0, 90 * i])
                translate([(link_side - lego_h * 2 - lego_r)/2, lego_h *j, 0])
                radial_peg(lego_r, lego_h * 3);
            }
        }
        
        for(i = [1, 3]){
            for(j = [-4.5,-2.5,2.5,4.5]){
                rotate([0, 0, 90 * i])
                translate([(link_side - lego_h * 2 - lego_r)/2, lego_h * j, 0])
                radial_peg(lego_r, lego_h * 3);
            }
        }
        
        for(i = [-1, 1]){
            for(j = [-1, 1]){
                translate([(link_side/2 + lego_r * 1.5) * i, (link_side/2 + lego_r * 1.5) * j, 0])
                radial_peg(lego_r, lego_h * 3);
            }
        }
    }
   
}
//Modular Motor Mount
//translate([-(frame_side/2 - (motor_frame_width + lego_r)/2), 0, lego_h * 2])
module modular_motor_mount(){
    rotate([0, -0, 0]){
        difference(){
            union(){
                cube_peg(motor_frame_width + lego_r, frame_side, lego_h);
                translate([-((motor_frame_width + lego_r)/2 - motor_mount_thickness/2), 0, lego_h/2 + motor_mount_length/2])
                motor_mount_face();
            }
            
            for(i = [1, 3]){
                for(j = [-4.5,-2.5,2.5,4.5]){
                    //rotate([0, 0, 90 * i])
                    translate([0, lego_h *j, 0])
                    rotate([0, 90, 0])
                    radial_peg(lego_r, lego_h * 3);
                }
            }
        }
        

        translate([0, frame_side/2 - (motor_frame_width + lego_r)/2, lego_h * 2])
        cube_peg(motor_frame_width + lego_r, motor_frame_width + lego_r, lego_h * 3);
               
        translate([0, -(frame_side/2 - (motor_frame_width + lego_r)/2), lego_h * 2])
        cube_peg(motor_frame_width + lego_r, motor_frame_width + lego_r, lego_h * 3);
        
        translate([(frame_side/2)/2  - ((motor_frame_width + lego_r)/2), 0, (lego_h + motor_mount_length)])
        //translate([motor_mount_depth/2, 0, 0])
        cube_peg(frame_side/2, frame_side, lego_h);
        
        
    }
    
}

module lego_motor_mount(){
    rotate([0, -90, 0])
    difference(){
        //Wheels
        translate([-(frame_side/2 - (motor_frame_width + lego_r)/2), 0, lego_h * 0])
        {
            modular_motor_mount();
            //rotate([0, 90, 0])
            //translate([-(motor_frame_width/2 + 15), 0, -10])
            //radial_peg(30, 4);
        }
        translate([0, 0, (lego_h + motor_mount_length)])    
            for(i = [-7:7]){
                for(j = [-5:0]){
                    translate([lego_h * j, lego_h * i, 0])
                    radial_peg(lego_r, lego_h);
                }
            }
            
        //Cutouts for Caster placement
        translate([0, frame_side/2 - lego_h * 2, motor_mount_length + lego_h])
        cube_peg(lego_h * 5, lego_h * 4.5, lego_h);
        translate([0, -(frame_side/2 - lego_h * 2), motor_mount_length + lego_h])
        cube_peg(lego_h * 5, lego_h * 4.5, lego_h);
        
    }
}

module modular_fitec_mount(){
    horn_indent = 14 - lego_h/2 ;//16 - 3;// from end to center, minus radius of screw mount hole
    //Take away main deck plate, and print for servo fitting....
    rotate([0, -0, 0]){
        difference(){
            union(){
                //Top Bar
                cube_peg(motor_frame_width + lego_r, frame_side, lego_h);
                
                //Deck Bed
                translate([(frame_side/2)/2  - ((motor_frame_width + lego_r)/2), 0, (lego_h + servo_mount_height)])
                cube_peg(frame_side/2, frame_side, lego_h);
                    
                //Servo Mounting Posts
                translate([-((motor_frame_width + lego_r)/2 - motor_mount_thickness/2), horn_indent, lego_h/2 + servo_mount_height/2])
                union(){
                    translate([0, servo_mount_width, 0])
                    difference(){
                        cube_peg(motor_mount_thickness, lego_h, servo_mount_height);
                        translate([0, 0, 5])
                        rotate([0, 90, 0])
                        radial_peg(2, motor_mount_thickness + cube_gap);
                        translate([0, 0, -5])
                        rotate([0, 90, 0])
                        radial_peg(2, motor_mount_thickness + cube_gap);
                    }
                    
                    mirror([0, 1, 0]){
                        translate([0, servo_mount_width, 0])
                        difference(){
                            cube_peg(motor_mount_thickness, lego_h, servo_mount_height);
                            translate([0, 0, 5])
                            rotate([0, 90, 0])
                            radial_peg(2, motor_mount_thickness + cube_gap);
                            translate([0, 0, -5])
                            rotate([0, 90, 0])
                            radial_peg(2, motor_mount_thickness + cube_gap);
                        }
                    }
                }
            }
            
            for(i = [1, 3]){
                for(j = [-4.5,-2.5,2.5,4.5]){
                    //rotate([0, 0, 90 * i])
                    translate([0, lego_h *j, 0])
                    rotate([0, 90, 0])
                    radial_peg(lego_r, lego_h * 3);
                }
            }
            
            //Outer Post Cutouts
            translate([0, (frame_side/2 - (motor_frame_width)/2 + lego_r * 2), servo_mount_height/2])
            cube_peg(motor_frame_width + lego_r, motor_frame_width, servo_mount_height + lego_h);
                   
            translate([0, -(frame_side/2 - (motor_frame_width)/2+ lego_r * 2), servo_mount_height/2])
            cube_peg(motor_frame_width + lego_r, motor_frame_width, servo_mount_height + lego_h);
            
            translate([-lego_r * 2, (frame_side/2 - (motor_frame_width)/2 + lego_r * 2), servo_mount_height/2 + lego_h])
            cube_peg(motor_frame_width, motor_frame_width, servo_mount_height + lego_h);
                   
            translate([-lego_r * 2, -(frame_side/2 - (motor_frame_width)/2+ lego_r * 2), servo_mount_height/2 + lego_h])
            cube_peg(motor_frame_width, motor_frame_width, servo_mount_height + lego_h);
        }
        

        //Outer Post Cutouts
        translate([0, frame_side/2 - (motor_frame_width + lego_r)/2, lego_h/2 + servo_mount_height/2])
        radial_peg((motor_frame_width + lego_r)/2, servo_mount_height + lego_h * 2);
               
        translate([0, -(frame_side/2 - (motor_frame_width + lego_r)/2), lego_h/2 + servo_mount_height/2])
        radial_peg((motor_frame_width + lego_r)/2, servo_mount_height + lego_h * 2);
        
    }
    
    
}

module modular_parallax_mountA(){
    horn_indent = 14 - lego_h/2 ;//16 - 3;// from end to center, minus radius of screw mount hole
    //Take away main deck plate, and print for servo fitting....
    rotate([0, -0, 0]){
        difference(){
            union(){
                //Top Bar
                cube_peg(motor_frame_width + lego_r, frame_side, lego_h);
                
                //Deck Bed
                translate([(frame_side/2)/2  - ((motor_frame_width + lego_r)/2), 0, (lego_h + servo_mount_height)])
                cube_peg(frame_side/2, frame_side, lego_h);
                    
                //Servo Mounting Posts
                translate([-((motor_frame_width + lego_r)/2 - motor_mount_thickness/2), horn_indent, lego_h/2 + servo_mount_height/2])
                union(){
                    translate([0, servo_mount_width, 0])
                    difference(){
                        cube_peg(motor_mount_thickness, lego_h, servo_mount_height);
                        translate([0, 0, 5])
                        rotate([0, 90, 0])
                        radial_peg(2, motor_mount_thickness + cube_gap);
                        translate([0, 0, -5])
                        rotate([0, 90, 0])
                        radial_peg(2, motor_mount_thickness + cube_gap);
                    }
                    
                    mirror([0, 1, 0]){
                        translate([0, servo_mount_width, 0])
                        difference(){
                            cube_peg(motor_mount_thickness, lego_h, servo_mount_height);
                            translate([0, 0, 5])
                            rotate([0, 90, 0])
                            radial_peg(2, motor_mount_thickness + cube_gap);
                            translate([0, 0, -5])
                            rotate([0, 90, 0])
                            radial_peg(2, motor_mount_thickness + cube_gap);
                        }
                    }
                }
            }
            
            for(i = [1, 3]){
                for(j = [-4.5,-2.5,2.5,4.5]){
                    //rotate([0, 0, 90 * i])
                    translate([0, lego_h *j, 0])
                    rotate([0, 90, 0])
                    radial_peg(lego_r, lego_h * 3);
                }
            }
            
            //Outer Post Cutouts
            translate([0, (frame_side/2 - (motor_frame_width)/2 + lego_r * 2), servo_mount_height/2])
            cube_peg(motor_frame_width + lego_r, motor_frame_width, servo_mount_height + lego_h);
                   
            translate([0, -(frame_side/2 - (motor_frame_width)/2+ lego_r * 2), servo_mount_height/2])
            cube_peg(motor_frame_width + lego_r, motor_frame_width, servo_mount_height + lego_h);
            
            translate([-lego_r * 2, (frame_side/2 - (motor_frame_width)/2 + lego_r * 2), servo_mount_height/2 + lego_h])
            cube_peg(motor_frame_width, motor_frame_width, servo_mount_height + lego_h);
                   
            translate([-lego_r * 2, -(frame_side/2 - (motor_frame_width)/2+ lego_r * 2), servo_mount_height/2 + lego_h])
            cube_peg(motor_frame_width, motor_frame_width, servo_mount_height + lego_h);
        }
        

        //Outer Post Cutouts
        translate([0, frame_side/2 - (motor_frame_width + lego_r)/2, lego_h/2 + servo_mount_height/2])
        radial_peg((motor_frame_width + lego_r)/2, servo_mount_height + lego_h * 2);
               
        translate([0, -(frame_side/2 - (motor_frame_width + lego_r)/2), lego_h/2 + servo_mount_height/2])
        radial_peg((motor_frame_width + lego_r)/2, servo_mount_height + lego_h * 2);
        
    }
    
    
}
module modular_parallax_mountB(){
    horn_indent = 14 - lego_h/2 ;//16 - 3;// from end to center, minus radius of screw mount hole
    //Take away main deck plate, and print for servo fitting....
    rotate([0, -0, 0]){
        difference(){
            union(){
                //Top Bar
                cube_peg(motor_frame_width + lego_r, frame_side, lego_h);
                
                //Deck Bed
                translate([(frame_side/2)/2  - ((motor_frame_width + lego_r)/2), 0, (lego_h + servo_mount_height)])
                cube_peg(frame_side/2, frame_side, lego_h);
                    
                //Servo Mounting Posts
                translate([-((motor_frame_width + lego_r)/2 - motor_mount_thickness/2), -horn_indent, lego_h/2 + servo_mount_height/2])
                union(){
                    translate([0, servo_mount_width, 0])
                    difference(){
                        cube_peg(motor_mount_thickness, lego_h, servo_mount_height);
                        translate([0, 0, 5])
                        rotate([0, 90, 0])
                        radial_peg(2, motor_mount_thickness + cube_gap);
                        translate([0, 0, -5])
                        rotate([0, 90, 0])
                        radial_peg(2, motor_mount_thickness + cube_gap);
                    }
                    
                    mirror([0, 1, 0]){
                        translate([0, servo_mount_width, 0])
                        difference(){
                            cube_peg(motor_mount_thickness, lego_h, servo_mount_height);
                            translate([0, 0, 5])
                            rotate([0, 90, 0])
                            radial_peg(2, motor_mount_thickness + cube_gap);
                            translate([0, 0, -5])
                            rotate([0, 90, 0])
                            radial_peg(2, motor_mount_thickness + cube_gap);
                        }
                    }
                }
            }
            
            for(i = [1, 3]){
                for(j = [-4.5,-2.5,2.5,4.5]){
                    //rotate([0, 0, 90 * i])
                    translate([0, lego_h *j, 0])
                    rotate([0, 90, 0])
                    radial_peg(lego_r, lego_h * 3);
                }
            }
            
            //Outer Post Cutouts
            translate([0, (frame_side/2 - (motor_frame_width)/2 + lego_r * 2), servo_mount_height/2])
            cube_peg(motor_frame_width + lego_r, motor_frame_width, servo_mount_height + lego_h);
                   
            translate([0, -(frame_side/2 - (motor_frame_width)/2+ lego_r * 2), servo_mount_height/2])
            cube_peg(motor_frame_width + lego_r, motor_frame_width, servo_mount_height + lego_h);
            
            translate([-lego_r * 2, (frame_side/2 - (motor_frame_width)/2 + lego_r * 2), servo_mount_height/2 + lego_h])
            cube_peg(motor_frame_width, motor_frame_width, servo_mount_height + lego_h);
                   
            translate([-lego_r * 2, -(frame_side/2 - (motor_frame_width)/2+ lego_r * 2), servo_mount_height/2 + lego_h])
            cube_peg(motor_frame_width, motor_frame_width, servo_mount_height + lego_h);
        }
        

        //Outer Post Cutouts
        translate([0, frame_side/2 - (motor_frame_width + lego_r)/2, lego_h/2 + servo_mount_height/2])
        radial_peg((motor_frame_width + lego_r)/2, servo_mount_height + lego_h * 2);
               
        translate([0, -(frame_side/2 - (motor_frame_width + lego_r)/2), lego_h/2 + servo_mount_height/2])
        radial_peg((motor_frame_width + lego_r)/2, servo_mount_height + lego_h * 2);
        
    }
}
module parallax_motor_mountA(){
    //rotate([0, -90, 0])
    difference(){
        //Wheels
        translate([-(frame_side/2 - (motor_frame_width + lego_r)/2), 0, lego_h * 0])
        {
            modular_parallax_mountA();
            
            //rotate([0, 90, 0])
            //translate([-(motor_frame_width/2 + 15), 0, -10])
            //radial_peg(30, 4);
        }
        
        //Cutouts for Caster placement
        translate([0, frame_side/2 - lego_h * 2, servo_mount_height + lego_h])
        cube_peg(lego_h * 5, lego_h * 4.5, lego_h);
        translate([0, -(frame_side/2 - lego_h * 2), servo_mount_height + lego_h])
        cube_peg(lego_h * 5, lego_h * 4.5, lego_h);
        
        translate([0, 0, (lego_h + servo_mount_height)])    
            for(i = [-7:7]){
                for(j = [-5:0]){
                    translate([lego_h * j, lego_h * i, 0])
                    radial_peg(lego_r, lego_h);
                }
            }
        
    }
}
module parallax_motor_mountB(){
    //rotate([0, -90, 0])
    difference(){
        //Wheels
        translate([-(frame_side/2 - (motor_frame_width + lego_r)/2), 0, lego_h * 0])
        {
            modular_parallax_mountB();
            
            //rotate([0, 90, 0])
            //translate([-(motor_frame_width/2 + 15), 0, -10])
            //radial_peg(30, 4);
        }
        
        //Cutouts for Caster placement
        translate([0, frame_side/2 - lego_h * 2, servo_mount_height + lego_h])
        cube_peg(lego_h * 5, lego_h * 4.5, lego_h);
        translate([0, -(frame_side/2 - lego_h * 2), servo_mount_height + lego_h])
        cube_peg(lego_h * 5, lego_h * 4.5, lego_h);
        
        translate([0, 0, (lego_h + servo_mount_height)])    
            for(i = [-7:7]){
                for(j = [-5:0]){
                    translate([lego_h * j, lego_h * i, 0])
                    radial_peg(lego_r, lego_h);
                }
            }
        
    }
}
//translate([0, -lego_h * 3, 0])
//caster_strip();
//rotate([0, -90, 0])
//modular_parallax_mount();
//rotate([180, 0, 0])
//translate([0, 0, lego_h/2])
//parallax_motor_mountA();
//lego_motor_mount();
/*
rotate([0, 0, 0]){
    rotate([0, -90, 0])
    lego_motor_mount();
    translate([0, 0, 0])
    mirror([1, 0, 0])
    rotate([0, -90, 0])
    lego_motor_mount();
}*/
/*
//Whole Parallax Rev Mount
rotate([180, 0, 0]){
    parallax_motor_mountA();
    translate([0, 0, 0])
    mirror([1, 0, 0])
    parallax_motor_mountB();
}*/
//caster_strip();
/*
//Color Sensor Mount
color_side   = 20;
color_height = 4;//2;
color_trim   = 1;
difference(){
    cube_peg(color_side + inner_wall, color_side + inner_wall, color_height + lego_h);
    translate([0, 0, lego_h/2])
    cube_peg(color_side + cube_gap, color_side + cube_gap, color_height/2 + cube_gap);
    translate([color_trim, 0, lego_h/2 + color_height/2])
    cube_peg(color_side - color_trim, color_side - color_trim, color_height/2);
    translate([(color_side + inner_wall)/2, 0, 0])
    cube_peg(inner_wall, color_side, color_side + lego_h);
    
    translate([lego_h * 0.5, 0, -color_height/2])
    radial_peg(lego_r, lego_h + color_height/2);
    translate([lego_h * -0.5, 0, -color_height/2])
    radial_peg(lego_r, lego_h + color_height/2);
}
*/
/*
//Sept 13, 2016: Sensor Frame
translate([0, 0, -lego_h * 6])
for(h = [0:2]){
    translate([0, 0, lego_h * 3 + lego_h * h])
    difference(){
        frame(link_side);
        for(i = [0, 2]){
            for(j = [-6:6]){
                rotate([0, 0, 90 * i])
                translate([lego_h * 7.5, lego_h * j, 0])
                rotate([0, 90, 0])
                radial_peg(lego_r, lego_h * 2);
            }
        }
        
        for(i = [1, 3]){
            for(j = [-6:6]){
                rotate([0, 0, 90 * i])
                translate([lego_h * 7.5, lego_h * j, 0])
                rotate([0, 90, 0])
                radial_peg(lego_r, lego_h * 2);
            }
        }
        
        for(i = [-1, 1]){
            for(j = [-1, 1]){
                translate([(link_side/2 + lego_r * 1.5) * i, (link_side/2 + lego_r * 1.5) * j, 0])
                radial_peg(lego_r, lego_h * 3);
            }
        }
    }
}
*/
/*
//13 Sept, 2016: Mounting Spacer
for(l = [1]){
    translate([0, 0, lego_h * l])
    link_sensor_mount();
}
*/
scaffold_l = 9;
wing_l = 3;
//15 Sept, 2016: Bumper
module bumper_wing(side){
    difference(){
        union(){
            cube_peg(lego_h * wing_l, lego_h, lego_h * 4);
            translate([lego_h * wing_l/2 * side, 0, 0])
            radial_peg(lego_h/2, lego_h * 4);
        }
        
        for(i = [-1.5, -0.5, 0.5, 1.5]){
            for(j = [-3:3]){
                translate([lego_h * j, 0, lego_h * i])
                rotate([90, 0, 0])
                radial_peg(lego_r, lego_h);
            }
        }
    }
}

module bumper_scaffold(){
    cube_peg(lego_h * scaffold_l, lego_h, lego_h * 4);
    translate([(lego_h * scaffold_l)/2, 0, 0]){
        radial_peg(lego_h/2, lego_h * 4);
        rotate([0, 0, 45])
        translate([lego_h * wing_l/2, 0, 0]){
            bumper_wing(1);
        }
    }

    translate([-(lego_h * scaffold_l)/2, 0, 0]){
        radial_peg(lego_h/2, lego_h * 4);
        rotate([0, 0, -45])
        translate([-lego_h * wing_l/2, 0, 0]){
            bumper_wing(-1);
        }
    }
}
/***************************************************************************************************************/
/***************************************************************************************************************/
/***************************************************************************************************************/
/***************************************************************************************************************/
/***************************************************************************************************************/
    header_w   = 3;
    header9_l  = 24 + cube_gap;//23.41;//26;
    header12_l = 31.03;//(2.54 * 12) + 0.25;//33;
    header_h = 10;
    plug_w   = header_w * 4;
    plug_e   = plug_w - header_w;
    tduino_w = 30 + cube_gap;
    tduino_l = 32 + cube_gap;
    tduino_h = 20;
    batt_l   = 20;
    batt_w   = 20;
    batt_h   = 4;
    tproc_h  = 4;
    
    my_wall  = 2;
    
    holder_l = (tduino_l + plug_e * 2) + my_wall;
    holder_w = (tduino_w + plug_e) + my_wall;
    holder_h = tduino_h + lego_h;
    
    bottom_pad = 4;
module t_holder(){

    
    difference(){
        cube_peg(holder_l, holder_w, holder_h);
        translate([0, plug_e/2 + my_wall/2, lego_h])
        cube_peg(tduino_l + cube_gap, tduino_w + cube_gap, tduino_h + batt_h);
        
        //Side headers
        translate([tduino_l/2 + header_w * 1.5, holder_w/2 - header9_l/2, lego_h + batt_h])
        cube_peg(header_w * 2, header9_l, holder_h);//header_h + header_w + bottom_pad);
        
        translate([-(tduino_l/2 + header_w * 1.5), holder_w/2 - header9_l/2, lego_h + batt_h])
        cube_peg(header_w * 2, header9_l, holder_h);//header_h + header_w + bottom_pad);
        //Back headers
        translate([0, -(tduino_w/2 + header_w * 1.5) + my_wall/2 + plug_e/2, lego_h + batt_h])
        cube_peg(header12_l, header_w * 2, holder_h);//header_h + header_w + bottom_pad);
        
        for(i = [-1:1]){
            for(j = [-1:1]){
                //Lego pegs
                translate([lego_h * i, lego_h * j + my_wall/2 + plug_e/2, 0])
                radial_peg(lego_r + radial_gap, lego_h * 4);
                 
            }
        }
        
        for(i = [-1,1]){
            for(j = [-1, 1]){
                //cutouts
                translate([(holder_l * 0.5 - my_wall * 0.5) * i, (holder_w * 0.5 - my_wall * 0.5) * j, 0])
                cube_peg(my_wall * 2, my_wall * 2, holder_h);
            }
        }
        
        
    }
    /*
    //Corner rounded poles
    for(i = [-1,1]){
        for(j = [1]){
            //cutouts
            translate([(holder_l * 0.5 - my_wall/2) * i, (holder_w * 0.5 - my_wall/2) * j, 0])
            radial_peg(my_wall/2, holder_h);
        }
    }*/
    //Rounded Front corners
    for(i = [-1,1]){
        for(j = [1]){
            //cutouts
            translate([(holder_l * 0.5 - lego_r) * i, (holder_w * 0.5 - lego_r) * j, 0])
            difference(){
                radial_peg(lego_r, holder_h);
                translate([-(lego_r + cube_gap) * i, -my_wall/2, holder_h/2 - (header_h - header_w/2)/2])
                cube_peg(header_w * 2, header_w * 2, holder_h);//header_h - header_w/2 + bottom_pad);
            }
        }
    }
    
    for(i = [-1,1]){
        for(j = [-1]){
            //cutouts
            translate([(holder_l * 0.5 - lego_r) * i, (holder_w * 0.5 - lego_r) * j, 0])
            radial_peg(lego_r, holder_h);
        }
    }
    
    //Side headers
    translate([tduino_l/2 + header_w * 1.5, header_w * 2 + my_wall/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
    cube_peg(header_w/2 - cube_gap, header_w * 9, bottom_pad + 4);
    
    translate([-(tduino_l/2 + header_w * 1.5), header_w * 2 + my_wall/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
    cube_peg(header_w/2 - cube_gap, header_w * 9, bottom_pad + 4);
    //Back headers
    translate([0, -(tduino_w/2 + header_w * 1.5) + my_wall/2 + plug_e/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
    cube_peg(header_w * 12, header_w/2 - cube_gap, bottom_pad + 4);
    //Front wall for headers
    translate([0, ((tduino_w + plug_e) + my_wall)/2, 0])
    difference(){
        cube_peg((tduino_l + plug_e * 2) - my_wall * 1.5, my_wall/2, tduino_h + lego_h);
        translate([0, 0, lego_h])
        cube_peg(tduino_l + cube_gap, my_wall, tduino_h + batt_h);
    }
    
    //Battery shelf
    translate([0, plug_e/2 + my_wall/2, -(tduino_h - 1)/2 + batt_h + lego_h]){
        /*difference(){
            cube_peg(tduino_l + cube_gap, tduino_w + cube_gap * 4, 1);
            cube_peg((tduino_l + cube_gap) - 2, (tduino_w + cube_gap) - 2, 1);
        }*/
        //Tiny Duino shelf
        translate([0, 0, tproc_h + 1.5])// Trying to adjust this so that the slide in shelf matches the
        //end height for the Tiny Duino of the previous shelf
        //cube_peg(tduino_l + cube_gap * 4, tduino_w + cube_gap * 4, 1);
        difference(){
            cube_peg(tduino_l + cube_gap, tduino_w + cube_gap * 4, 1);
            translate([0, 2, 0])
            cube_peg((tduino_l + cube_gap) - 2, (tduino_w + cube_gap) + 2, 1);
            //translate([0, 2, 0])
            //cube_peg((tduino_l + cube_gap) - 6, (tduino_w + cube_gap) - 2, 1);
        }
        
        translate([0, 0, tproc_h - 0.5])
        //cube_peg(tduino_l + cube_gap * 4, tduino_w + cube_gap * 4, 1);
        difference(){
            cube_peg(tduino_l + cube_gap, tduino_w + cube_gap * 4, 1);
            translate([0, 2, 0])
            cube_peg((tduino_l + cube_gap) - 2, (tduino_w + cube_gap) + 2, 1);
            translate([0, 2, 0])
            cube_peg((tduino_l + cube_gap) - 6, (tduino_w + cube_gap) - 2, 1);
        }
    }
    
}
/*
//Lego Frame
header_w = 2.5;
header_h = 10;
plug_w   = header_w * 4;
plug_e   = plug_w - header_w;
tduino_w = 30;
tduino_l = 32;
tduino_h = 20;
batt_l   = 20;
batt_w   = 20;
batt_h   = 4;
tproc_h  = 4;

my_wall  = 2;

holder_l = (tduino_l + plug_e * 2) + my_wall;
holder_w = (tduino_w + plug_e) + my_wall;
holder_h = tduino_h + lego_h;

frame_l  = holder_l + lego_h * 2;
frame_w  = holder_w + lego_h * 2;
frame_h  = holder_h + lego_h * 2;

rotate([0, 0, 90])
difference(){
    cube_peg(frame_l, frame_w, frame_h);
    translate([0, 0, lego_h * 0.5])
    cube_peg(holder_l + cube_gap, holder_w + cube_gap, holder_h + lego_h + cube_gap);
    
    for(s = [0,2]){
        for(i = [-2:2]){
            for(j = [-2:2]){
                rotate([0, 0, 90 * s])
                translate([(frame_l - lego_h) * 0.5, lego_h * i, lego_h * j])
                rotate([0, 90, 0])
                radial_peg(lego_r, lego_h);
            }
        }
    }
    
    for(s = [1,3]){
        for(i = [-2:2]){
            for(j = [-2:2]){
                rotate([0, 0, 90 * s])
                translate([(frame_w - lego_h) * 0.5, lego_h * i, lego_h * j])
                rotate([0, 90, 0])
                radial_peg(lego_r, lego_h + cube_gap);
            }
        }
    }
    
    for(i = [-2:2]){
        for(j = [-2:2]){
            translate([lego_h * j, lego_h * i, -(frame_h - lego_h) * 0.5])
            radial_peg(lego_r, lego_h + cube_gap);
        }
    }
}
*/
//translate([link_side/4, link_side/4, 0])
//frame(link_side);
//rotate([0, 0, 90])
//translate([0, 0, 21])
//t_holder();

//modular_fitec_mount();


fitec_wing_l = 33 + cube_gap;
fitec_wing_w = 12 + cube_gap;
fitec_wing_h = 3 + cube_gap;
fitec_base_l = 22 + cube_gap;
fitec_base_w = 12 + cube_gap;
fitec_base_h = 8 + cube_gap;//16 + cube_gap;
fitec_top_l  = 22 + cube_gap;
fitec_top_w  = 12 + cube_gap;
fitec_top_h  = 4 + cube_gap;
tiny_side    = 50.8;
tiny_h       = 2;
tiny_border  = 2;
fitec_h      = fitec_base_h + fitec_wing_h + fitec_top_h;
fitec_offset = 7;

module fitec_cutout(solo){
    translate([0, 0, -(fitec_base_h/2 + fitec_wing_h + fitec_top_h)/2 + fitec_base_h/4]){
        cube_peg(fitec_base_l, fitec_base_w, fitec_base_h * 2.5);
        translate([0, 0, fitec_base_h/2 + fitec_wing_h/2]){
            cube_peg(fitec_wing_l, fitec_wing_w, fitec_wing_h);
            translate([0, 0, fitec_wing_h/2 + fitec_top_h/2]){
                cube_peg(fitec_top_l, fitec_top_w, fitec_top_h);
                    translate([fitec_wing_l/2 - 2, 0, 0])
                radial_peg(2, fitec_top_h);
                translate([-(fitec_wing_l/2 - 2), 0, 0])
                radial_peg(2, fitec_top_h);
            }
            translate([fitec_wing_l/2 - 2, 0, 0])
            radial_peg(1, fitec_h);
            translate([-(fitec_wing_l/2 - 2), 0, 0])
            radial_peg(1, fitec_h);
        }
    }
    if(solo == 0){
        //Cable space can be subtracted out on either side... channel for sliding wire down.
        translate([0, 0, -fitec_top_h/2-cube_gap - fitec_wing_h/8])
        cube_peg(fitec_wing_l, 4, fitec_base_h * 2.5 + fitec_wing_h/2 - cube_gap/4);
    }
}

module color_mount(solo){
    //Color Sensor Mount
    color_length = 19;
    color_width   = 20.5;
    color_height = 2;
    color_trim   = 1;
    
    difference(){
        cube_peg(color_width + inner_wall, color_length + inner_wall, lego_h + color_height + color_trim);
        translate([0, inner_wall/2, lego_h/2 - color_trim])
        cube_peg(color_width + cube_gap, color_length + cube_gap + inner_wall/2, color_height);
        translate([0, inner_wall, lego_h/2 + color_height/2 - color_trim * 1])
        cube_peg(color_width - color_trim, color_length - color_trim, color_height + color_trim * 2);
        //translate([(color_side + inner_wall)/2, 0, 0])
        //cube_peg(inner_wall, color_side, color_side + lego_h);
        if(solo == 1){
            translate([0, lego_h * 0.5, -color_height/2])
            radial_peg(lego_r, lego_h + color_height/2);
            translate([0, lego_h * -0.5, -color_height/2])
            radial_peg(lego_r, lego_h + color_height/2);
        }
    }
}


/*
difference(){
    union(){
        scale([1, 1, fitec_base_w/lego_h])
        frame(tiny_side);
        cube_peg(tiny_side, tiny_side, fitec_base_w);
        
    }
    
    translate([0,  - (tiny_side/2 + cube_gap/2 - fitec_top_h), 0])
    rotate([90, 0, 0])
    fitec_cutout(1);
    
    mirror([0, 1, 0]){
        translate([0,  - (tiny_side/2 + cube_gap/2 - fitec_top_h), 0])
        rotate([90, 0, 0])
        fitec_cutout(1);
    }
}
*/

//Fitec Frame
//Hub should be 17 (?) mm shifted from center.  
/*
rotate([0, 180])
difference(){
    //Frame + center peg
    union(){
        scale([1, 1, (fitec_base_w + inner_wall)/lego_h])
        frame(tiny_side);
        cube_peg(tiny_side, tiny_side, fitec_base_w + inner_wall);
        
    }
    //Fitec cutouts
    translate([fitec_offset,  - (tiny_side/2 - cube_gap/2), - (inner_wall + cube_gap)/2])
    rotate([90, 0, 0])
    fitec_cutout(1);
    mirror([0, 1, 0]){
        translate([fitec_offset,  - (tiny_side/2 - cube_gap/2), - (inner_wall + cube_gap)/2])
        rotate([90, 0, 0])
        fitec_cutout(1);
    }
    
    //Wire hole
    radial_peg((tiny_side + lego_h * 2 - fitec_h * 2 + fitec_base_h)/2, fitec_base_w + inner_wall);
    
    //Stacking Peg Holes
    for(i = [-1, 1]){
        for(j = [-1, 1]){
            translate([(tiny_side/2 + lego_h/2) * i, (tiny_side/2 + lego_h/2) * j, 0])
            radial_peg(lego_r, lego_h * 5);
        }
    }
    
    //Mounting Peg Holes
    for(s = [-1, 1]){
        for(i = [-1.5:1.5]){
            for(j = [-3:3]){
                rotate([0, 0, 90 * s])
                translate([lego_h * j, tiny_side/2 + lego_h, lego_h * i])
                rotate([90, 0, 0])
                radial_peg(lego_r, lego_h * 2);
            }
        }
    }
}
*/

//Oct 11, 2016: Meld the jig and the top together into one piece.
module bus_jig(){
    //FULL TINY DUINO ASSEMBLY (PROTOTYPE AND JIG)....
    
    difference(){
        t_holder();
        translate([0, 0, -(4 + 1 + (header_w + 1.5))])
        cube_peg(60, 60, 20);
    
        union(){
            
            translate([(tduino_l/2 + header_w * 1.35) + (header_w * 0.5 + cube_gap * 1.25), 0, holder_h/2])
            cube_peg((header_w * 1.5 + cube_gap)/2, tduino_l, tduino_h);
            translate([(tduino_l/2 + header_w * 1.65) - (header_w * 0.5 + cube_gap * 1.25), plug_w/4 + cube_gap * 0.5 - header_w * 0.6, holder_h/2])
            cube_peg((header_w * 1.5 + cube_gap)/2, tduino_l + header_w, tduino_h);
            
            mirror([1, 0, 0]){
                translate([(tduino_l/2 + header_w * 1.35) + (header_w * 0.5 + cube_gap * 1.25), 0, holder_h/2])
                cube_peg((header_w * 1.5 + cube_gap)/2, tduino_l, tduino_h);
                translate([(tduino_l/2 + header_w * 1.65) - (header_w * 0.5 + cube_gap * 1.25), plug_w/4 + cube_gap * 0.5 - header_w * 0.6, holder_h/2])
                cube_peg((header_w * 1.5 + cube_gap)/2, tduino_l + header_w, tduino_h);
            }
            
            translate([0, -(tduino_w/2 + header_w * 1.5) + my_wall/2 + plug_e/2 + (header_w * 0.5 + cube_gap * 1.25), lego_h + batt_h - header_h/2])
            cube_peg(tduino_w + plug_e/2 + cube_gap * 2, (header_w * 2 + cube_gap)/2, tduino_h); 
            translate([0, -(tduino_w/2 + header_w * 1.5) + my_wall/2 + plug_e/2 - (header_w * 0.5 + cube_gap * 1.25), lego_h + batt_h - header_h/2])
            cube_peg(tduino_w + plug_e * 2 - cube_gap * 2, (header_w * 2 + cube_gap)/2, tduino_h); 
        }
        
        
        
    }
    /*
    //Rear "connective tissue"
    for(i = [-1,1]){
        for(j = [-1]){
            //cutouts
            translate([(holder_l * 0.5 - lego_r) * i, ((holder_w - (holder_w - my_wall - header9_l) - my_wall * 2) * 0.5) * j, tduino_h/4 - (header_w + 1.5) * 0.50]){
                translate([(header_w + cube_gap) * -i, 0, -0.25])
                cube_peg(header_w * 2.5, holder_w - my_wall - header9_l, header_w + 1);
                
            }
        }
    }*/
    //....FULL TINY DUINO ASSEMBLY (PROTOTYPE AND JIG)
}

module jig_negative(){
    difference(){
        union(){
            difference(){
                cube_peg(holder_l + cube_gap, holder_w + cube_gap, holder_h + cube_gap);
                        
                for(i = [-1,1]){
                    for(j = [-1, 1]){
                        //cutouts
                        translate([((holder_l + cube_gap) * 0.5 - my_wall * 0.5) * i, ((holder_w + cube_gap) * 0.5 - my_wall * 0.5) * j, 0])
                        cube_peg(my_wall * 2, my_wall * 2, holder_h + cube_gap);
                    }
                }
                
                
            }
                
                
            //Rounded Front corners
            for(i = [-1,1]){
                for(j = [1]){
                    //cutouts
                    translate([(holder_l * 0.5 - lego_r) * i, (holder_w * 0.5 - lego_r) * j, 0])
                    union(){
                        radial_peg(lego_r + radial_gap, holder_h + cube_gap);
                        //translate([-(lego_r + cube_gap) * i, -my_wall/2, holder_h/2 - (header_h - header_w/2)/2])
                        //cube_peg(header_w * 2, header_w * 2, holder_h);//header_h - header_w/2 + bottom_pad);
                    }
                }
            }
            
            for(i = [-1,1]){
                for(j = [-1]){
                    //cutouts
                    translate([(holder_l * 0.5 - lego_r) * i, (holder_w * 0.5 - lego_r) * j, 0])
                    radial_peg(lego_r + radial_gap, holder_h + cube_gap);
                }
            }
        }
        translate([0, 0, -(4 + 1 + (header_w + 1.5))])
        cube_peg(60, 60, 20);
    }
}

module tiny_top(){
    //Oct 5: Tiny Duino Top
    difference(){
        scale([1, 1, 5])
        union(){
            frame(tiny_side);
            cube_peg(tiny_side, tiny_side, lego_h);
        }
        //Shelf
        translate([0, 0, lego_h - tiny_h])
        jig_negative();
        //bus_jig();
        //translate([0, tiny_border * 2, lego_h])
        //cube_peg(tiny_side + cube_gap, tiny_side + lego_h + tiny_border + cube_gap, tiny_h + cube_gap);
        
        translate([0, lego_h/2 - cube_gap/2 + tiny_border, 0])
        cube_peg(tiny_side + cube_gap - tiny_border * 2, tiny_side + lego_h + cube_gap - tiny_border, lego_h);
        
        translate([0, tiny_border * 2 + cube_gap * 2, (tiny_h * 8)/2])
        cube_peg(tiny_side + cube_gap - tiny_border * 2, tiny_side + lego_h + cube_gap - tiny_border, lego_h * 3);
        cube_peg(tiny_side + cube_gap - tiny_border * 2, tiny_side + cube_gap - tiny_border * 2, lego_h * 5);
        
        for(i = [-1, 1]){
            for(j = [-1, 1]){
                translate([(tiny_side/2 + lego_h/2) * i, (tiny_side/2 + lego_h/2) * j, 0])
                radial_peg(lego_r, lego_h * 5);
            }
        }
        
        for(s = [2:4]){
            for(i = [-2:2]){
                for(j = [-3:3]){
                    rotate([0, 0, 90 * s])
                    translate([tiny_side/2 + lego_h/2, lego_h * j, lego_h * i])
                    rotate([0, 90, 0])
                    radial_peg(lego_r, lego_h * 1);
                }
            }
        }
        
        for(i = [-2, -1]){
            for(j = [-3:3]){
                rotate([0, 0, 90])
                translate([tiny_side/2 + lego_h/2, lego_h * j, lego_h * i])
                rotate([0, 90, 0])
                radial_peg(lego_r, lego_h * 1);
            }
        }   
    }
    
    
}


//Do a better cutout of the jig....  Make sure there is cube_gap space.
//tiny_top();
//translate([0, -10, lego_h - tiny_h])
//bus_jig();

insert_w = header_w/2 - cube_gap;
insert_h = 3.3;
pin_w = 0.4 + cube_gap;

module ground_headers(){
    //Side headers
    translate([tduino_l/2 + header_w *1.5 + insert_w * 1.75, header_w * 0.4 + my_wall/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
    cube_peg(header_w - cube_gap * 2, header_w * 12 - cube_gap, insert_h);

    mirror([1, 0, 0]){
        translate([tduino_l/2 + header_w *1.5 + insert_w * 1.75, header_w * 0.4 + my_wall/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
        cube_peg(header_w - cube_gap * 2, header_w * 12 - cube_gap, insert_h);
    }
    
    //Back headers
    translate([0, -(tduino_w/2 + header_w * 1.5 + insert_w * 1.75) + my_wall/2 + plug_e/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
    cube_peg(header_w * 16 - cube_gap * 2, header_w - cube_gap * 2, insert_h);
}

module ground_header_caps(){
    difference(){
        ground_headers();
        //Side headers
        translate([tduino_l/2 + header_w *1.5 + insert_w * 1.75, header_w * 2.4 + my_wall/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
        rotate([0, 0, 90])
        pin_negative_9();//cube_peg(pin_w, header_w * 9 - cube_gap, insert_h);
    
        mirror([1, 0, 0]){
            translate([tduino_l/2 + header_w *1.5 + insert_w * 1.75, header_w * 2.4 + my_wall/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
            rotate([0, 0, 90])
            pin_negative_9();//cube_peg(pin_w, header_w * 9 - cube_gap, insert_h);
        }
        
        //Back headers
        translate([0, -(tduino_w/2 + header_w * 1.5 + insert_w * 1.75) + my_wall/2 + plug_e/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
        pin_negative_12();//cube_peg(header_w * 12 - cube_gap * 2, pin_w, insert_h);
    }
}

module ground_header_floor(){
    //Side headers
    translate([tduino_l/2 + header_w *1.5 + insert_w * 1.75, header_w * 0.4 + my_wall/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
    cube_peg(header_w - cube_gap * 2, header_w * 12 - cube_gap, insert_h);

    mirror([1, 0, 0]){
        translate([tduino_l/2 + header_w *1.5 + insert_w * 1.75, header_w * 0.4 + my_wall/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
        cube_peg(header_w - cube_gap * 2, header_w * 12 - cube_gap, insert_h);
    }
    
    //Back headers
    translate([0, -(tduino_w/2 + header_w * 1.5 + insert_w * 1.75) + my_wall/2 + plug_e/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
    cube_peg(header_w * 16 - cube_gap * 2, header_w - cube_gap * 2, insert_h);
}
/*******************************************************************/
module power_headers(){
    
    //Side headers
    translate([tduino_l/2 + header_w *1.5 - insert_w * 1.75, header_w * 0.9 + my_wall/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
    cube_peg(header_w - cube_gap * 2, header_w * 11 - cube_gap, insert_h);

    mirror([1, 0, 0]){
        translate([tduino_l/2 + header_w *1.5 - insert_w * 1.75, header_w * 0.9 + my_wall/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
        cube_peg(header_w - cube_gap * 2, header_w * 11 - cube_gap, insert_h);
    }
    
    //Back headers
    translate([0, -(tduino_w/2 + header_w * 1.5 - insert_w * 1.75) + my_wall/2 + plug_e/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
    cube_peg(header_w * 13.65 - cube_gap * 2, header_w - cube_gap * 2, insert_h);
}

module power_header_caps(){
    difference(){
        power_headers();
        //Side headers
        translate([tduino_l/2 + header_w *1.5 - insert_w * 1.75,               header_w * 2.4 + my_wall/2, 
                   (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
        rotate([0, 0, 90])
        pin_negative_9();//cube_peg(pin_w, header_w * 9 - cube_gap, insert_h);
    
        mirror([1, 0, 0]){
            translate([tduino_l/2 + header_w *1.5 - insert_w * 1.75, header_w * 2.4 + my_wall/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
            rotate([0, 0, 90])
        pin_negative_9();//cube_peg(pin_w, header_w * 9 - cube_gap, insert_h);
        }
        
        //Back headers
        translate([0, -(tduino_w/2 + header_w * 1.5 - insert_w * 1.75) + my_wall/2 + plug_e/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
        pin_negative_12();//cube_peg(header_w * 12 - cube_gap * 2, pin_w, insert_h);
    }
}

module power_header_floor(){
    
    //Side headers
    translate([tduino_l/2 + header_w *1.5 - insert_w * 1.75, header_w * 0.9 + my_wall/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
    cube_peg(header_w - cube_gap * 2, header_w * 11 - cube_gap, insert_h);

    mirror([1, 0, 0]){
        translate([tduino_l/2 + header_w *1.5 - insert_w * 1.75, header_w * 0.9 + my_wall/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
        cube_peg(header_w - cube_gap * 2, header_w * 11 - cube_gap, insert_h);
    }
    
    //Back headers
    translate([0, -(tduino_w/2 + header_w * 1.5 - insert_w * 1.75) + my_wall/2 + plug_e/2, (-(tduino_h - 1)/2 + batt_h + lego_h) + tproc_h - 3])
    cube_peg(header_w * 13.65 - cube_gap * 2, header_w - cube_gap * 2, insert_h);
}
/*
module side_gaps(){
    filler_x = 1.5;
    filler_y = 1;
    span = 3;
    for (i = [0:7]){
        translate([0, span * i, insert_h * 1.5 + cube_gap * 0.4])
        cube_peg(filler_x, filler_y, insert_h * 2);
    }
}

module rear_gaps(){
    filler_x = 1.5;
    filler_y = 1;
    span = 3;
    rotate([0, 0, 90])
    for (i = [-5:5]){
        translate([0, span * i, insert_h * 1.5 + cube_gap * 0.4])
        cube_peg(filler_x, filler_y, insert_h * 2);
    }
}
*/
module pin_negative_12(){
    pin_x   = 1 + cube_gap;
    pin_y   = 1 + cube_gap;
    pin_z   = 3.5;
    pin_gap = 2.54;
    
    for (i = [-6:5]){
        translate([pin_gap * i + pin_gap * 0.5, 0, 0])
        cube_peg(pin_x, pin_y, insert_h * 2);
    }
}
module pin_negative_9(){
    pin_x   = 1 + cube_gap;
    pin_y   = 1 + cube_gap;
    pin_z   = 3.5;
    pin_gap = 2.54;
    
    for (i = [-4:4]){
        translate([pin_gap * i, 0, 0])
        cube_peg(pin_x, pin_y, insert_h * 2);
    }
}

/*

difference(){
    union(){
        ground_header_caps();
        translate([0, 0, insert_h])
        ground_header_floor();
    }
    translate([-header_w * 7.5 + cube_gap * 1, -header_w * 3.5, insert_h * 1.5 + cube_gap * 0.25])
    cube_peg(header_w * 0.5, header_w * 3, insert_h * 2 + cube_gap);
    
    translate([header_w * 7.5 - cube_gap * 1, -header_w * 3.5, insert_h * 1.5 + cube_gap * 0.25])
    cube_peg(header_w * 0.5, header_w * 3, insert_h * 2 + cube_gap);
}
difference(){
    union(){
        power_header_caps();
        translate([0, 0, insert_h])
        power_header_floor();
    }
    
    translate([-header_w * 6.5, -header_w * 3.5, insert_h * 1.5 + cube_gap * 0.25])
    cube_peg(header_w * 0.5, header_w * 2.5, insert_h * 2 + cube_gap);
    
    translate([header_w * 6.5, -header_w * 3.5, insert_h * 1.5 + cube_gap * 0.25])
    cube_peg(header_w * 0.5, header_w * 2.5, insert_h * 2 + cube_gap);
}
*/

/*
translate([header_w * 6.35, -header_w, 0])
side_gaps();
translate([-header_w * 6.35, -header_w, 0])
side_gaps();

translate([header_w * 7.5, -header_w, 0])
side_gaps();
translate([-header_w * 7.5, -header_w, 0])
side_gaps();

translate([0, -header_w * 4.25, 0])
rear_gaps();

translate([0, -header_w * 5.25, 0])
rear_gaps();
*/

//jig_negative();
//for(f = [0:2]){
//    translate([0, 0, f * lego_h])
//    frame(lego_h * 7);
//}
radius    = lego_h * 3/2;
sides     = 4;
mod_h     = lego_h * 3;
module polyShape(solid, rad){
    difference(){
         // Solid outside shape
        offset( r=6, $fn = precision )
        circle( r=rad, $fn=sides );
        
        // Hollow inside shape
        if( solid == "no"){
            offset( r=6-mod_h, $fn = 48 )
            circle( r=rad, $fn=sides );
        }
    }
}

module lego_3x3(){
    for(i = [-1:1]){
        for(j = [-1:1]){
            translate([lego_h * i, lego_h * j])
            radial_peg(lego_r, lego_h);
        }
    }
}

module lego_3x2(){
    for(i = [-1:1]){
        for(j = [0:1]){
            translate([lego_h * i, lego_h * j])
            radial_peg(lego_r, lego_h);
        }
    }
}

module base_struct(){
    side_l = lego_h * 3 + lego_r;
    rounded_offset = 0.25;
    
    difference(){
        union(){
            difference(){
                cube_peg(side_l, side_l, side_l);
                
                
                        
                for(i = [-1,1]){
                    for(j = [-1, 1]){
                        //cutouts
                        translate([((side_l + cube_gap) * 0.5 - my_wall * 0.5) * i, ((side_l + cube_gap) * 0.5 - my_wall * 0.5) * j, 0])
                        cube_peg(my_wall * 2, my_wall * 2, side_l + cube_gap);
                        
                        for(k = [-1,1]){
                            translate([((side_l + cube_gap) * 0.5 - my_wall * 0.5) * i, ((side_l + cube_gap) * 0.5 - my_wall * 0.5) * 0, ((side_l + cube_gap) * 0.5 - my_wall * 0.5) * k])
                            rotate([90, 0, 0])
                            cube_peg(my_wall * 2, my_wall * 2, side_l + cube_gap);
                            translate([((side_l + cube_gap) * 0.5 - my_wall * 0.5) * 0, ((side_l + cube_gap) * 0.5 - my_wall * 0.5) * j, ((side_l + cube_gap) * 0.5 - my_wall * 0.5) * k])
                            rotate([0, 90, 0])
                            cube_peg(my_wall * 2, my_wall * 2, side_l + cube_gap);
                        }
                        
                    }
                }
                
                
            }
                
                
            //Rounded Front corners
            for(i = [-1,1]){
                for(j = [1]){
                    //cutouts
                    translate([(side_l * 0.5 - lego_r) * i, (side_l * 0.5 - lego_r) * j, 0])
                    union(){
                        radial_peg(lego_r + radial_gap, side_l - lego_h + cube_gap);
                        //translate([-(lego_r + cube_gap) * i, -my_wall/2, holder_h/2 - (header_h - header_w/2)/2])
                        //cube_peg(header_w * 2, header_w * 2, holder_h);//header_h - header_w/2 + bottom_pad);
                    }
                    
                }
            }
            for(i = [-1,1]){
                for(j = [-1, 1]){
                    
                    for(k = [-1,1]){
                            translate([(side_l * 0.5 - lego_r) * i, 0, (side_l * 0.5 - lego_r) * k])
                            rotate([90, 0, 0])
                            radial_peg(lego_r + radial_gap, side_l - lego_h + cube_gap);
                            translate([0, (side_l * 0.5 - lego_r) * j, (side_l * 0.5 - lego_r) * k])
                            rotate([0, 90, 0])
                            radial_peg(lego_r + radial_gap, side_l - lego_h + cube_gap);
                        
                        translate([(side_l * 0.5 - lego_r) * i, (side_l * 0.5 - lego_r) * j, (side_l * 0.5 - lego_r) * k])
                        sphere(lego_r + radial_gap, $fn = precision, center = true);
                    }
                }
            }
            
            for(i = [-1,1]){
                for(j = [-1]){
                    //cutouts
                    translate([(side_l * 0.5 - lego_r) * i, (side_l * 0.5 - lego_r) * j, 0])
                    radial_peg(lego_r + radial_gap, side_l - lego_h + cube_gap);
                }
            }
        }
    
    }
}

module mech_struct(){
    difference(){
        base_struct();
        //Holes for lego pegs
        for(theta = [-1, 0, 1])
        {
            for(i = [-1, 1]){
                rotate([90 * theta, 0, 0])
                translate([0, 0, (lego_h + lego_r * 0.6) * i])
                lego_3x3();
                rotate([0, 90 * theta, 0])
                translate([0, 0, (lego_h + lego_r * 0.6)  * i])
                lego_3x3();
            }
        }
    }
}

module base_app_struct(){
    difference(){
        base_struct();
        //Holes for lego pegs
        for(theta = [-1])
        {
            for(i = [-1, 1]){
                rotate([90 * theta, 0, 0])
                translate([0, 0, (lego_h + lego_r * 0.6) * i])
                lego_3x2();
                rotate([0, 90 * theta, 0])
                rotate([0, 0, 90])
                translate([0, 0, (lego_h + lego_r * 0.6)  * i])
                lego_3x2();
            }
        }
        translate([0, 0, -(lego_h + lego_r * 0.6)])
        lego_3x3();
    }
    
}

module rgb_struct(){
    difference(){
        base_app_struct();
        translate([0, 3, lego_h * 2])
        cube_peg(lego_h * 3, lego_h * 3, lego_h * 3);
    }
    translate([0, 0, lego_h* 1.0])
    color_mount(0);
}

module fitec_struct(){
    difference(){
        base_app_struct();
        translate([0, 0, lego_h * 1.22])
        fitec_cutout(0);
    }
}

module dIR_struct(){
    dIR_length = 22 + cube_gap;
    dIR_width  = 9  + cube_gap;
    dIR_h      = 2  + cube_gap;
    dIR_side   = 2;
    dIR_top    = 5;
    dIR_height = 3.5;
    dIR_header = 3;
    dIR_side   = 1;
    difference(){
        base_app_struct();
        translate([0, 0, (lego_h * 1.70) - dIR_h])
        cube_peg(lego_h * 3.5, dIR_width + inner_wall, dIR_h * 2);
    }
    translate([0, 0, (lego_h * 1.7) - dIR_h])
    mount_dIR();
    
}
/*
color_block = 38;
block_side = lego_h * 3 + lego_r;
cube_peg(color_block, color_block, color_block);

color("blue")
translate([block_side/2 + color_block/2, block_side/2, -color_block/2 + block_side/2])
base_struct();
color("yellow")
translate([block_side/2 + color_block/2, block_side/2, color_block/2 + 3])
base_struct();

color("blue")
translate([-(block_side/2 + color_block/2), block_side/2, -color_block/2 + block_side/2])
base_struct();
color("yellow")
translate([-(block_side/2 + color_block/2), block_side/2, color_block/2 + 3])
base_struct();

color("red")
translate([-(block_side/2 + color_block/2), block_side * 1.5, -color_block/2 + block_side/2])
base_struct();
color("red")
translate([block_side/2 + color_block/2, block_side * 1.5, -color_block/2 + block_side/2])
base_struct();
color("blue")
translate([0, block_side * 1.5, -color_block/2 + block_side/2])
base_struct();

color("black")
translate([-(block_side/2 + color_block/2), block_side * 2.5, -color_block/2 + block_side/2])
base_struct();
color("black")
translate([block_side/2 + color_block/2, block_side * 2.5, -color_block/2 + block_side/2])
base_struct();

color("yellow")
translate([-(block_side/2 + color_block/2), block_side * 3.5, -color_block/2 + block_side/2])
base_struct();
color("yellow")
translate([block_side/2 + color_block/2, block_side * 3.5, -color_block/2 + block_side/2])
base_struct();
color("yellow")
translate([-(block_side/2 + color_block/2), block_side * 3.5, color_block/2 + 3])
base_struct();
color("yellow")
translate([block_side/2 + color_block/2, block_side * 3.5, color_block/2 + 3])
base_struct();
color("yellow")
translate([0, block_side * 3.5, -color_block/2 + block_side/2])
base_struct();

color("yellow")
translate([-(block_side/2 + color_block/2), block_side * 1.5, color_block/2 + 3])
base_struct();
color("yellow")
translate([block_side/2 + color_block/2, block_side * 1.5, color_block/2 + 3])
base_struct();
*/
bus_jig();
tiny_top();

translate([tiny_side -lego_h*0.25, 0, 0])
rotate([0, 90, 0])
fitec_struct();
mirror([1, 0, 0]){
    translate([tiny_side -lego_h*0.25, 0, 0])
    rotate([0, 90, 0])
    fitec_struct();
}

translate([0, -(tiny_side - lego_h * 0.25), 0]){
    rotate([180, 0, 0])
    rgb_struct();
    
    for(i = [-1, 1]){
        translate([lego_h * 3.5 * i, 0, 0])
        rotate([180, 0, 0])
        dIR_struct();
    }
}
//color_mount(1);
//mech_struct();
//Base module for block L-system
//base_struct();
//dIR_struct();
//translate([lego_h * 5, 0, 0])
//rgb_struct();
//translate([-lego_h * 5, 0, 0])
//fitec_struct();
//base_app_struct();
//translate([0, lego_h * 0, lego_h * 1.2])
//fitec_cutout();
//Recreate "jig_negative", but with everything rounded.

/*
difference(){
    for(f = [0:2]){
        translate([0, 0, f * lego_h])
        frame(lego_h * 3);
    }
    translate([0, lego_h * 0, lego_h * 2.1])
    fitec_cutout();
}*/
/*
servo_l = 23.2;
servo_w = 12.5;
servo_h = 22;

rotate([90, 0, 0])
translate([0, 0, (servo_h * 0.5 + lego_h * 0.5)])
cube_peg(servo_l, servo_w, servo_h);
rotate([90, 0, 0])
translate([0, 0, -(servo_h * 0.5 + lego_h * 0.5)])
cube_peg(servo_l, servo_w, servo_h);
*/
/*
//Question Box/Item Box
question_r = 5;
question_h = 2;
difference(){
    union(){
        difference(){
            rotate([0, 0, 30])
            cylinder(r = question_r, h = question_h, $fn = 6, center = true);
            translate([question_r * 0.5, 0, 0])
            cube_peg(question_r, question_r * 2, question_h);
            
            
        }
         
        translate([question_r * 0.25, 0, 0])
        scale([0.5, 1.15, 1])
        cylinder(r = question_r, h = question_h, $fn = 3, center = true);
        translate([question_r * 0.75, 0, 0])
        cube_peg(question_r * 0.75, question_r * 0.5, question_h);
    }
    rotate([0, 0, -30])
    translate([question_r * 0.35, -question_r * 0.25, 0])
    cube_peg(question_r, question_h * 0.75, question_h);
    translate([-question_h * 0.35, 0, 0])
    cube_peg(question_h * 1.0, question_h * 1.40, question_h);
    
    translate([question_r - question_h * 0.55, 0, 0])
    cube_peg(question_h * 0.25, question_h, question_h);
}
*/
/*
//21 Sept Bumper Design
difference(){
    bumper_scaffold();   
    
    for(i = [-1.5, -0.5, 0.5, 1.5]){
        for(j = [-8:8]){
            translate([lego_h * j, 0, lego_h * i])
            rotate([90, 0, 0])
            radial_peg(lego_r, lego_h * 2);
        }
    }
    
   // translate([lego_h * 11, 0,0])
    //cube_peg(lego_h * 22, lego_h * 11, lego_h * 4);
}*/
/*
//15 Sept, 2016: Flux Pedestal
translate([0, 0, -lego_h * 2 - inner_wall/2])
rotate([0, 0, 180])
scale([1, 1, 2])
difference(){
    for(l = [-1:1]){
        rotate([0, 0, 120 * l])
        translate([0,(link_side - lego_h * 2 - lego_r)/4, 0])
        difference(){
            cube_peg(lego_h * 2, (link_side - lego_h)/2, lego_h);
            translate([0, lego_h, 0])
            radial_peg(lego_r, lego_h);
            translate([0, -lego_h, 0])
            radial_peg(lego_r, lego_h);
        }
    }
    
    frame(link_side - lego_h * 4 - lego_r + cube_gap);
}*/
/*
//Arduino Tray
arduino_length = 101.98 + cube_gap;
arduino_width  = 53.63 + cube_gap;
arduino_height = 15.29 + cube_gap;

//translate([0, 0, lego_h/2 + (inner_wall * 1.5)/2])
rotate([0, 0, 90])
difference(){
    union(){
        cube_lip(arduino_length + inner_wall, arduino_length, arduino_width + inner_wall, arduino_width, inner_wall);
        translate([0, 0, -(lego_h + inner_wall)/2])
        cube_peg(arduino_length + inner_wall, arduino_width + inner_wall, lego_h);
    }
    
    for(l = [-1:1]){
        rotate([0, 0, 90 + 120 * l])
        translate([0,(link_side - lego_h * 2 - lego_r)/4, -(lego_h + inner_wall)/2])
        union(){
            //cube_peg(lego_h * 2, (link_side - lego_h)/2, lego_h);
            translate([0, lego_h, 0])
            radial_peg(lego_r, lego_h);
            translate([0, -lego_h, 0])
            radial_peg(lego_r, lego_h);
        }
    }
}*/
/*
//Cross Section of Platform/Frame
translate([0, 0, lego_h])
frame(frame_side - lego_h * 3 - lego_r);
difference(){
    cube_peg(frame_side, frame_side, lego_h);
    for(i = [0, 2]){
        for(j = [-4.5,-2.5,2.5,4.5]){
            rotate([0, 0, 90 * i])
            translate([(link_side - lego_h * 2 - lego_r)/2, lego_h *j, 0])
            radial_peg(lego_r, lego_h * 3);
            //cube_peg(lego_h, link_side, lego_h);
        }
    }
    
    for(i = [1, 3]){
        for(j = [-4.5,-2.5,2.5,4.5]){
            rotate([0, 0, 90 * i])
            translate([(link_side - lego_h * 2 - lego_r)/2, lego_h * j, 0])
            radial_peg(lego_r, lego_h * 3);
            
            //cube_peg(lego_h, link_side, lego_h);
        }
    }
}
*/
