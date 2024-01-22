// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function getGridMousePosition(){
	var mouseGridPosition = [0, 0];
	mouseGridPosition = [(mouse_x + sprite_get_width(spr_tiles)/2) div sprite_get_width(spr_tiles), (mouse_y + sprite_get_height(spr_tiles)/2) div sprite_get_height(spr_tiles)]
	return mouseGridPosition;
}


function smoothLerp(value1, value2, anc_curve, index, counter){
	var _curve = animcurve_get_channel(anc_curve, index);
	var _smoothCounter = animcurve_channel_evaluate(_curve, counter);
	return lerp(value1, value2, _smoothCounter);
}

function findTileInDirection(_x, _y, _dir, _distance, _grid){
	show_debug_message("_pos" + string(_x) + ", " + string(_y));
	var _nextPos = [_x + round(dcos(_dir)*_distance), _y - round(dsin(_dir)*_distance)];
	show_debug_message("_NextPos" + string(_nextPos) + "  gridValue" + string(_grid[# _nextPos[0], _nextPos[1]]));
	if(isOutOfGrid(_nextPos, _grid)){ return -1; }
	
	return _grid[# _nextPos[0], _nextPos[1]];
}

function isOutOfGrid(_gridPosition, _grid){
	if(_gridPosition[0] < 0 || _gridPosition[1] < 0){
		return true;
	}
	if(_gridPosition[0] >= ds_grid_width(_grid) || _gridPosition[1] >= ds_grid_height(_grid)){
		return true;
	}
	
	return false;
}

function showGridDebug(_grid){
	var _currentString = "";
	for(var i = 0; i < ds_grid_height(_grid); i++){
		for(var j = 0; j < ds_grid_width(_grid); j++){
			_currentString += "     " + string_replace(string(_grid[# j, i]), "ref instance 100", "");
		}
		show_debug_message(_currentString);
		_currentString = "";
	}	
}