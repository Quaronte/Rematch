

function CreateEnemy(_enemyType) {
	var _pos = [-1, -1];
    do{
        _pos = [irandom(ds_grid_width(obj_board.enemyGrid) - 1), irandom_range(4, ds_grid_height(obj_board.enemyGrid) - 3)];
    }until obj_board.enemyGrid[# _pos[0], _pos[1]] == -1;
    
    with(instance_create_depth(0, 0, 0, obj_enemy)){
    	
        enemyGridPos = [_pos[0], _pos[1]];
        // ShowDebug("Creating Enemy", enemyGridPos);
        enemyGridPosNext = [enemyGridPos[0], enemyGridPos[1]];
        enemyGamePos = [enemyGridPos[0], enemyGridPos[1]];
        
        enemyType = _enemyType;
        
        obj_board.enemyGrid[# enemyGridPos[0], enemyGridPos[1]] = id;
    }
    
}


function EnemyMove(){
	enemyGridPosNext = FindPosInDirection(enemyGridPos, dir.down, 1, obj_board.enemyGrid);
}

function EnemyAttack(){
	ShowDebug("EnemyAttack");
	enemyGridPosNext = FindPosInDirection(enemyGridPos, dir.up, 1, obj_board.enemyGrid);
}

function ChooseActionEnemy() {
	var _nextCell = FindCellInDirection(enemyGridPos, dir.down, 1, obj_board.enemyGrid);
	
	//Last Line
	if(_nextCell == -2){
		script_execute(enemyLastActionScript);
		return;
	}
	
	//Normal line
	script_execute(enemyBasicActionScript);
}

function FillEnemyStack(){
	for(var i = 0; i < ds_grid_height(obj_board.enemyGrid); i++){
		for(var j = 0; j < ds_grid_width(obj_board.enemyGrid); j++){
			if(obj_board.enemyGrid[# j, i] != -1){
				ds_stack_push(obj_board.enemyStack, obj_board.enemyGrid[# j, i]);
			}
		}
	}
}

function ExecuteEnemyStack(){
	
	enemyStackDelayCounter += 1;
	if(enemyStackDelayCounter == enemyStackDelay){
		enemyStackDelayCounter = 0;
		if(ds_stack_empty(enemyStack)){
			return false;
		}
		with(ds_stack_pop(enemyStack)){
			ChooseActionEnemy();
			enemyCounter = 0;
			return true;
		}
	}
	return true;
}