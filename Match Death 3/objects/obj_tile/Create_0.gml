/// @description Insert description here
// You can write your code in this editor

event_inherited();

enum tileT{melee, shield, range, magic, energy, death};

clickableFunctionOnHover	= TileOnHover;
clickableFunctionOnDehover	= TileOnDehover;
clickableFunctionOnSelect	= TileOnSelect;
clickableFunctionOnRelease	= TileOnRelease;


tileType = 0;
tileGridPosNext = [-1, -1];
tileGridPos = [-1, -1];
tileGamePos = [-1, -1];
tileAngle = random_range(-3, 3);



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