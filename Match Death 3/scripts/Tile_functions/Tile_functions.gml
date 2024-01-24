
function BasicOnHover(_object){
	_object.isHover = true;
	if(obj_board.clickableHovered != _object && obj_board.clickableHovered != -1){
		clickableHovered.isHover = false;
	}
	clickableHovered = _object;	
	_object.hoverAnim = [anc_effects, "HoverOn"];
}

function BasicOnDehover(_object){
	_object.isHover = false;
	_object.hoverAnim = [anc_effects, "HoverOff"];
	obj_board.clickableHovered = -1;
}

function TileOnSelect(_object){
	
	if(TryBreakingGroup(_object.tileGroup)){ return; }
	
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

function GroupOnHover(_object){
	_object.isHover = true;
	if(obj_board.clickableHovered != _object && obj_board.clickableHovered != -1){
		clickableHovered.isHover = false;
	}
	clickableHovered = _object;	
	_object.hoverAnim = [anc_effects, "HoverOn"];
}