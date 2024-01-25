/// @description Insert description here
// You can write your code in this editor

//Clickable behaviour
event_inherited();

if(enemyCounter < 1){
    enemyCounter = min(enemyCounter + 0.05, 1);
    
    if(enemyCounter == 1){
        obj_board.enemyGrid[# enemyGridPos[0], enemyGridPos[1]] = -1;
        enemyGridPos = [enemyGridPosNext[0], enemyGridPosNext[1]];
        obj_board.enemyGrid[# enemyGridPos[0], enemyGridPos[1]] = id;
        enemyNextActionScript = -2;
    }
}

switch(enemyNextActionScript){
	case EnemyAttack:
		enemyGamePos = [SmoothLerp(enemyGridPos[0], enemyGridPos[0], anc_fall, "Fall", dsin(180*enemyCounter)), lerp(enemyGridPos[1], enemyGridPos[1] + 0.3, dsin(180*enemyCounter))];
	break;
	default:
		enemyGamePos = [SmoothLerp(enemyGridPos[0], enemyGridPosNext[0], anc_fall, "Fall", enemyCounter), SmoothLerp(enemyGridPos[1], enemyGridPosNext[1], anc_fall, "Fall", enemyCounter)];
	break;
}

x = sprite_get_width(spr_tiles)*obj_board.enemyGridOffset[0] + enemyGamePos[0] * sprite_get_height(spr_tiles);
y = enemyGamePos[1] * sprite_get_height(spr_tiles);

if(enemyHealth != enemyCurrentHealth){
    enemyHealthCounter -= 0.1;
    if(enemyHealthCounter == 0){
        enemyCurrentHealth = enemyHealth;
        if(enemyCurrentHealth <= 0){
			obj_board.enemyGrid[# enemyGridPos[0], enemyGridPos[1]] = -1;
            instance_destroy();
        }
    }
}