/// @description Insert description here
// You can write your code in this editor

with(obj_tile){
	if(!isSelected){
		draw_sprite_ext(spr_tiles, tileType, x, y, 1 + 0.1*hoverScale + 1*playingCounter, 1 + 0.1*hoverScale + 1*playingCounter, tileAngle + 6*power(dcos(playingCounter*1200), 3), c_white, 1 - 0.3*isReadyForPlay*(1 + 0.5*dcos(current_time)));
	}		
}

if(tileSelected != -1){
	with(tileSelected){
		draw_sprite_ext(spr_tiles, tileType, x, y, 1 + 0.1*hoverScale, 1 + 0.1*hoverScale, tileAngle + 5*dcos(playingCounter*900), c_white, 1);
		draw_sprite_ext(spr_selected, 0, x, y, 1 + 0.1*hoverScale, 1 + 0.1*hoverScale, tileAngle + 5*dcos(playingCounter*900), c_white, 1);
	}
}

draw_set_halign(fa_center);


var mouseGridPosition = GetGridMousePosition();
var textDebugPos = [64*9, -20];
draw_text(textDebugPos[0], textDebugPos[1], "Current Moves: " + string(remainingMoves) + "/" + string(movesPerTurn));
textDebugPos[1] += 30;

if(obj_game.debugMode){
	for(var i = 0; i < ds_grid_height(playGrid); i++){
		for(var j = 0; j < ds_grid_width(playGrid); j++){
			draw_text(64 * j, 64 * i, string_replace(string(playGrid[# j, i]), "ref instance 100", ""));
		}
	}
	draw_text(textDebugPos[0], textDebugPos[1], "Hover Tile " + string_replace(string(tileHovered), "ref instance 100", ""));
	textDebugPos[1] += 30;
	draw_text(textDebugPos[0], textDebugPos[1], "Selected Tile: " + string_replace(string(tileSelected), "ref instance 100", ""));
	textDebugPos[1] += 30;
	
	if(IsOutOfGrid(mouseGridPosition, obj_board.playGrid)){ return; }
	
	var cellContent = obj_board.playGrid[# mouseGridPosition[0], mouseGridPosition[1]];
	draw_text(textDebugPos[0], textDebugPos[1], "Mouse Grid Pos: " + string(mouseGridPosition));
	textDebugPos[1] += 30;
	draw_text(textDebugPos[0], textDebugPos[1], "Grid element: " + string_replace(string(cellContent), "ref instance 100", ""));
	textDebugPos[1] += 30;
	
	if(cellContent != -1){
		with(cellContent){
			if(isHover){
				
				draw_text(textDebugPos[0], textDebugPos[1], "Current Type: " + string(tileType));
				textDebugPos[1] += 30;
				draw_text(textDebugPos[0], textDebugPos[1], "Current Pos: " + string(tileGridPos));
				textDebugPos[1] += 30;
				draw_text(textDebugPos[0], textDebugPos[1], "Next Pos: " + string(tileGridPosNext));
				textDebugPos[1] += 30;
				draw_text(textDebugPos[0], textDebugPos[1], "Hover: " + string(isHover));
				textDebugPos[1] += 30;
				draw_text(textDebugPos[0], textDebugPos[1], "Selected: " + string(isSelected));
				textDebugPos[1] += 30;
				draw_text(textDebugPos[0], textDebugPos[1], "Ready to play: " + string(isReadyForPlay));
				textDebugPos[1] += 30;
				draw_text(textDebugPos[0], textDebugPos[1], "H: " + string(isHorizontalGroup) +   "V: " + string(isVerticalGroup));
				textDebugPos[1] += 30;
				draw_text(textDebugPos[0], textDebugPos[1], "Playing: " + string(isBreaking));
				textDebugPos[1] += 30;
				draw_text(textDebugPos[0], textDebugPos[1], "Considering Move: " + string(isConsideringMove));
				textDebugPos[1] += 30;
				draw_text(textDebugPos[0], textDebugPos[1], "Moving: " + string(isMoving));
				textDebugPos[1] += 30;
				draw_text(textDebugPos[0], textDebugPos[1], "Swapping partner: " + string(swappingPartner));
				textDebugPos[1] += 30;
				draw_text(textDebugPos[0], textDebugPos[1], "Depth: " + string(depth));
			}
		}
	}
}
//for(var i = 0; i < ds_grid_height(playGrid); i++){
//	for(var j = 0; j < ds_grid_width(playGrid); j++){
//		if(playGrid[j, i] != -1)
//	}
//}