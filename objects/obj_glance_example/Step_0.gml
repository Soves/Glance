var _t = sin(current_time*0.001)*100;

//follow target
glc_CameraSetTarget(_t, _t);

//screenshake
glc_CameraSetOffset(random_range(-10,10),random_range(-10,10));

//zoom
glc_CameraSetZoom(sin(current_time*0.001)+2);