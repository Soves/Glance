//----------GLANCE----------//
/*
	window and camera management 
	library for GameMaker Studio 2

	Made By: @soVesDev
	
*/

////MACROS////
#macro GLC_HORIZONTAL 0
#macro GLC_VERTICAL 1
#macro GLC_NONE -4

#macro GLC_ROUND_N 0

////GLOBAL////
Glance = {
	window : undefined,
	camera : undefined,
	display : {
		width : display_get_width(),
		height : display_get_height()
	}
};


////PRIVATE////

function _glc_round_n(value,multiple){
	return (round(value/multiple)*multiple);
}

function _glc_validate(value, def){
	return value == undefined ? def : value;
}

function _glc_option(object, key, def){
	return _glc_validate(variable_struct_get(object,key), def);
}


function _glc_UpdateWindow(window){
	
	var _w = window.width;
	var _h = window.height;
	
	if window.scalingMode == GLC_HORIZONTAL{
		_w = glc_AspectWidth( _h, window.aspectRatio);
	}else if window.scalingMode == GLC_VERTICAL{
		_h = glc_AspectHeight( _w, window.aspectRatio);		
	}
	
	window.width = _w;
	window.height = _h;
	
	if window == glc_GetWindow(){
		window_set_fullscreen(window.fullscreen);
		window_set_size( _w, _h);
	}
}
function _glc_UpdateCamera(camera){
	
	with camera{
		
		x = interpolate(x, targetX);
		y = interpolate(y, targetY);

		x = glc_CameraGetRounded_ext(camera, x);
		y = glc_CameraGetRounded_ext(camera, y);
		z = glc_CameraGetRounded_ext(camera, z);
	
		var _w = width;
		var _h = height;
	
		if strict{
			zoom = _glc_round_n( zoom, 1);
		}
	
		if scalingMode == GLC_HORIZONTAL{
			_w = glc_AspectWidth( _h, aspectRatio);
		}else if scalingMode == GLC_VERTICAL{
			_h = glc_AspectHeight( _w, aspectRatio);		
		}
	
		width = _w;
		height = _h;
	
		ViewMatrix = buildViewMatrix();
		projectionMatrix = buildProjectionMatrix();

		camera_set_view_mat(self.camera, ViewMatrix);
		camera_set_proj_mat(self.camera, projectionMatrix);
	
	}
	/*
	if camera == glc_GetCamera(){
		window_set_fullscreen(window.fullscreen);
		window_set_size( _w, _h);
	}*/
}

function _glc_resize_appsurf(camera){
	with camera{
		if !stretch{
		
			var _w = glc_DisplayGetWidth();
			var _h = glc_DisplayGetHeight();
		
			if scalingMode == GLC_HORIZONTAL{
				_w = glc_AspectWidth( _h, aspectRatio);
			}else if scalingMode == GLC_VERTICAL{
				_h = glc_AspectHeight( _w, aspectRatio);		
			}
		
			surface_resize(application_surface,_w,_h);
		
		}else{
			surface_resize(application_surface,glc_DisplayGetWidth(),glc_DisplayGetHeight());
		}
	}
}

////PUBLIC////

function glc_Window(options) constructor {
	
	options = options == undefined ? {} : options;
	
	fullscreen = _glc_option(options, "fullscreen", false);
	borderless = _glc_option(options, "borderless", false);
	width = _glc_option(options, "width", glc_DisplayGetWidth());
	height = _glc_option(options, "height", glc_DisplayGetHeight());
	aspectRatio = _glc_option(options, "aspectRatio", width/height);
	scalingMode = _glc_option(options, "scalingMode", GLC_HORIZONTAL); 
	
	_glc_UpdateWindow(self);
}

function glc_Camera(options) constructor {
	
	options = options == undefined ? {} : options;
	
	x = _glc_option(options, "x", 0);
	y = _glc_option(options, "y", 0);
	z = _glc_option(options, "z", -10);
	targetX = _glc_option(options, "targetX", x);
	targetY = _glc_option(options, "targetY", y);
	width = _glc_option(options, "width", glc_WindowGetWidth());
	height = _glc_option(options, "height", glc_WindowGetHeight());
	aspectRatio = _glc_option(options, "aspectRatio", glc_GetWindow().aspectRatio);
	scalingMode = _glc_option(options, "scalingMode", GLC_HORIZONTAL); 
	rounding = _glc_option(options, "rounding", GLC_ROUND_N); 
	interpolateSpeed = _glc_option(options, "speed", .25);
	stretch = _glc_option(options, "stretch", true);
	zoom = _glc_option(options, "zoom", .5);
	strict = _glc_option(options, "strict", true);
	
	interpolate = _glc_option(options, "interpolate", function(from, to){
		return lerp(from, to, interpolateSpeed);
	})
	
	camera = _glc_option(options, "camera", camera_create());
	
	x = glc_CameraGetRounded_ext(self, x);
	y = glc_CameraGetRounded_ext(self, y);
	z = glc_CameraGetRounded_ext(self, z);
	
	buildViewMatrix = _glc_option(options, "buildViewMatrix", function(){
		return matrix_build_lookat(x, y, z, x, y, 0, 0, 1, 0);
	});
	
	buildProjectionMatrix = _glc_option(options, "buildProjectionMatrix", function(){
		return matrix_build_projection_ortho(glc_CameraGetWidth_ext(self), glc_CameraGetHeight_ext(self), 1, 99999);
	});
	
	ViewMatrix = buildViewMatrix();
	projectionMatrix = buildProjectionMatrix();
	
	camera_set_view_mat(camera, ViewMatrix);
	camera_set_proj_mat(camera, projectionMatrix);
	
	_glc_UpdateCamera(self);
	_glc_resize_appsurf(self);
	
}

