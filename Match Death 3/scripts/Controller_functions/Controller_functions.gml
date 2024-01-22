// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum dir {right = 0, up = 90, left = 180, down =270}

function CheckHover(){
	var objectOnMouse = collision_point(mouse_x, mouse_y, obj_tile, false, true);

	if(objectOnMouse == noone){
		if(tileHovered != -1){
			tileHovered.isHover = false;
			tileHovered = -1;
		}
		if(buttonHovered != -1){
			buttonHovered.isHover = false;
			buttonHovered = -1;
		}
		return;
	}
	switch(objectOnMouse.object_index){
		case obj_tile:
				objectOnMouse.isHover = true;
				if(tileHovered != objectOnMouse && tileHovered != -1){
					tileHovered.isHover = false;
				}
				tileHovered = objectOnMouse;
			break;
		case obj_button:
			with(objectOnMouse){
				script_execute(ButtonOnHover);
			}
			break;
	}
	
}

function CheckSelected(){
	if(mouse_check_button_pressed(mb_left)){
		var objectOnMouse = collision_point(mouse_x, mouse_y, obj_tile, false, true);

		if(objectOnMouse == noone){
			return;
		}
		switch(objectOnMouse.object_index){
			case obj_tile:
				if(objectOnMouse.isReadyForPlay == true){
					if(!isGroupBreaking){
						BreakGroup(objectOnMouse);
						isGroupBreaking = true;
					}
					return;
				}
				if(objectOnMouse.fallCounter == 1 && obj_board.remainingMoves > 0){
					tileSelected = objectOnMouse;
					tileSelected.isSelected = true;
					tileSelected.depth = -100;
				}
			break;
			case obj_button:
				ShowDebug("Intentando seleccionar ratón");
				with(objectOnMouse){
					ShowDebug("Por lo menos existe");
					script_execute(ButtonOnSelect);
				}
				break;
		}
	}
	
	if(mouse_check_button_released(mb_left)){
		var _updateBoard = false;
		if(tileSelected != -1){
			if(TryMakingSwap(tileSelected)){
				CheckAllTilesFall();
				CheckGroups();	
			}
			tileSelected = -1;
		}
		if(buttonSelected != -1){
			with(buttonSelected){
				script_execute(ButtonOnDeselect);
			}
		}
	}
}





