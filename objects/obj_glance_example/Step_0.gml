var _t = sin(current_time*0.001)*100;

//follow target
camera.x = _t;
camera.y = _t;

//screenshake
camera.offsetBy(random_range(-10,10),random_range(-10,10));

//zoom
camera.zoom = sin(current_time*0.001)+2;