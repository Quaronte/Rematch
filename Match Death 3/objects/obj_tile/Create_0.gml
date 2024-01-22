/// @description Insert description here
// You can write your code in this editor


enum tileT{melee, shield, range, magic, energy, death};

tileType = 0;
tileGridPosNext = [-1, -1];
tileGridPos = [-1, -1];
tileGamePos = [-1, -1];
tileAngle = random_range(-3, 3);

isHover = false;
isSelected = false;

hoverCounter = 0;
selectedCounter = 0;

hoverScale = 0;

fallCounter = 1;
fallTime = 1;


isConsideringMove = false;
consideringMoveCounter = true;
isMoving = false;

swappingPartner = -1;

isReadyForPlay = false;
isVerticalGroup = true;
isHorizontalGroup = true;

isBreaking = false;
playingCounter = 0;