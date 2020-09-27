//Glance window manager



////PUBLIC////

function glc_Window(options) constructor {
	
	options = options == undefined ? {} : options;
	
	fullscreen = _glc_option(options, "fullscreen", false);
	borderless = _glc_option(options, "borderless", false);
	width = _glc_option(options, "width", glc_DisplayGetWidth());
	height = _glc_option(options, "height", glc_DisplayGetHeight());
	aspectRatio = _glc_option(options, "aspectRatio", glc_DisplayGetAspectRatio());
	scalingMode = _glc_option(options, "scalingMode", GLC_HORIZONTAL); 
	
	_glc_UpdateWindow(self);
	
	
	//functions
	
	//update
	static update = function(){
		
		_glc_UpdateWindow(self);
		
		return self;
	}
	
	//size
	static setSize = function(width, height){
		
		self.width = width;
		self.height = height;
		
		return self;
	}
	
	static getWidth = function(){
		return width;
	}
	
	static getHeight = function(){
		return height;
	}
	
	//fllscreen
	static setFullscreen = function(fullscreen){
		
		self.fullscreen = fullscreen;
		
		return self;
	}
	
	//ratio
	static setAspectRatio = function(ratio){
		aspectRatio = ratio;
		
		return self;
	}
	
	//scaling mode
	static setScalingMode = function(glc_mode){
		scalingMode = glc_mode;
	}
}

#region //global
	
	
	//create window
	function glc_CreateWindow(options){
		return new glc_Window(options);
	}

	//set window
	function glc_SetWindow(window){
	
		global.Glance.window = window;
		_glc_UpdateWindow(window);
		
		return window;
		
	}
	
	//get window
	function glc_GetWindow(){
	
		return global.Glance.window;
	
	}

#endregion

////PRIVATE////

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
	
	if glc_GetCamera() != undefined{
		_glc_resize_appsurf(glc_GetCamera());
	}
}