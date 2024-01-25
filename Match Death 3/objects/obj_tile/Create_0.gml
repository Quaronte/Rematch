/// @description Insert description here
// You can write your code in this editor

event_inherited();

enum tileT{melee, shield, range, magic, bomb, energy, coin};
enum attackT {melee, area, range, newTiles}

clickableFunctionOnHover	= BasicOnHover;
clickableFunctionOnDehover	= BasicOnDehover;
clickableFunctionOnSelect	= TileOnSelect;
clickableFunctionOnRelease	= TileOnRelease;

tileIsFromDeck = true;

tileType = 0;
tileGridPosNext = [-1, -1];
tileGridPos = [-1, -1];
tileGamePos = [-1, -1];
tileAngle = random_range(-3, 3);

tileTransform = -1;

tileGroup = -1;

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
breakingCounter = 0;