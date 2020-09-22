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

global.objDelta = -1;

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


////PUBLIC////

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

