

function ButtonOnSelect(_object) {
    _object.isSelected = true;
    script_execute(_object.buttonSelectScript);
}

function ButtonOnRelease(_object) {
    _object.isSelected = false;
}


function ButtonEndTurn() {
    obj_board.boardState = boardS.enemyTurn;
    FillEnemyStack();
}
