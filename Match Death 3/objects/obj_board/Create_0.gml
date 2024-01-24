/// @description Insert description here
// You can write your code in this editor

enum boardS{playerTurn, enemyTurn}

boardState = boardS.playerTurn;

breakingMaxAnimationLength = 25;

clickableHovered = -1;
clickableSelected = -1;

isGroupBreaking = false;
breakingCounter = 0;

playGrid = ds_grid_create(5, 10);
ds_grid_clear(playGrid, -1);

enemyGridOffset = [6, 0];

enemyGrid = ds_grid_create(5, 10);
ds_grid_clear(enemyGrid, -1);

availableGroupsList = ds_list_create();




enemyStack = ds_stack_create();
enemyStackDelay = 10;
enemyStackDelayCounter = 0;

playingDeck = ds_list_create();
discardedDeck = ds_list_create();

ds_list_copy(playingDeck, obj_game.deck);
ds_list_shuffle(playingDeck);

var initialDeckSize = ds_list_size(playingDeck);
var initialTiles = 25;

//Guarantee that the first 4 lines are filled
for(var i = 0; i < 4; i++){
	for(var j = 0; j < ds_grid_width(playGrid); j++){
		DrawTileFromDeck([j, 0]);
	}
}

repeat(5){
	DrawTileFromDeck(-1);
}



CheckGroups();	


CreateEnemy(irandom(enemyT.enemy2), [irandom(2), 4]);
CreateEnemy(irandom(enemyT.enemy2), [irandom_range(3, 4), 5]);
CreateEnemy(irandom(enemyT.enemy2), [irandom(2), 6]);

movesPerTurn = 3;

remainingMoves = movesPerTurn;


