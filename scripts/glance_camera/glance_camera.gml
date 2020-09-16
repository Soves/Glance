//glance camera manager


////PUBLIC////

function glc_Camera(options) constructor {
	
	options = options == undefined ? {} : options;
	
	x = _glc_option(options, "x", 0);
	y = _glc_option(options, "y", 0);
	z = _glc_option(options, "z", -10);
	realX = _glc_option(options, "realX", x);
	realY = _glc_option(options, "realY", y);
	realZ = _glc_option(options, "realZ", z);
	
	width = _glc_option(options, "width", glc_GetWindow().getWidth());
	height = _glc_option(options, "height", glc_GetWindow().getHeight());
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
	
	buildViewMatrix = _glc_option(options, "buildViewMatrix", function(){
		return matrix_build_lookat(x, y, z, x, y, 0, 0, 1, 0);
	});
	
	buildProjectionMatrix = _glc_option(options, "buildProjectionMatrix", function(){
		return matrix_build_projection_ortho(getWidth(), getHeight(), 1, 99999);
	});
	
	//functions
	
	//update
	static update = function(){
		_glc_UpdateCamera(self);
	}
	
	//size
	static setSize = function(width, height){
		
		self.width = width;
		self.height = height;
		
		return self;
	}
	
	static getWidth = function(){
		return width*zoom;
	}
	
	static getHeight = function(){
		return height*zoom;
	}
	
	//offset
	static offsetBy = function(x,y){
		realX += x;
		realY += y;
	}
	
	//strict
	static setStrict = function(strict){
		self.strict = strict;
		
		return self;
	}
	
	//zoom
	static setZoom = function(zoom){
		self.zoom = zoom;
		
		return self;
	}
	
	static getRounded = function(value){
		if rounding = GLC_ROUND_N{
			var _round = getWidth()/glc_DisplayGetWidth();
			return _glc_round_n( value, _round);
		}
		return value;
	}
	
	
	//finally 
	_glc_UpdateCamera(self);
	_glc_resize_appsurf(self);
	
}

#region //global
	
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
		
#endregion


////PRIVATE////


function _glc_UpdateCamera(camera){
	
	with camera{
		
		realX = interpolate(realX, x);
		realY = interpolate(realY, y);
		realZ = interpolate(realZ, z);
		
		realX = getRounded(realX);
		realY = getRounded(realY);
		realZ = getRounded(realZ);
	
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