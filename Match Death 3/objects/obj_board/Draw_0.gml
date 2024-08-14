/// @description Insert description here
// You can write your code in this editor



for(var i = 0; i < ds_grid_height(playGrid); i++){
	for(var j = 0; j < ds_grid_width(playGrid); j++){
		draw_sprite_ext(spr_emptySlot, 0, j*sprite_get_width(spr_tiles), i*sprite_get_width(spr_tiles), 1, 1, 0, c_white, 1);
		draw_sprite_ext(spr_emptySlot, 0, (j + enemyGridOffset[0])*sprite_get_width(spr_tiles), i*sprite_get_width(spr_tiles), 1, 1, 0, c_white, 1);
	}
}

with(obj_enemy){
	DrawEnemy();
}


with(obj_tile){
	if(!isSelected){
		draw_sprite_ext(spr_tiles, tileType, x, y, 1 + 0.1*hoverScale + 1*breakingCounter, 1 + 0.1*hoverScale + 1*breakingCounter, tileAngle + 6*power(dcos(breakingCounter*1200), 3), c_white, (1 - breakingCounter)*(1 - (1 - point_distance(tileGridPos[0], tileGridPos[1], tileGamePos[0], tileGamePos[1]))*0.3*isReadyForPlay*(1 + 0.5*dcos(current_time))));
	}	
	
	//-----------------------------------------------ATTACK EFFECTS---------------------------------
	if(tileGroup != -1 && hoverCounter > 0){
		// ShowDebug("Nueva casilla con grupo y hover -------------");
		var _currentGroup = obj_board.availableGroupsList[| tileGroup];
		with(_currentGroup){
			
			var _currentGroupHighlightsMap = ds_map_values_to_array(_currentGroup.groupHighlights);
			for(var i = 0; i < array_length(_currentGroupHighlightsMap); i++){
				var _currentGroupHighlightsArray = _currentGroupHighlightsMap[i];
				var _gridOffset = _currentGroupHighlightsArray.highlightElementGrid  == obj_board.playGrid ? [0, 0] : obj_board.enemyGridOffset;
				var _highlightPos = _currentGroupHighlightsArray.highlightElementPos; 
				var _highlightType = _currentGroupHighlightsArray.highlightElementType; 
				// ShowDebug("Pintando grupo", i, "en posicion", _currentGroupHiglightsList[0] + _gridOffset, _currentGroupHiglightsList[1]);
				draw_sprite_ext(spr_attackEffects, _highlightType, ((_highlightPos[0]) + _gridOffset[0]) * sprite_get_width(spr_tiles), (_highlightPos[1]) * sprite_get_height(spr_tiles), 1, 1, other.tileAngle, c_white, other.hoverCounter*0.7*(1 + 0.5*dcos(current_time)));
			}
		}
	}
}

with(obj_button){
	draw_sprite_ext(spr_button, buttonType, x, y, 1 + 0.1*hoverScale, 1 + 0.1*hoverScale, 0, c_white, 1);
}

if(clickableSelected != -1){
	with(clickableSelected){
		draw_sprite_ext(spr_tiles, tileType, x, y, 1 + 0.1*hoverScale, 1 + 0.1*hoverScale, tileAngle + 5*dcos(breakingCounter*900), c_white, 1);
		draw_sprite_ext(spr_selected, 0, x, y, 1 + 0.1*hoverScale, 1 + 0.1*hoverScale, tileAngle + 5*dcos(breakingCounter*900), c_white, 1);
	}
}
draw_set_font(fnt_game);

draw_text(-2*sprite_get_width(spr_tiles), 0*sprite_get_height(spr_tiles), "HP " + string(playerHealth) + "/10");
draw_text(-2*sprite_get_width(spr_tiles), 0.5*sprite_get_height(spr_tiles), "Coins: " + string(playerCoins));

draw_text(-2*sprite_get_width(spr_tiles), 6.5*sprite_get_height(spr_tiles), "Draw Pile: " + string(ds_list_size(playingDeck)));
draw_text(-2*sprite_get_width(spr_tiles), 7*sprite_get_height(spr_tiles), "Discard Pile: " + string(ds_list_size(discardedDeck)));
var _color = remainingMoves == 0 ? c_red : c_white;
draw_text_color(-2*sprite_get_width(spr_tiles), 7.5*sprite_get_height(spr_tiles), "Swaps Left: " + string(remainingMoves) + "/" + string(movesPerTurn), _color, _color, _color, _color, remainingMoves == 0 ? (1 + 0.5*dcos(current_time/10)) : 1);



var mouseGridPosition = GetGridMousePosition();
var textDebugPos = [-1*sprite_get_width(spr_tiles), 1*sprite_get_height(spr_tiles)];


if(obj_game.debugMode){
	draw_set_font(fnt_debug);
	for(var i = 0; i < ds_grid_height(playGrid); i++){
		for(var j = 0; j < ds_grid_width(playGrid); j++){
			draw_text(64 * j, 64 * i, string_replace(string(playGrid[# j, i]), "ref instance 10", ""));
		}
	}
	draw_set_halign(fa_right);
	draw_text(textDebugPos[0], textDebugPos[1], "Hover Tile " + string_replace(string(clickableHovered), "ref instance 10", ""));
	textDebugPos[1] += 25;
	draw_text(textDebugPos[0], textDebugPos[1], "Selected Tile: " + string_replace(string(clickableSelected), "ref instance 10", ""));
	textDebugPos[1] += 25;
	draw_text(textDebugPos[0], textDebugPos[1], "Mouse Grid Pos: " + string(mouseGridPosition));
	textDebugPos[1] += 25;
	
	if(IsOutOfGrid(mouseGridPosition, obj_board.playGrid)){ 
		draw_set_halign(fa_center); 
		draw_set_font(fnt_game);
		return; 
		
	}
	
	var cellContent = obj_board.playGrid[# mouseGridPosition[0], mouseGridPosition[1]];

	
	if(cellContent != -1){
		with(cellContent){
			if(isHover){
				
				draw_text(textDebugPos[0], textDebugPos[1], "Type: " + string(tileType) + " / Group: " + string(tileGroup));
				textDebugPos[1] += 25;
				draw_text(textDebugPos[0], textDebugPos[1], "Pos: " + string(tileGridPos) + " -> " + string(tileGridPosNext));
				textDebugPos[1] += 25;
				draw_text(textDebugPos[0], textDebugPos[1], "Moving? : " + string(isConsideringMove) + " / Moving: " + string(isMoving));
				textDebugPos[1] += 25;
				draw_text(textDebugPos[0], textDebugPos[1], "Swapping partner: " + string(swappingPartner));
				textDebugPos[1] += 25;
				draw_text(textDebugPos[0], textDebugPos[1], "Ready to play: " + string(isReadyForPlay));
				textDebugPos[1] += 25;
				draw_text(textDebugPos[0], textDebugPos[1], "H: " + string(isHorizontalGroup) +   "V: " + string(isVerticalGroup));
				textDebugPos[1] += 25;
				draw_text(textDebugPos[0], textDebugPos[1], "Playing: " + string(isBreaking));
				
			}
		}
	}
	draw_set_font(fnt_game);
	draw_set_halign(fa_center);
}
//for(var i = 0; i < ds_grid_height(playGrid); i++){
//	for(var j = 0; j < ds_grid_width(playGrid); j++){
//		if(playGrid[j, i] != -1)
//	}
//}