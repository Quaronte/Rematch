

function CreateEnemy(_enemyType, _pos) {
	if(_pos == -1){
	    do{
	        _pos = [irandom(ds_grid_width(obj_board.enemyGrid) - 1), irandom_range(4, ds_grid_height(obj_board.enemyGrid) - 3)];
	    }until obj_board.enemyGrid[# _pos[0], _pos[1]] == -1;
	}
    with(instance_create_depth(0, 0, 0, obj_enemy)){
    	
        enemyGridPos = [_pos[0], _pos[1]];
        // ShowDebug("Creating Enemy", enemyGridPos);
        enemyGridPosNext = [enemyGridPos[0], enemyGridPos[1]];
        enemyGamePos = [enemyGridPos[0], enemyGridPos[1]];
        
        enemyType = _enemyType;
        
        obj_board.enemyGrid[# enemyGridPos[0], enemyGridPos[1]] = id;
        
        EnemyChooseAction();
    }
    
}


function EnemyMove(){
	enemyGridPosNext = FindPosInDirection(enemyGridPos, dir.down, 1, obj_board.enemyGrid);
}

function EnemyAttack(){
	obj_board.playerHealth -= 1;
}

function EnemyChooseAction() {
	
	if(irandom(2) == 0){
		enemyNextActionScript = EnemyAttack;
	}
	else{
		enemyNextActionScript = EnemyMove;
	}
	
}


function EnemyHit(_typeAttack, _powerAttack){
	enemyHealth -= _powerAttack;
	enemyHealthCounter = 1;
	if(_typeAttack == tileT.magic){
		enemyNextActionScript = -1;
	}
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
			if(enemyNextActionScript > 0){
				script_execute(enemyNextActionScript);
			}
			enemyCounter = 0;
			return true;
		}
	}
	return true;
}

function DrawEnemy(){
	//Enemy
	var _enemySize = 1 + 0.1*hoverScale;
	draw_sprite_ext(spr_monsters, enemyType, x, y, _enemySize, _enemySize, enemyAngle, c_white, 1);
	shader_set(shd_flash);
	draw_sprite_ext(spr_monsters, enemyType, x, y, _enemySize, _enemySize, enemyAngle, c_white, enemyHealthCounter);
	shader_reset();
	
	if(enemyNextActionScript != -2){

		//Next Action
		var _nextActionSprite = -1;
		switch(enemyNextActionScript){
			case EnemyMove:
				_nextActionSprite = 1;
			break;
			case EnemyAttack:
				_nextActionSprite = 2;
			break;
			case -1:
				_nextActionSprite = 0;
			break;
		}
		shader_set(shd_flash);
		draw_sprite_ext(spr_nextAction, _nextActionSprite, x, y + sprite_get_height(spr_tiles)*_enemySize*3/4, 1, 1, 0, c_white, 1 - enemyCounter);
		shader_reset();
		
		draw_sprite_ext(spr_nextAction, _nextActionSprite, x, y + sprite_get_height(spr_tiles)*_enemySize*3/4, 1, 1, 0, c_white, 0.5 + 0.5*hoverScale);
	}
	
	//Health
	for(var i = 0; i < enemyCurrentHealth; i++){
		draw_sprite_ext(spr_health, 0, x - (sprite_get_width(spr_tiles)/2 - i*sprite_get_width(spr_tiles)/5)*_enemySize, y - (sprite_get_height(spr_tiles)/2)*_enemySize, 1 + 0.1*hoverScale, 1 + 0.1*hoverScale, enemyAngle, c_white, 1);
	}
	shader_set(shd_flash){
		for(var i = enemyHealth; i < enemyCurrentHealth; i++){
			draw_sprite_ext(spr_health, 0, x - (sprite_get_width(spr_tiles)/2 - i*sprite_get_width(spr_tiles)/5)*_enemySize, y - (sprite_get_height(spr_tiles)/2)*_enemySize, 1 + 0.1*hoverScale, 1 + 0.1*hoverScale, enemyAngle, c_white, enemyHealthCounter);
		}
	}
	shader_reset();
	
}