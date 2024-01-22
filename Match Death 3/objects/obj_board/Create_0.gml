/// @description Insert description here
// You can write your code in this editor

enum boardS{playerTurn, enemyTurn}

boardState = boardS.playerTurn;

playingMaxAnimationLength = 25;

tileHovered = -1;
tileSelected = -1;

isGroupBreaking = false;
playingCounter = 0;

playGrid = ds_grid_create(5, 10);
ds_grid_clear(playGrid, -1);

enemyGrid = ds_grid_create(5, 10);
ds_grid_clear(enemyGrid, -1);


playingDeck = ds_list_create();
discardedDeck = ds_list_create();

ds_list_copy(playingDeck, obj_game.deck);
ds_list_shuffle(playingDeck);

var initialDeckSize = ds_list_size(playingDeck);
for(var i = 0; i < initialDeckSize; i++){
	CreateTileTopRandomPos(playingDeck[| 0]);
	ds_list_add(discardedDeck, playingDeck[| 0]);
	ds_list_delete(playingDeck, 0);
}

CheckGroups();	
movesPerTurn = 3;

currentMoves = 0;