#region //glc functions
	
	
	#region //window
	
	//display size
	function glc_DisplayGetWidth(){
		return global.Glance.display.width;
	}
	
	function glc_DisplayGetHeight(){
		return global.Glance.display.height;
	}
	
	function glc_DisplayGetAspectRatio(){
		return glc_DisplayGetWidth()/glc_DisplayGetHeight();
	}
	
	//window size
	function glc_WindowSetSize(width, height){
		var window = glc_GetWindow();
		window.width = width;
		window.height = height;
		_glc_UpdateWindow(window);
	}

	function glc_WindowSetSize_ext(window, width, height){
		window.width = width;
		window.height = height;
		_glc_UpdateWindow(window);
	}
	
	function glc_WindowGetWidth(){
		return global.Glance.window.width;
	}
	
	function glc_WindowGetWidth_ext(window){
		return window.width;
	}
	
	function glc_WindowGetHeight(){
		return global.Glance.window.height;
	}
	
	function glc_WindowGetHeight_ext(window){
		return window.height;
	}

	//fullscreen
	function glc_WindowSetFullscreen(fullscreen){
		var window = glc_GetWindow();
		window.fullscreen = fullscreen;
		_glc_UpdateWindow(window);
	}

	function glc_WindowSetFullscreen_ext(window, fullscreen){
		window.fullscreen = fullscreen;
		_glc_UpdateWindow(window);
	}
	
	//create window
	function glc_CreateWindow(options){
		return new glc_Window(options);
	}

	//set window
	function glc_SetWindow(window){
	
		global.Glance.window = window;
		
		_glc_UpdateWindow(window);
		
	}
	
	//get window
	function glc_GetWindow(){
	
		return global.Glance.window;
	
	}
	
	//aspect ratio
	function glc_AspectWidth(height, ratio){

		var _w = round(height*ratio);
		
		if(_w & 1)
			_w++;
			
		return _w;
	}
	
	function glc_AspectHeight(width, ratio){
		
		var _h = round(width/ratio);
		
		if(_h & 1)
			_h++;
			
		return _h;
	}
	
	function glc_WindowSetAspectRatio(ratio){
		var window = glc_GetWindow();
		window.aspectRatio = ratio;
		
		_glc_UpdateWindow(window);
	}
	
	function glc_WindowSetAspectRatio_ext(window, ratio){
		window.aspectRatio = ratio;
		
		_glc_UpdateWindow(window);
	}
	
	function glc_WindowSetScalingMode(glc_mode){
		var window = glc_GetWindow();
		window.scalingMode = glc_mode;
		
		_glc_UpdateWindow(window);
	}
	
	function glc_WindowSetScalingMode_ext(window, glc_mode){
		window.scalingMode = glc_mode;
		
		_glc_UpdateWindow(window);
	}
	
	#endregion

	#region //camera
	
		//create camera
		function glc_CreateCamera(options){
			return new glc_Camera(options);
		}
	
		function glc_GetCamera(){
			return global.Glance.camera;
		}
		
		function glc_SetCamera(viewport, camera){
			view_enabled = true;
			view_camera[viewport] = camera.camera;
			view_visible[viewport] = true;
			global.Glance.camera = camera;
		}
		
		function glc_CameraGetRounded(value){
			return glc_CameraGetRounded_ext(glc_GetCamera(), value);
		}
		
		function glc_CameraGetRounded_ext(camera, value){
			if camera.rounding = GLC_ROUND_N{
				var _round = glc_CameraGetWidth_ext(camera)/glc_DisplayGetWidth();
				return _glc_round_n( value, _round);
			}
			return value;
		}
		
		//update camera
		function glc_CameraUpdate_ext(camera){
			_glc_UpdateCamera(camera);
		}
		function glc_CameraUpdate(){
			var camera = glc_GetCamera();
			glc_CameraUpdate_ext(camera);
		}
		
		//size
		function glc_CameraGetWidth(){
			return glc_CameraGetWidth_ext(glc_GetCamera());
		}
		
		function glc_CameraGetWidth_ext(camera){
			return camera.width*camera.zoom;
		}
		
		function glc_CameraGetHeight(){
			return glc_CameraGetHeight_ext(glc_GetCamera());
		}
		
		function glc_CameraGetHeight_ext(camera){
			return camera.height*camera.zoom;
		}
		
		function glc_CameraSetSize_ext(camera, width, height){
			camera.width = width;
			camera.height = height;
		}
		function glc_CameraSetSize(width, height){
			glc_CameraSetSize_ext(glc_GetCamera(), width, height);
		}
		
		//position
		function glc_CameraSetTarget_ext(camera, x,y){
			camera.targetX = x;
			camera.targetY = y;
		}
		
		function glc_CameraSetTarget( x, y){
			var camera = glc_GetCamera();
			glc_CameraSetTarget_ext(camera, x, y);
		}
		
		function glc_CameraSetOffset_ext(camera, x, y){
			camera.x = camera.x+x;
			camera.y = camera.y+y;
		}
		function glc_CameraSetOffset(x, y){
			glc_CameraSetOffset_ext(glc_GetCamera(),x,y);
		}
		
		//zoom
		function glc_CameraSetZoom_ext(camera, zoom){
			camera.zoom = zoom;
		}
		function glc_CameraSetZoom(zoom){
			glc_CameraSetZoom_ext(glc_GetCamera(), zoom);
		}
		function glc_CameraSetStrict_ext(camera, strict){
			camera.strict = strict;
		}
		function glc_CameraSetStrict(strict){
			glc_CameraSetStrict_ext(glc_GetCamera(), strict);
		}
		
	#endregion
	
#endregion