/// @description Insert description here
// You can write your code in this editor




fall();


x = tileGamePos[0] * sprite_get_height(spr_tiles);
y = tileGamePos[1] * sprite_get_height(spr_tiles);

if(isHover){
	hoverCounter = min(hoverCounter + 1/8, 1);
	hoverScale = smoothLerp(0, 1, anc_effects, "HoverOn", hoverCounter);
	
}
else{
	hoverCounter = max(hoverCounter - 1/25, 0);
	hoverScale = smoothLerp(0, 1, anc_effects, "HoverOff", hoverCounter);
}


if(isConsideringMove){
	consideringMoveCounter = min(consideringMoveCounter + 1/25, 1);
	tileGamePos = [smoothLerp(tileGridPos[0], tileGridPosNext[0], anc_fall, "Fall", consideringMoveCounter), smoothLerp(tileGridPos[1], tileGridPosNext[1], anc_fall, "Fall", consideringMoveCounter)];
	
}
else{
	consideringMoveCounter = max(consideringMoveCounter - 1/8, 0);
	tileGamePos = [smoothLerp(tileGridPos[0], tileGridPosNext[0], anc_fall, "Fall", consideringMoveCounter), smoothLerp(tileGridPos[1], tileGridPosNext[1], anc_fall, "Fall", consideringMoveCounter)];
}


if(isPlaying){
	playingCounter = min(playingCounter + 1/25, 1);
	//tileGamePos = [smoothLerp(tileGridPos[0], tileGridPosNext[0], anc_fall, "Fall", consideringMoveCounter), smoothLerp(tileGridPos[1], tileGridPosNext[1], anc_fall, "Fall", consideringMoveCounter)];

}

//function updateCounter(_counterOn, _counter, _increase, _decrease){
//	if(_counterOn){
//		_counter = min(_counter + 1/8, 1);
//		hoverScale = smoothLerp(0, 1, anc_effects, "HoverOn", hoverCounter);
	
//	}
//	else{
//		_counter = max(_counter - 1/25, 0);
//		hoverScale = smoothLerp(0, 1, anc_effects, "HoverOff", hoverCounter);
//	}
//}