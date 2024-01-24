
//Si queremos posición aleatoria decimos que -1
function CreateTile(_type, _pos){
	
	if(IsBoardFull()){ return; }
	
	var newTile = instance_create_depth(0, 0, 0, obj_tile);
	with(newTile){	
		tileType = _type;
		if(_pos == -1){
			do{
				tileGridPos = [irandom(ds_grid_width(obj_board.playGrid) - 1), 0];
			}
			until(obj_board.playGrid[# tileGridPos[0], tileGridPos[1]] == -1);
		}
		else{
			tileGridPos = [_pos[0], _pos[1]];
		}
		tileGamePos = [tileGridPos[0], tileGridPos[1]];
		tileGridPosNext = [tileGridPos[0], tileGridPos[1]];
		// obj_board.playGrid[# tileGridPos[0], tileGridPos[1]] = id;
		
		TryToFall();
	}
	return newTile;
}

//Si queremos posición aleatoria decimos que -1
function DrawTileFromDeck(_pos){
    with(obj_board){
    	if(ds_list_empty(playingDeck)){
    		if(ds_list_empty(discardedDeck)){ return false;}
    		ds_list_shuffle(discardedDeck);
    		ds_list_copy(playingDeck, discardedDeck);
    		ds_list_clear(discardedDeck);
    	}
    	CreateTile(playingDeck[| 0], _pos);
    	ds_list_delete(playingDeck, 0);
    	return true;
    }
}
