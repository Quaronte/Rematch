// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function TileOnHover(_object){
	_object.isHover = true;
	if(obj_board.clickableHovered != _object && obj_board.clickableHovered != -1){
		clickableHovered.isHover = false;
	}
	clickableHovered = _object;	
	_object.hoverAnim = [anc_effects, "HoverOn"];
}

function TileOnDehover(_object){
	_object.isHover = false;
	_object.hoverAnim = [anc_effects, "HoverOff"];
	obj_board.clickableHovered = -1;
}

function TileOnSelect(_object){
	
	if(TryBreakingGroup(_object)){ return; }
	
	if(_object.fallCounter == 1 && obj_board.remainingMoves > 0){
		obj_board.clickableSelected = _object;
		obj_board.clickableSelected.isSelected = true;
		obj_board.clickableSelected.depth = -100;
	}
}

function TileOnRelease(_object){
	if(TryMakingSwap(_object)){
		CheckAllTilesFall();
		CheckGroups();	
	}
}