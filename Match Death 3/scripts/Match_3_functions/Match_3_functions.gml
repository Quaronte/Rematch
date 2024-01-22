// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function CreateTileTopRandomPos(_type){
	
	if(IsBoardFull()){ return; }
	
	var newTile = instance_create_depth(0, 0, 0, obj_tile);
	with(newTile){	
		tileType = _type;
		do{
			tileGridPosNext = [irandom(ds_grid_width(obj_board.playGrid) - 1), 0];
		}
		until(obj_board.playGrid[# tileGridPosNext[0], tileGridPosNext[1]] == -1);
		
		tileGamePos = [tileGridPosNext[0], tileGridPosNext[1]];
		tileGridPos = [tileGridPosNext[0], tileGridPosNext[1]];
	
		CheckTileFall();
	}
	return newTile;
}


#region Swapping

function TrySwapping(){
	var mouseGridPosition = GetGridMousePosition();
	if(obj_board.isGroupBreaking){ return; }
	if(IsOutOfGrid(mouseGridPosition, obj_board.playGrid)){ return; }
	
	
	//show_debug_message("Mouse Position" + string(mouseGridPosition));
	with(tileSelected){
		if(isMoving){
			consideringMoveCounter = 0;
			tileGridPos = [tileGridPosNext[0] , tileGridPosNext[1]];
			isMoving = false;
		}
		
		if(isConsideringMove){ 
			if(mouseGridPosition[0] == tileGridPos[0] && mouseGridPosition[1] == tileGridPos[1]){
				isConsideringMove = false;
				if(swappingPartner == -1){ return; }
				swappingPartner.isConsideringMove = false;
				swappingPartner = -1;
			}
			return; 
		}
		if(mouseGridPosition[0] != tileGridPosNext[0] || mouseGridPosition[1] != tileGridPosNext[1]){
			
			isConsideringMove = true;
			//Derecha
			if(mouseGridPosition[0] > tileGridPosNext[0]){
				tileGridPosNext[0] += 1;
			}
			//Arriba
			if(mouseGridPosition[1] < tileGridPosNext[1]){
				tileGridPosNext[1] -= 1;
			}
			//Izquierda
			if(mouseGridPosition[0] < tileGridPosNext[0]){
				tileGridPosNext[0] -= 1;
			}
			//Abajo
			if(mouseGridPosition[1] > tileGridPosNext[1]){
				tileGridPosNext[1] += 1;
			}
			//show_debug_message("The tile is trying to move to " + string(tileGridPosNext));
			
			//Cambiamos la posición de la posible casilla en esta posición
			swappingPartner = obj_board.playGrid[# tileGridPosNext[0], tileGridPosNext[1]];
			if(swappingPartner == -1){ return; }
			with(swappingPartner){
				if(object_index == obj_tile){
					if(isMoving){
						consideringMoveCounter = 0;
						tileGridPos = [tileGridPosNext[0] , tileGridPosNext[1]];
						isMoving = false;
						swappingPartner = -1;
					}
					tileGridPosNext[0] = other.tileGridPos[0];
					tileGridPosNext[1] = other.tileGridPos[1];
					isConsideringMove = true;
				}
			}
		}
	}
}
	
function TryMakingSwap(_tileSelected){
	with(_tileSelected){
		//Apagamos la casilla
		isSelected = false;
		depth = 0;
		//Vemos si tenemos que movernos
		if(isConsideringMove){
			_updateBoard = true;
			//Actualizamos el tile y la grid de juego
			obj_board.playGrid[# tileGridPos[0], tileGridPos[1]] = -1;
			// tileGridPos = [tileGridPosNext[0], tileGridPosNext[1]];
			isConsideringMove = false;
			isMoving = true;
			ShowDebug("Considerando movimiento", tileGridPos);
			obj_board.playGrid[# tileGridPosNext[0], tileGridPosNext[1]] = id;
			//Actualizamos nuestra pareja de swap si existe
			if(swappingPartner != -1){
				// swappingPartner.tileGridPos = [swappingPartner.tileGridPosNext[0], swappingPartner.tileGridPosNext[1]];
				swappingPartner.isConsideringMove = false;	
				swappingPartner.isMoving= true;	
				obj_board.playGrid[# swappingPartner.tileGridPosNext[0], swappingPartner.tileGridPosNext[1]] = swappingPartner.id;
				// swappingPartner = -1;
			}
			//Comprobamos si tenemos que pasar al turno de los enemigos
			obj_board.remainingMoves--;
		}
		return true;
	}	
	return false;
}

#endregion


#region Making and marking groups

function CheckGroups(){
	
	with(obj_tile){
		isReadyForPlay = false;	
		isVerticalGroup = false;
		isHorizontalGroup = false;
	}
	//Vertical groups
	var _currentStreak = 0;
	var _currentType = -2;
	var _currentCell = -1;
	for(var i = 0; i < ds_grid_width(obj_board.playGrid); i++){
		for(var j = 0; j < ds_grid_height(obj_board.playGrid); j++){
			_currentCell = obj_board.playGrid[# i, j];
			//Si la casilla es nula, salimos
			if(_currentCell != -1){
				if(_currentCell.tileType != _currentType){
					CheckAndMarkGroup(i, j, _currentStreak, 3, true);
					_currentStreak = 0;
				}
				//Añadimos a nuestra cadena
				_currentStreak++;			
			}
			else{
				CheckAndMarkGroup(j, i, _currentStreak, 3, false);
				_currentStreak = 0;
			}
			_currentType = _currentCell == -1 ? -1 : _currentCell.tileType;
		}	
		//En la última tenemos que comprobar si 
		CheckAndMarkGroup(i, j, _currentStreak, 3, true);
		_currentStreak = 0;
		_currentType = -2;
	}
	//Horizontal groups
	for(var i = 0; i < ds_grid_height(obj_board.playGrid); i++){
		for(var j = 0; j < ds_grid_width(obj_board.playGrid); j++){
			_currentCell = obj_board.playGrid[# j, i];
			//Si la casilla es nula, salimos
			if(_currentCell != -1){
				if(_currentCell.tileType != _currentType){
					CheckAndMarkGroup(j, i, _currentStreak, 3, false);
					_currentStreak = 0;
				}
				//Añadimos a nuestra cadena
				_currentStreak++;	
			}
			else{
				CheckAndMarkGroup(j, i, _currentStreak, 3, false);
				_currentStreak = 0;
			}
			_currentType = _currentCell == -1 ? -1 : _currentCell.tileType;
		}
		CheckAndMarkGroup(j, i, _currentStreak, 3, false);
		_currentStreak = 0;
		_currentType = -2;
	}
}

function CheckAndMarkGroup(_i, _j, _currentStreak, _groupSize, _isVertical){
	if(_currentStreak >= _groupSize){
		for(var k = 1; k <= _currentStreak; k++){
			with(obj_board.playGrid[# _i - k*!_isVertical, _j - k*_isVertical]){
				isReadyForPlay = true;
				isVerticalGroup = isVerticalGroup || _isVertical;
				isHorizontalGroup = isHorizontalGroup || !_isVertical;
			}
		}	
	}
}

function BreakGroup(_startingTile){
	var tilesToCheck = ds_stack_create();
	ds_stack_push(tilesToCheck, _startingTile);
	var counterDestroy = 0;
	var _nextTile = 0;
	while(!ds_stack_empty(tilesToCheck)){
		counterDestroy++;
		with(ds_stack_pop(tilesToCheck)){
			isBreaking = true;
			if(isVerticalGroup){
				isVerticalGroup = false;
				for(var i = 90; i < 360; i+= 180){
					_nextTile = FindTileInDirection(tileGridPos[0], tileGridPos[1], i, 1, obj_board.playGrid);
					if(_nextTile != -1){
						if(_nextTile.isVerticalGroup && _nextTile.tileType == _startingTile.tileType){
							ds_stack_push(tilesToCheck, _nextTile);
						}
					}
				}
			}
			if(isHorizontalGroup){
				isHorizontalGroup = false;
				for(var i = 0; i < 360; i+= 180){
					_nextTile = FindTileInDirection(tileGridPos[0], tileGridPos[1], i, 1, obj_board.playGrid);
					if(_nextTile != -1){
						if(_nextTile.isHorizontalGroup && _nextTile.tileType == _startingTile.tileType){
							ds_stack_push(tilesToCheck, _nextTile);
						}
					}
				}
			}
		}
	}
	ShowDebug("Destruyendo", counterDestroy, "piezas.");
}
	
#endregion
	

#region Falling 


function Fall(){
	if(fallCounter < 1){
		fallCounter = min(fallCounter + 1/fallTime, 1);
		tileGamePos = [SmoothLerp(tileGridPos[0], tileGridPosNext[0], anc_fall, "Fall", fallCounter), SmoothLerp(tileGridPos[1], tileGridPosNext[1], anc_fall, "Fall", fallCounter)];
		if(fallCounter == 1){
			tileGridPos = [tileGridPosNext[0], tileGridPosNext[1]];
		}
	}
}
	
function CheckTileFall(){
	//Exit if no Fall
	if(obj_board.playGrid[# tileGridPosNext[0], tileGridPosNext[1] + 1] != -1){return false;}
	//Eliminate trace from the grid
	obj_board.playGrid[# tileGridPosNext[0], tileGridPosNext[1]] = -1;
	for(var i = tileGridPosNext[1] + 1; i < ds_grid_height(obj_board.playGrid); i++){
		if(obj_board.playGrid[# tileGridPosNext[0], i] != -1){
			fallTime = (i - 1 - tileGridPosNext[1])*5;
			obj_camera.offsetPos[1] -= fallTime/2;
			obj_camera.bounceCounter = 1;
			fallCounter = 0;
			tileGridPosNext = [tileGridPosNext[0], i - 1];
			obj_board.playGrid[# tileGridPosNext[0], tileGridPosNext[1]] = id;
			return true;
		}
	}
	fallTime = (ds_grid_height(obj_board.playGrid) - 1 - tileGridPosNext[1])*5;
	fallCounter = 0;
	tileGridPosNext = [tileGridPosNext[0], ds_grid_height(obj_board.playGrid) - 1];
	//Update grid
	obj_board.playGrid[# tileGridPosNext[0], tileGridPosNext[1]] = id;
	return true;
}

function CheckAllTilesFall(){
//Comprobamos grupos y caidas
	for(var i = ds_grid_height(obj_board.playGrid) - 2; i >= 0; i--){
		for(var j = 0; j < ds_grid_width(obj_board.playGrid); j++){
			if(obj_board.playGrid[# j, i] != -1){
				with(obj_board.playGrid[# j, i]){
					if(CheckTileFall()){
						isSelected = -1;
						obj_board.tileSelected = obj_board.tileSelected == id ? -1 : obj_board.tileSelected;	
					}
				}
			}
		}
	}	
}

#endregion


function IsBoardFull(){
	for(var i = 0; i < ds_grid_width(obj_board.playGrid); i++){
		if(	obj_board.playGrid[# i, 0] == -1){
			return false;
		}	
	}
	return true;
}


