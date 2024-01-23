// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum dir {right = 0, up = 90, left = 180, down =270}

function CheckHover(){
	var objectOnMouse = collision_point(mouse_x, mouse_y, obj_clickable, false, true);

	if(objectOnMouse == noone){	
		if(clickableHovered != -1){
			if(clickableHovered.clickableFunctionOnDehover == -1){ return; }
			script_execute(clickableHovered.clickableFunctionOnDehover, clickableHovered);
		}
		return;	
	}
	if(objectOnMouse.clickableFunctionOnHover == -1){ return; }
	
	script_execute(objectOnMouse.clickableFunctionOnHover, objectOnMouse);
}

function CheckSelected(){
	if(mouse_check_button_pressed(mb_left)){
		var objectOnMouse = collision_point(mouse_x, mouse_y, obj_clickable, false, true);
		ShowDebug("Trying to Select", objectOnMouse);
		if(objectOnMouse == noone){	return; }
		if(objectOnMouse.clickableFunctionOnSelect == -1){ return; }
		ShowDebug("Selecting", objectOnMouse);
			
		script_execute(objectOnMouse.clickableFunctionOnSelect, objectOnMouse);
		
	}
}

function CheckRelease(){
	if(mouse_check_button_released(mb_left)){
		var _updateBoard = false;
		if(clickableSelected == -1){ return; }
		if(clickableSelected.clickableFunctionOnRelease == -1){ return; }
		script_execute(clickableSelected.clickableFunctionOnRelease, clickableSelected);
		clickableSelected = -1;
	}
}



