precision      = 200;

radial_gap     = 0.25 * 1;
cube_gap       = 0.5 * 1;

wall_thickness = 4;
inner_wall = 4;
/******************************************/
/******************************************/
/******************************************/
//caster_housing 
caster_bolt_radius   = 4.5;
caster_bolt_length   = 26;
caster_nut_radius     = 15/2;
caster_nut_height    = 7;


//Link measurements
link_side             = 107;
link_height           = 25;//43;//25 is height up to seam, which would leave ports exposed
bracket_buffer = 1 + cube_gap;
wall_height = caster_nut_height + inner_wall + cube_gap;

link_height2          = 20;
link_vent             = 70;
inner_wall_depth      = 2;
bucky_cube_side       = 5;
bucky_buffer          = 2;
bucky_cylinder_radius = 2;
bucky_cylinder_height = 48;
bucky_plug_depth      = bucky_cube_side + bucky_buffer * 2 + 35;


chassis_hypotenuse = sqrt(pow(link_side + inner_wall, 2) + pow(link_side + inner_wall, 2))/2;

motor_mount_width     = 25;
motor_mount_height    = 19;
motor_mount_thickness = 1.5;
screw_separation      = 12;//12mm apart.  So 6mm each from the center
screw_inset           = 10;//10mm from the outer edge of the mount into the center of the screw hole
screw_bottom_radius   = 2; //2mm for the radius of the bottom of the screw
screw_top_radius      = 4; //4mm radius for the flat head
wire_allowance        = 10;
mount_to_end          = 23.5 + wire_allowance;
motor_mount_thickness = motor_mount_depth * 2;

washer_radius = 12.5;
washer_height = 4;
caster_height = caster_bolt_length + inner_wall;// + caster_nut_height + washer_height*2 + inner_wall;
caster_side   = washer_radius * 2 + inner_wall * 2; 
bracket_clearance = 13 + 2.5;
//link_box
lego_r                = 2.5;
lego_h                = 8;
box_side = lego_h * 16;//link_side + cube_gap + inner_wall;
box_height = link_height + cube_gap;// + inner_wall;

magnet_side   = bucky_cube_side * 2 + cube_gap;
magnet_height = bucky_cube_side + cube_gap;
box_h = inner_wall + box_height;// + magnet_height + bucky_buffer



/***************************************************************************************************/
/***************************************************************************************************/
/***************************************************************************************************/
deck_height  = bucky_cube_side * 3 + inner_wall;//This allows for a floor, bucky cubes, and two bucky cubes' worth of
                                              //space for a plug
socket_side  = bucky_cube_side * 2 + cube_gap;//The side of a square plug (socket) for sensors.  The plug will leave out the
                                             //cube_gap component
socket_depth = bucky_cube_side * 3 + cube_gap;//The depth of a sensor plug socket
band_width   = (socket_side + inner_wall * 2);//The space needed to insert sensor plugs
//link_z       = link_height + link_height2 + cube_gap + inner_wall + (motor_mount_length + cube_gap);
 
link_bracket_side = link_side + (inner_wall * 4) + cube_gap + socket_depth * 2;
link_bracket_height = link_height + link_height2 + cube_gap + (inner_wall * 2);
link_bracket_depth = (socket_side + motor_mount_width)/2 + inner_wall; 
link_h = link_height + link_height2 + inner_wall + cube_gap;




/***************************************************************************************************/

sensor_length = 46;
sensor_width  = 14;
sensor_height = 14;
plug_length   = 10;
plug_width    = 8;
plug_height   = 6;

insert_length = 1;
/***************************************************************************************************/
mount_key_side = inner_wall * 2 - cube_gap;
mount_key_height = inner_wall;
mount_base_radius = screw_top_radius;//7;
/***************************************************************************************************/
botball_radius = 179/2;
camera_clearance = 4;//Try this as 3, but to do so other changes must occur.
caster_offset_angle = 0;
caster_offset_radius = botball_radius - 13;
mount_offset_angle = 45;
mount_offset_radius = 70;
cutout_width = 75;
cutout_length = (botball_radius + 10) * 2;
deck_height = 2;
bumper_top_height = 21/2;//15
bumper_bottom_height = 21/2;//deck_height * 2;
hole_radius = 2.5;
unit_height = bumper_top_height + bumper_bottom_height;


/**************** FROM SENSOR_MOUNTS.SCAD *********************/
motor_mount_width     = 25.5;
motor_mount_length    = 19;
motor_mount_depth     = 2.5;
screw_separation      = 12;//12mm apart.  So 6mm each from the center
screw_inset           = 10;//10mm from the outer edge of the mount into the center of the screw hole
screw_bottom_radius   = 2; //2mm for the radius of the bottom of the screw
screw_top_radius      = 4; //4mm radius for the flat head
wire_allowance        = 10;
mount_to_end          = 23.5 + wire_allowance;
motor_mount_thickness = 3;//motor_mount_depth * 2;

/***************************************************************************************************/
//caster_housing 
caster_bolt_radius   = 4.5;
caster_bolt_length   = 26;
caster_nut_radius     = 15/2;
caster_nut_height    = 7;
caster_height = caster_bolt_length + inner_wall;// + caster_nut_height + washer_height*2 + inner_wall;
/***************************************************************************************************/
mount_key_side = inner_wall * 2 - cube_gap;
mount_key_height = inner_wall;
mount_base_radius = screw_top_radius + inner_wall;
/*************** FROM MAIN PROG **********************/
new_deck_height = 6;

motor_frame_width   = (lego_h * 3 - lego_r)/2;
frame_side          = link_side + lego_h * 2; 

servo_mount_height  = 22;
servo_mount_width   = 25;
