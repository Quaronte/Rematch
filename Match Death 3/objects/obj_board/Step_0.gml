/// @description Insert description here
// You can write your code in this editor


if(keyboard_check_pressed(vk_space)){
	repeat(3){
		CreateTileTopRandomPos(irandom(tileT.energy));
	}
}

switch(boardState){
	case boardS.playerTurn:
		CheckHover();
		CheckSelected();

		if(tileSelected != -1){
			TrySwapping();
		}


		if(isGroupBreaking){
			playingCounter++;
			if(playingCounter >= playingMaxAnimationLength){
				
				with(obj_tile){
					if(isBreaking){
						obj_board.playGrid[# tileGridPos[0], tileGridPos[1]] = -1;
						instance_destroy();
						obj_board.tileSelected = obj_board.tileSelected == id ? -1 : obj_board.tileSelected;
						obj_board.tileHovered = obj_board.tileHovered == id ? -1 : obj_board.tileHovered;
					}
				}
				playingCounter = 0;
				isGroupBreaking = false;
				CheckAllTilesFall();
				CheckGroups();	
			}
			//tileGamePos = [SmoothLerp(tileGridPos[0], tileGridPosNext[0], anc_fall, "Fall", consideringMoveCounter), SmoothLerp(tileGridPos[1], tileGridPosNext[1], anc_fall, "Fall", consideringMoveCounter)];
		}
	break;
	case boardS.enemyTurn:
		boardState = boardS.playerTurn;	
		remainingMoves = obj_board.movesPerTurn;
		repeat(5){
			CreateTileTopRandomPos(irandom(tileT.energy));
		}
	break;
}




