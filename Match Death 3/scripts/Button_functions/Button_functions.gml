
function ButtonOnHover() {
    isHover = true;
	if(obj_board.buttonHovered != id && obj_board.buttonHovered != -1){
		buttonHovered.isHover = false;
	}
	buttonHovered = id;
}

function ButtonOnDeselect() {
    isSelected = false;
}

function ButtonOnSelect() {
    isSelected = true;
    
    script_execute(buttonSelectScript);
    showDebug("Boton seleccionado");
}

function ButtonEndTurn() {
    obj_board.boardState = boardS.enemyTurn;
    showDebug("Cambiando estado");
}