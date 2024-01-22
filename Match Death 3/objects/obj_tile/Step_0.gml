/// @description Insert description here
// You can write your code in this editor




Fall();


x = tileGamePos[0] * sprite_get_height(spr_tiles);
y = tileGamePos[1] * sprite_get_height(spr_tiles);

if(isHover){
	hoverCounter = min(hoverCounter + 1/8, 1);
	hoverScale = SmoothLerp(0, 1, anc_effects, "HoverOn", hoverCounter);
	
}
else{
	hoverCounter = max(hoverCounter - 1/25, 0);
	hoverScale = SmoothLerp(0, 1, anc_effects, "HoverOff", hoverCounter);
}


if(isConsideringMove || isMoving){
	consideringMoveCounter = min(consideringMoveCounter + 1/25, 1);
	tileGamePos = [SmoothLerp(tileGridPos[0], tileGridPosNext[0], anc_fall, "Fall", consideringMoveCounter), SmoothLerp(tileGridPos[1], tileGridPosNext[1], anc_fall, "Fall", consideringMoveCounter)];
	if(isMoving && consideringMoveCounter == 1){
		tileGridPos = [tileGridPosNext[0] , tileGridPosNext[1]];
		isMoving = false;
		swappingPartner = -1;
	}
	
}
else{
	consideringMoveCounter = max(consideringMoveCounter - 1/8, 0);
	tileGamePos = [SmoothLerp(tileGridPos[0], tileGridPosNext[0], anc_fall, "Fall", consideringMoveCounter), SmoothLerp(tileGridPos[1], tileGridPosNext[1], anc_fall, "Fall", consideringMoveCounter)];
}


if(isBreaking){
	playingCounter = min(playingCounter + 1/25, 1);
	//tileGamePos = [SmoothLerp(tileGridPos[0], tileGridPosNext[0], anc_fall, "Fall", consideringMoveCounter), SmoothLerp(tileGridPos[1], tileGridPosNext[1], anc_fall, "Fall", consideringMoveCounter)];

}

//function updateCounter(_counterOn, _counter, _increase, _decrease){
//	if(_counterOn){
//		_counter = min(_counter + 1/8, 1);
//		hoverScale = SmoothLerp(0, 1, anc_effects, "HoverOn", hoverCounter);
	
//	}
//	else{
//		_counter = max(_counter - 1/25, 0);
//		hoverScale = SmoothLerp(0, 1, anc_effects, "HoverOff", hoverCounter);
//	}
//}