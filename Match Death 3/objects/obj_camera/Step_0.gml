/// @description Insert description here
// You can write your code in this editor

if(bounceCounter > 0){
	bounceCounter = max(0, bounceCounter - 1/30);
	if(bounceCounter == 0){
		offsetPos = [0, 0];	
	}
}


camera_set_view_pos(view_camera[0], -100, -100 + offsetPos[1]*SmoothLerp(0, 1, anc_fall, "CameraShake", bounceCounter));