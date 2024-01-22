

function CreateEnemy(_enemyType) {
    do{
        var _pos = [irandom(ds_grid_width(obj_board.enemyGrid) - 1), irandom(ds_grid_height(obj_board.enemyGrid) - 1)];
    }until obj_board.enemyGrid[# _pos[0], _pos[1]] == -1;
    
    with(instance_create_depth(0, 0, 0, obj_enemy)){
        enemyGridPos = [_pos[0], _pos[1]];
        enemyGridPosNext = [enemyGridPos[0], enemyGridPos[1]];
        enemyGamePos = [enemyGridPos[0], enemyGridPos[1]];
        
        enemyType = _enemyType;
    }
    
}