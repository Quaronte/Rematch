// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function createTileTopRandomPos(_type){
	
	if(isBoardFull()){ return; }
	
	var newTile = instance_create_depth(0, 0, 0, obj_tile);
	with(newTile){	
		tileType = _type;
		do{
			tileGridPosNext = [irandom(ds_grid_width(obj_board.playGrid) - 1), 0];
		}
		until(obj_board.playGrid[# tileGridPosNext[0], tileGridPosNext[1]] == -1);
		
		tileGamePos = [tileGridPosNext[0], tileGridPosNext[1]];
		tileGridPos = [tileGridPosNext[0], tileGridPosNext[1]];
	
		checkTileFall();
	}
	return newTile;
}


#region Swapping

function trySwapping(){
	var mouseGridPosition = getGridMousePosition();
	
	if(isOutOfGrid(mouseGridPosition, obj_board.playGrid)){ return; }

	
	//show_debug_message("Mouse Position" + string(mouseGridPosition));
	with(tileSelected){
		
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
			if(swappingPartner.object_index == obj_tile){
				swappingPartner.tileGridPosNext[0] = tileGridPos[0];
				swappingPartner.tileGridPosNext[1] = tileGridPos[1];
				swappingPartner.isConsideringMove = true;
			}
		
		}
	}
}
	
function tryMakingSwap(_tileSelected){
	with(_tileSelected){
		//Apagamos la casilla
		isSelected = false;
		depth = 0;
		//Vemos si tenemos que movernos
		if(isConsideringMove){
			_updateBoard = true;
			//Actualizamos el tile y la grid de juego
			obj_board.playGrid[# tileGridPos[0], tileGridPos[1]] = -1;
			tileGridPos = [tileGridPosNext[0], tileGridPosNext[1]];
			isConsideringMove = false;
			obj_board.playGrid[# tileGridPos[0], tileGridPos[1]] = id;
			//Actualizamos nuestra pareja de swap si existe
			if(swappingPartner != -1){
				swappingPartner.tileGridPos = [swappingPartner.tileGridPosNext[0], swappingPartner.tileGridPosNext[1]];
				swappingPartner.isConsideringMove = false;	
				obj_board.playGrid[# swappingPartner.tileGridPosNext[0], swappingPartner.tileGridPosNext[1]] = swappingPartner.id;
				swappingPartner = -1;
			}
			//Comprobamos si tenemos que pasar al turno de los enemigos
			obj_board.currentMoves++;
			if(obj_board.currentMoves == obj_board.movesPerTurn){
				obj_board.boardState = boardS.enemyTurn;	
			}
		}
		return true;
	}	
	return false;
}

#endregion


#region Making and marking groups

function checkGroups(){
	
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
					checkAndMarkGroup(i, j, _currentStreak, 3, true);
					_currentStreak = 0;
				}
				//Añadimos a nuestra cadena
				_currentStreak++;			
			}
			else{
				checkAndMarkGroup(j, i, _currentStreak, 3, false);
				_currentStreak = 0;
			}
			_currentType = _currentCell == -1 ? -1 : _currentCell.tileType;
		}	
		//En la última tenemos que comprobar si 
		checkAndMarkGroup(i, j, _currentStreak, 3, true);
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
					checkAndMarkGroup(j, i, _currentStreak, 3, false);
					_currentStreak = 0;
				}
				//Añadimos a nuestra cadena
				_currentStreak++;	
			}
			else{
				checkAndMarkGroup(j, i, _currentStreak, 3, false);
				_currentStreak = 0;
			}
			_currentType = _currentCell == -1 ? -1 : _currentCell.tileType;
		}
		checkAndMarkGroup(j, i, _currentStreak, 3, false);
		_currentStreak = 0;
		_currentType = -2;
	}
}

