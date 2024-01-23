
function ButtonOnHover(_object) {
    _object.isHover = true;
	if(obj_board.clickableHovered != _object && obj_board.clickableHovered != -1){
		clickableHovered.isHover = false;
	}
	clickableHovered = _object;
	_object.hoverAnim = [anc_effects, "HoverOn"];
}

function ButtonOnDehover(_object) {
    _object.isHover = false;
	_object.hoverAnim = [anc_effects, "HoverOff"];
	obj_board.clickableHovered = -1;
}


function ButtonOnSelect(_object) {
    _object.isSelected = true;
    script_execute(_object.buttonSelectScript);
}

function ButtonOnRelease(_object) {
    _object.isSelected = false;
}


function ButtonEndTurn() {
    obj_board.boardState = boardS.enemyTurn;
    ShowDebug("Cambiando estado");
}
