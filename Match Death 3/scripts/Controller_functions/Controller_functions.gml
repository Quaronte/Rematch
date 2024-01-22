// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum dir {right = 0, up = 90, left = 180, down =270}

function checkHover(){
	var objectOnMouse = collision_point(mouse_x, mouse_y, obj_tile, false, true);

	if(objectOnMouse == noone){
		if(tileHovered != -1){
			tileHovered.isHover = false;
			tileHovered = -1;
		}
		return;
	}
	
	if(objectOnMouse.object_index == obj_tile){
		objectOnMouse.isHover = true;
		if(tileHovered != objectOnMouse && tileHovered != -1){
			tileHovered.isHover = false;
		}
		tileHovered = objectOnMouse;
	}
}

function checkSelected(){
	if(mouse_check_button_pressed(mb_left)){
		var objectOnMouse = collision_point(mouse_x, mouse_y, obj_tile, false, true);

		if(objectOnMouse == noone){
			return;
		}
	
		if(objectOnMouse.object_index == obj_tile){
			if(objectOnMouse.isReadyForPlay == true){
				breakGroup(objectOnMouse);
				isPlaying = true;
				return;
			}
			tileSelected = objectOnMouse;
			tileSelected.isSelected = true;
			tileSelected.depth = -100;
		}
	}
	
	if(mouse_check_button_released(mb_left)){
		var _updateBoard = false;
		if(tileSelected != -1){
			if(tryMakingSwap(tileSelected)){
				checkAllTilesFall();
				checkGroups();	
			}
			tileSelected = -1;
		}
	}
}




