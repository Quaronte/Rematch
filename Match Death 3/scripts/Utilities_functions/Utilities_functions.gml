// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function GetGridMousePosition(){
	var mouseGridPosition = [0, 0];
	mouseGridPosition = [(mouse_x + sprite_get_width(spr_tiles)/2) div sprite_get_width(spr_tiles), (mouse_y + sprite_get_height(spr_tiles)/2) div sprite_get_height(spr_tiles)]
	return mouseGridPosition;
}


function SmoothLerp(value1, value2, anc_curve, index, counter){
	var _curve = animcurve_get_channel(anc_curve, index);
	var _smoothCounter = animcurve_channel_evaluate(_curve, counter);
	return lerp(value1, value2, _smoothCounter);
}

function FindPosInDirection(_pos, _dir, _distance, _grid){
	var _nextPos = [_pos[0] + round(dcos(_dir)*_distance), _pos[1] - round(dsin(_dir)*_distance)];
	return _nextPos;
}

function FindCellInDirection(_pos, _dir, _distance, _grid){
	var _nextPos = [_pos[0] + round(dcos(_dir)*_distance), _pos[1] - round(dsin(_dir)*_distance)];
	if(IsOutOfGrid(_nextPos, _grid)){ return -2; }
	
	return _grid[# _nextPos[0], _nextPos[1]];
}

function IsOutOfGrid(_gridPosition, _grid){
	if(_gridPosition[0] < 0 || _gridPosition[1] < 0){
		return true;
	}
	if(_gridPosition[0] >= ds_grid_width(_grid) || _gridPosition[1] >= ds_grid_height(_grid)){
		return true;
	}
	
	return false;
}

function ShowGridDebug(_grid){
	var _currentString = "";
	for(var i = 0; i < ds_grid_height(_grid); i++){
		for(var j = 0; j < ds_grid_width(_grid); j++){
			_currentString += "     " + string_replace(string(_grid[# j, i]), "ref instance 10", "");
		}
		show_debug_message(_currentString);
		_currentString = "";
	}	
}

function ShowDebug(){
	var _stringDebug = "";
	for(var i = 0; i < argument_count; i++){
		_stringDebug += string(argument[i]) + " ";
	}
	show_debug_message(_stringDebug);
}