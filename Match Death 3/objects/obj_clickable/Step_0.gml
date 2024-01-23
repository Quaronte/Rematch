/// @description Insert description here
// You can write your code in this editor



if(isHover){
	hoverCounter = min(hoverCounter + 1/8, 1);
	//hoverScale = SmoothLerp(0, 1, anc_effects, "HoverOn", hoverCounter);
	
}
else{
	hoverCounter = max(hoverCounter - 1/5, 0);
	//hoverScale = SmoothLerp(0, 1, anc_effects, "HoverOff", hoverCounter);
}


if(isSelected){
	selectedCounter = min(selectedCounter + 1/8, 1);
	//hoverScale = SmoothLerp(0, 1, anc_effects, "HoverOn", hoverCounter);
	
}
else{
	selectedCounter = max(selectedCounter - 1/25, 0);
	//hoverScale = SmoothLerp(0, 1, anc_effects, "HoverOff", hoverCounter);
}

hoverScale = SmoothLerp(0, 1, hoverAnim[0], hoverAnim[1], hoverCounter);
