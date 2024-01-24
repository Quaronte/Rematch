/// @description Insert description here
// You can write your code in this editor

if(obj_game.debugMode){
	if(keyboard_check_pressed(vk_space)){
		repeat(3){
			CreateTile(irandom(tileT.energy), -1);
		}
	}
}

CheckHover();
CheckSelected();
CheckRelease();

switch(boardState){
	case boardS.playerTurn:
		//WARNING
		if(clickableSelected != -1){
			TrySwapping();
		}


		if(isGroupBreaking){
			breakingCounter++;
			if(breakingCounter >= breakingMaxAnimationLength){
				
				with(obj_tile){
					if(isBreaking){
						obj_board.playGrid[# tileGridPos[0], tileGridPos[1]] = -1;
						if(tileIsFromDeck){
							ds_list_add(obj_board.discardedDeck, tileType);
						}
						instance_destroy();
						obj_board.clickableSelected = obj_board.clickableSelected == id ? -1 : obj_board.clickableSelected;
						obj_board.clickableHovered = obj_board.clickableHovered == id ? -1 : obj_board.clickableHovered;
					}
				}
				breakingCounter = 0;
				isGroupBreaking = false;
				CheckAllTilesFall();
				CheckGroups();	
				obj_board.breakingMaxAnimationLength = 25;
			}
			//tileGamePos = [SmoothLerp(tileGridPos[0], tileGridPosNext[0], anc_fall, "Fall", consideringMoveCounter), SmoothLerp(tileGridPos[1], tileGridPosNext[1], anc_fall, "Fall", consideringMoveCounter)];
		}
	break;
	case boardS.enemyTurn:
		if(!ExecuteEnemyStack()){
			boardState = boardS.playerTurn;	
			remainingMoves = obj_board.movesPerTurn;
			// repeat(5){
			// 	CreateTile(irandom(tileT.energy), -1);
			// }
			CheckGroups();
		}
	break;
}