function checkAndMarkGroup(_i, _j, _currentStreak, _groupSize, _isVertical){
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

function breakGroup(_startingTile){
	var tilesToCheck = ds_stack_create();
	ds_stack_push(tilesToCheck, _startingTile);
	var counterDestroy = 0;
	var _nextTile = 0;
	show_debug_message("--------------------------------");
	while(!ds_stack_empty(tilesToCheck)){
		counterDestroy++;
		with(ds_stack_pop(tilesToCheck)){
			isPlaying = true;
			if(isVerticalGroup){
				isVerticalGroup = false;
				for(var i = 90; i < 360; i+= 180){
					_nextTile = findTileInDirection(tileGridPos[0], tileGridPos[1], i, 1, obj_board.playGrid);
					if(_nextTile != -1){
						show_debug_message("Que miramos" + string(_nextTile) + "Posicion que estamso mirando " + string(_nextTile.tileGridPos));
						show_debug_message("Tiene Grupo vertical " + string(_nextTile.isVerticalGroup) + " es del mismo tipo" + string(_nextTile.tileType) + "/" + string(_startingTile.tileType) + " fichas");
						if(_nextTile.isVerticalGroup && _nextTile.tileType == _startingTile.tileType){
							show_debug_message("Nos gusta" + string(_nextTile.tileGridPos));
							ds_stack_push(tilesToCheck, _nextTile);
						}
					}
				}
			}
			if(isHorizontalGroup){
				isHorizontalGroup = false;
				for(var i = 0; i < 360; i+= 180){
					_nextTile = findTileInDirection(tileGridPos[0], tileGridPos[1], i, 1, obj_board.playGrid);
					show_debug_message("Que pasa por aqui");
					if(_nextTile != -1){
						show_debug_message("Que miramos" + string(_nextTile) + "Posicion que estamso mirando " + string(_nextTile.tileGridPos));
						show_debug_message("Tiene Grupo horizontal " + string(_nextTile.isHorizontalGroup) + " es del mismo tipo" + string(_nextTile.tileType) + "/" + string(_startingTile.tileType) + " fichas");
						if(_nextTile.isHorizontalGroup && _nextTile.tileType == _startingTile.tileType){
							ds_stack_push(tilesToCheck, _nextTile);
						}
					}
				}
			}
		}
	}
	show_debug_message("Hemos destruido" + string(counterDestroy) + " fichas");
}
	
#endregion
	

#region Falling 


function fall(){
	if(fallCounter < 1){
		fallCounter = min(fallCounter + 1/fallTime, 1);
		tileGamePos = [smoothLerp(tileGridPos[0], tileGridPosNext[0], anc_fall, "Fall", fallCounter), smoothLerp(tileGridPos[1], tileGridPosNext[1], anc_fall, "Fall", fallCounter)];
		if(fallCounter == 1){
			tileGridPos = [tileGridPosNext[0], tileGridPosNext[1]];
		}
	}
}
	
function checkTileFall(){
	//Exit if no fall
	if(obj_board.playGrid[# tileGridPosNext[0], tileGridPosNext[1] + 1] != -1){return;}
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
			return;
		}
	}
	fallTime = (ds_grid_height(obj_board.playGrid) - 1 - tileGridPosNext[1])*5;
	fallCounter = 0;
	tileGridPosNext = [tileGridPosNext[0], ds_grid_height(obj_board.playGrid) - 1];
	//Update grid
	obj_board.playGrid[# tileGridPosNext[0], tileGridPosNext[1]] = id;
}

function checkAllTilesFall(){
//Comprobamos grupos y caidas
	for(var i = ds_grid_height(obj_board.playGrid) - 2; i >= 0; i--){
		for(var j = 0; j < ds_grid_width(obj_board.playGrid); j++){
			if(obj_board.playGrid[# j, i] != -1){
				with(obj_board.playGrid[# j, i]){
					checkTileFall();	
				}
			}
		}
	}	
}

#endregion


function isBoardFull(){
	for(var i = 0; i < ds_grid_width(obj_board.playGrid); i++){
		if(	obj_board.playGrid[# i, 0] == -1){
			return false;
		}	
	}
	return true;
}


