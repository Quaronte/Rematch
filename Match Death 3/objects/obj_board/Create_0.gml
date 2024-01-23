/// @description Insert description here
// You can write your code in this editor

enum boardS{playerTurn, enemyTurn}

boardState = boardS.playerTurn;

playingMaxAnimationLength = 25;

clickableHovered = -1;
clickableSelected = -1;

isGroupBreaking = false;
playingCounter = 0;

playGrid = ds_grid_create(5, 10);
ds_grid_clear(playGrid, -1);

enemyGridOffset = [6, 0];

enemyGrid = ds_grid_create(5, 10);
ds_grid_clear(enemyGrid, -1);


playingDeck = ds_list_create();
discardedDeck = ds_list_create();


enemyStack = ds_stack_create();
enemyStackDelay = 10;
enemyStackDelayCounter = 0;

ds_list_copy(playingDeck, obj_game.deck);
ds_list_shuffle(playingDeck);

var initialDeckSize = ds_list_size(playingDeck);
for(var i = 0; i < initialDeckSize; i++){
	CreateTileTopRandomPos(playingDeck[| 0]);
	ds_list_add(discardedDeck, playingDeck[| 0]);
	ds_list_delete(playingDeck, 0);
}

CheckGroups();	

repeat(5){
	CreateEnemy(irandom(enemyT.enemy2));
}
movesPerTurn = 3;

remainingMoves = movesPerTurn;


