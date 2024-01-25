// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#region Swapping

function TrySwapping(){
	var mouseGridPosition = GetGridMousePosition();
	if(obj_board.isGroupBreaking){ return; }
	if(IsOutOfGrid(mouseGridPosition, obj_board.playGrid)){ return; }
	
	
	//show_debug_message("Mouse Position" + string(mouseGridPosition));
	with(clickableSelected){
		//Si estamos terminando de movernos nos actualizamos
		if(isMoving){
			consideringMoveCounter = false;
			tileGridPos = [tileGridPosNext[0] , tileGridPosNext[1]];
			isMoving = false;
		}
		//Si ya estamos considerando un movimiento comprobamos si estamos volviendo al origen
		if(isConsideringMove){ 
			if(mouseGridPosition[0] == tileGridPos[0] && mouseGridPosition[1] == tileGridPos[1]){
				isConsideringMove = false;
				if(swappingPartner == -1){ return; }
				swappingPartner.isConsideringMove = false;
				swappingPartner = -1;
			}
			return; 
		}
		if(mouseGridPosition[0] != tileGridPos[0] || mouseGridPosition[1] != tileGridPos[1]){
			isConsideringMove = true;
			//Derecha
			if(mouseGridPosition[0] > tileGridPosNext[0]){
				tileGridPosNext = FindPosInDirection(tileGridPos, dir.right, 1, obj_board.playGrid);
			}
			//Arriba
			if(mouseGridPosition[1] < tileGridPosNext[1]){
				tileGridPosNext = FindPosInDirection(tileGridPos, dir.up, 1, obj_board.playGrid);
			}
			//Izquierda
			if(mouseGridPosition[0] < tileGridPosNext[0]){
				tileGridPosNext = FindPosInDirection(tileGridPos, dir.left, 1, obj_board.playGrid);
			}
			//Abajo
			if(mouseGridPosition[1] > tileGridPosNext[1]){
				tileGridPosNext = FindPosInDirection(tileGridPos, dir.down, 1, obj_board.playGrid);
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
	
function TryMakingSwap(_tileSwapping){
	with(_tileSwapping){
		//Apagamos la casilla
		isSelected = false;
		depth = 0;
		//Vemos si tenemos que movernos
		if(isConsideringMove){
			//Actualizamos el tile y la grid de juego
			obj_board.playGrid[# tileGridPos[0], tileGridPos[1]] = -1;
			// tileGridPos = [tileGridPosNext[0], tileGridPosNext[1]];
			isConsideringMove = false;
			isMoving = true;
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
					CheckAndMarkGroup(i, j, _currentStreak, _currentType, true);
					_currentStreak = 0;
				}
				//Añadimos a nuestra cadena
				_currentStreak++;			
			}
			else{
				CheckAndMarkGroup(j, i, _currentStreak, _currentType, false);
				_currentStreak = 0;
			}
			_currentType = _currentCell == -1 ? -1 : _currentCell.tileType;
		}	
		//En la última tenemos que comprobar si 
		CheckAndMarkGroup(i, j, _currentStreak, _currentType, true);
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
					CheckAndMarkGroup(j, i, _currentStreak, _currentType, false);
					_currentStreak = 0;
				}
				//Añadimos a nuestra cadena
				_currentStreak++;	
			}
			else{
				CheckAndMarkGroup(j, i, _currentStreak, _currentType, false);
				_currentStreak = 0;
			}
			_currentType = _currentCell == -1 ? -1 : _currentCell.tileType;
		}
		CheckAndMarkGroup(j, i, _currentStreak, _currentType, false);
		_currentStreak = 0;
		_currentType = -2;
	}
	IdentifyAllGroups();
}

