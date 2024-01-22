/// @description Insert description here
// You can write your code in this editor

enum gameS{menu, game, pause}
gameState = gameS.game;

randomize();


deck = ds_list_create();


initialTiles = 6;
//Rellenamos la baraja con casillas iniciales
for(var i = 0; i < initialTiles; i++){
	for(var j = 0; j <= tileT.energy; j++){
		ds_list_add(deck, j);
	}
}

function createGame(){
	instance_create_depth(0, 0, 0, obj_camera);
	instance_create_depth(0, 0, 0, obj_board);
	instance_create_depth(700, 400, 0, obj_button);
}

createGame();

//Debug variables
debugMode = false;


draw_set_font(fnt_debug);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);