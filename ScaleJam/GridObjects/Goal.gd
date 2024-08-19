extends Static
class_name Goal



var sprites : Array
const TELEPORT_1 = preload("res://Sprites/Teleport1.png")
const TELEPORT_2 = preload("res://Sprites/Teleport2.png")
const GOAL_TILESET = preload("res://GridObjects/Tilesets/GoalTileset.tres")


func setup(_level, _grid, _init_coord, _shape_coords):
	super.setup(_level, _grid, _init_coord, _shape_coords)
	tile_map = TileMap.new()
	add_child(tile_map)
	tile_map.position -= Vector2(Globals.CELL_SIZE, Globals.CELL_SIZE)/2
	tile_map.tile_set = GOAL_TILESET
	update_shape()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update_sprite(_sprite : Texture):
	for sprite in sprites:
		sprite.texture = _sprite


func check_activation():
	activate()
	deactivate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _to_string():
	return "Teleport"