function CheckAndMarkGroup(_i, _j, _currentStreak, _groupType, _isVertical){
	
	if(_groupType < 0){ return; }
	var _groupMinSizes = [3, 3, 3, 3, 3, 3, 1];
	var _groupSize = _groupMinSizes[_groupType];
		
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



function IdentifyAllGroups(){
	ClearAllGroups();
	var _group = 0;
	with(obj_tile){
		if(isReadyForPlay && tileGroup = -1){
			IdentifyGroup(id, _group);
			_group++;
		}
	}
}

function IdentifyGroup(_startingTile, _group){
	var tilesToCheck = ds_stack_create();
	ds_stack_push(tilesToCheck, _startingTile);
	var _counterDestroy = 0;
	var _nextTile = 0;
	var _groupProperties = [0, 0];
	var _isPartOfTheGroup = false;
	while(!ds_stack_empty(tilesToCheck)){
		_isPartOfTheGroup = false;
		with(ds_stack_pop(tilesToCheck)){
			if(isVerticalGroup && tileGroup != _group){
				_isPartOfTheGroup = true;
				_groupProperties[1]++;
				for(var i = 90; i < 360; i+= 180){
					_nextTile = FindCellInDirection(tileGridPosNext, i, 1, obj_board.playGrid);
					if(_nextTile != -1 && _nextTile != -2){
						if(_nextTile.isVerticalGroup && _nextTile.tileType == _startingTile.tileType){
							ds_stack_push(tilesToCheck, _nextTile);
						}
					}
				}
			}
			if(isHorizontalGroup && tileGroup != _group){
				_isPartOfTheGroup = true;
				_groupProperties[0]++;
				for(var i = 0; i < 360; i+= 180){
					_nextTile = FindCellInDirection(tileGridPosNext, i, 1, obj_board.playGrid);
					if(_nextTile != -1 && _nextTile != -2){
						if(_nextTile.isHorizontalGroup && _nextTile.tileType == _startingTile.tileType){
							ds_stack_push(tilesToCheck, _nextTile);
						}
					}
				}
			}
			if(_isPartOfTheGroup){
				tileGroup = _group;
				_counterDestroy++;
			}
		}
	}
	
	//Añadimos 
	ds_list_add(obj_board.availableGroupsList, new CreateGroup(_group, _startingTile.tileType, _groupProperties, _counterDestroy));
	return true;
}

function CreateHighlightElement(_type, _grid, _pos) constructor{
	highlightElementPos = _pos;
	highlightElementGrid = _grid;
	highlightElementType = _type;
}

function CreateGroup(_groupNumber, _groupType, _properties, _totalNumber) constructor{
	ShowDebug("Creando Grupo", _groupType, _properties);
	groupType = _groupType;
	groupProperties = _properties;
	groupTotalNumber = _totalNumber;
	groupIntersections = (groupProperties[0] + groupProperties[1]) - groupTotalNumber;
	groupActions = [-1, -1];
	groupAttackPower = [0, 0];
	groupHighlights = ds_map_create();
	
	//Escogemos las posiciones a las que afecta el poder
	switch(_groupType){
		case tileT.melee:
			if(groupProperties[0] != 0){
				groupAttackPower[0] = groupProperties[0];
				with(obj_tile){
					if(tileGroup == _groupNumber && isHorizontalGroup){
						// ShowDebug("Se reconoce como candidato");
						if(ds_map_find_value(other.groupHighlights, string([0, tileGridPosNext[1]])) == undefined){
							for(var i = 0; i < 3; i++){
								// ShowDebug("Se guarda la posicion", [i, tileGridPosNext[1]]);
								var _currentPos = [i, tileGridPosNext[1]];
								ds_map_add(other.groupHighlights, string(_currentPos), new CreateHighlightElement(_groupType, obj_board.enemyGrid, _currentPos));
							}
						}
					}
				}
			}
			if(groupProperties[1] != 0){
				HighlightCoins(groupHighlights, _groupNumber);
			}
			break;
		case tileT.range:
		case tileT.magic:
			if(groupProperties[0] != 0){
				groupAttackPower[0] = groupProperties[0] - 2;
				with(obj_tile){
					if(tileGroup == _groupNumber && isHorizontalGroup){
						if(ds_map_find_value(other.groupHighlights, string([0, tileGridPosNext[1]])) == undefined){
							for(var i = 0; i < ds_grid_width(obj_board.enemyGrid); i++){
								var _currentPos = [i, tileGridPosNext[1]];
								ds_map_add(other.groupHighlights, string(_currentPos), new CreateHighlightElement(_groupType, obj_board.enemyGrid, _currentPos));
								//Salimos de aqui
								if(obj_board.enemyGrid[# i, tileGridPosNext[1]] != -1){
									i = ds_grid_width(obj_board.enemyGrid);
								}
							}
						}
					}
				}
			}
			if(groupProperties[1] != 0){
				HighlightCoins(groupHighlights, _groupNumber);
			}
			break;
		case tileT.shield:
		case tileT.bomb:
			if(groupProperties[0] != 0){
				groupAttackPower[0] = groupProperties[0] - 2;
				with(obj_tile){
					if(tileGroup == _groupNumber && isHorizontalGroup){
						ds_map_add(other.groupHighlights, string(tileGridPosNext), new CreateHighlightElement(_groupType, obj_board.enemyGrid, tileGridPosNext));
					}
				}
			}
			if(groupProperties[1] != 0){
				HighlightCoins(groupHighlights, _groupNumber);
			}
			break;
		case tileT.energy:
			if(groupProperties[0] != 0){
				groupAttackPower[0] = 2*groupProperties[0] - 1;
				with(obj_tile){
					if(tileGroup == _groupNumber && isHorizontalGroup){
						if(ds_map_find_value(other.groupHighlights, string([0, 0])) == undefined){
							for(var i = 0; i < ds_grid_width(obj_board.playGrid); i++){
								var _currentPos = [i, 0];
								ds_map_add(other.groupHighlights, string(_currentPos), new CreateHighlightElement(_groupType, obj_board.playGrid, _currentPos));
							}
						}
					}
				}
			}
			if(groupProperties[1] != 0){
				HighlightCoins(groupHighlights, _groupNumber);
			}
			break;
	}
	
	ShowDebug("Terminamos con ", ds_map_size(groupHighlights));
	
}

function HighlightCoins(_currentGroup, _groupNumber){
	var _horizontalPos = 0;
	var _lowestVerticalPos = 0;

	with(obj_tile){
		if(tileGroup == _groupNumber && isVerticalGroup){
			_horizontalPos = tileGridPosNext[0];
			_lowestVerticalPos = max(_lowestVerticalPos, tileGridPosNext[1]);
		}
	}
	groupAttackPower[1] = groupProperties[1] - 2;
	var _currentPos = -1;
	for(var i = 0; i < groupAttackPower[1]; i++){
	
		_currentPos = [_horizontalPos, _lowestVerticalPos - i];
		ShowDebug("Creamos monedas en", _currentPos);
		ds_map_add(_currentGroup, string(_currentPos), new CreateHighlightElement(tileT.coin, obj_board.playGrid, _currentPos));
	}
	for(var i = 0; i < groupProperties[1]; i++){
		_currentPos = [_horizontalPos, i];
		ds_map_add(_currentGroup, string(_currentPos), new CreateHighlightElement(tileT.energy, obj_board.playGrid, _currentPos));
	}
}

function ClearAllGroups(){
	for(var i = 0; i < ds_list_size(obj_board.availableGroupsList); i++){
		var _currentGroup = obj_board.availableGroupsList[| i];
		var _currentGroupHighlightsArray = ds_map_values_to_array(_currentGroup.groupHighlights);
		for(var j = 0; j < array_length(_currentGroupHighlightsArray); j++){
			delete _currentGroupHighlightsArray[j]
		}
		ds_map_destroy(_currentGroup.groupHighlights);
		delete obj_board.availableGroupsList[| i];
	}
	ds_list_clear(obj_board.availableGroupsList);
	with(obj_tile){
		tileGroup = -1;
	}
}

function TryBreakingGroup(_group){
	if(isGroupBreaking || _group == -1){ return false; }
		
	isGroupBreaking = true;
	
	//Buscamos el grupo necesario
	with(obj_board.availableGroupsList[| _group]){
		var _currentGroupHighlightsMap = ds_map_values_to_array(groupHighlights);
		for(var i = 0; i < array_length(_currentGroupHighlightsMap); i++){
			var _currentGroupHighlightsElement = _currentGroupHighlightsMap[i];	
			var _currentCell = _currentGroupHighlightsElement.highlightElementGrid[# _currentGroupHighlightsElement.highlightElementPos[0], _currentGroupHighlightsElement.highlightElementPos[1]];
			switch(_currentGroupHighlightsElement.highlightElementType){
				case tileT.melee:
					if( _currentCell != -1){
						with(_currentCell){
							script_execute(enemyHitScript, other.groupType, other.groupAttackPower[0]);
						}
					}
					break;
				case tileT.range:
					if( _currentCell != -1){
						with(_currentCell){
							script_execute(enemyHitScript, other.groupType, other.groupAttackPower[0]);
						}
					}
					break;
				case tileT.magic:
					if( _currentCell != -1){
						with(_currentCell){
							script_execute(enemyHitScript, other.groupType, other.groupAttackPower[0]);
						}
					}
					break;
				case tileT.shield:
					if( _currentCell != -1){
						with(_currentCell){
							script_execute(enemyHitScript, other.groupType, other.groupAttackPower[0]);
						}
					}
					break;
				case tileT.bomb:
					if( _currentCell != -1){
						with(_currentCell){
							script_execute(enemyHitScript, other.groupType, other.groupAttackPower[0]);
						}
					}
					break;
				case tileT.energy:
					obj_board.breakingMaxAnimationLength = 40;
					DrawTileFromDeck([_currentGroupHighlightsElement.highlightElementPos[0], _currentGroupHighlightsElement.highlightElementPos[1]]);
					break;
				case tileT.coin:
					if( _currentCell != -1){
						with(_currentCell){
							tileTransform = tileT.coin;
						}
					}
					break;
			}
		}
	}
	
	with(obj_tile){
		if(tileGroup == _group){
			if(tileType == tileT.coin){
				obj_board.playerCoins++;
			}
			isBreaking = true;
			isVerticalGroup = false;
			isHorizontalGroup = false;
		}
	}
}
	
#endregion
	

#region Falling 


function Fall(){
	if(fallCounter < 1){
		fallCounter = min(fallCounter + 1/(5*fallTime), 1);
		tileGamePos = [SmoothLerp(tileGridPos[0], tileGridPosNext[0], anc_fall, "Fall", fallCounter), SmoothLerp(tileGridPos[1], tileGridPosNext[1], anc_fall, "Fall", fallCounter)];
		if(fallCounter == 1){
			tileGridPos = [tileGridPosNext[0], tileGridPosNext[1]];
		}
	}
}

function TryToFall(){
	if(UpdateTileFall()){
		tileGridPosNext = FindPosInDirection(tileGridPos, dir.down, fallTime, obj_board.playGrid);
		fallCounter = 0;
		isSelected = false;
		obj_camera.offsetPos[1] -= fallTime*5/2;
		obj_camera.bounceCounter = 1;
		
		obj_board.playGrid[# tileGridPosNext[0], tileGridPosNext[1]] = id;
		
		obj_board.clickableSelected = obj_board.clickableSelected == id ? -1 : obj_board.clickableSelected;	
	}
	
}
	
function UpdateTileFall(){
	//Exit if no Fall, don't check -2 because we never check last row
	if(FindCellInDirection(tileGridPosNext, dir.down, 1, obj_board.playGrid) != -1){return false;}
	
	if(isMoving){
		isMoving = false;
		consideringMoveCounter = 0;
		tileGridPos = [tileGridPosNext[0], tileGridPosNext[1]];
	}
	//Eliminate trace from the grid
	obj_board.playGrid[# tileGridPosNext[0], tileGridPosNext[1]] = -1;
	for(var i = tileGridPosNext[1] + 1; i < ds_grid_height(obj_board.playGrid); i++){
		if(obj_board.playGrid[# tileGridPosNext[0], i] != -1){
			fallTime = (i - 1 - tileGridPosNext[1]);
			return true;
		}
	}
	fallTime = (ds_grid_height(obj_board.playGrid) - 1 - tileGridPosNext[1]);
	return true;
}

function CheckAllTilesFall(){
//Comprobamos grupos y caidas
	for(var i = ds_grid_height(obj_board.playGrid) - 2; i >= 0; i--){
		for(var j = 0; j < ds_grid_width(obj_board.playGrid); j++){
			if(obj_board.playGrid[# j, i] != -1){
				with(obj_board.playGrid[# j, i]){
					TryToFall();
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


