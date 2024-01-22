/// @description Insert description here
// You can write your code in this editor


if(keyboard_check_pressed(vk_space)){
	repeat(3){
		createTileTopRandomPos(irandom(tileT.energy));
	}
}

switch(boardState){
	case boardS.playerTurn:
		checkHover();
		checkSelected();

		if(tileSelected != -1){
			trySwapping();
		}


		if(isPlaying){
			playingCounter++;
			if(playingCounter >= playingMaxAnimationLength){
				with(obj_tile){
					if(isPlaying){
						obj_board.playGrid[# tileGridPos[0], tileGridPos[1]] = -1;
						obj_board.tileHovered = -1;
						obj_board.tileSelected = -1;
						instance_destroy();
					}
				}
				playingCounter = 0;
				isPlaying = false;
				checkAllTilesFall();
				checkGroups();	
			}
			//tileGamePos = [smoothLerp(tileGridPos[0], tileGridPosNext[0], anc_fall, "Fall", consideringMoveCounter), smoothLerp(tileGridPos[1], tileGridPosNext[1], anc_fall, "Fall", consideringMoveCounter)];

		}
	break;
	case boardS.enemyTurn:
		boardState = boardS.playerTurn;	
		currentMoves = 0;
		repeat(5){
			createTileTopRandomPos(irandom(tileT.energy));
		}
	break;
}




