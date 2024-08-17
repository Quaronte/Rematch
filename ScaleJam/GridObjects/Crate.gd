extends Moveable
class_name Crate



@onready var tile_map : TileMap

const CRATE_TILESET = preload("res://GridObjects/CrateTileset.tres")

func setup(_level : Level, _grid : Grid, _init_coord : Vector2i, _shape_coords : Array[Vector2i]):
	super.setup(_level, _grid, _init_coord, _shape_coords)
	next_coord = _init_coord
	tile_map = TileMap.new()
	add_child(tile_map)
	tile_map.position -= Vector2(Globals.CELL_SIZE, Globals.CELL_SIZE)/2
	tile_map.tile_set = CRATE_TILESET
	tile_map.set_cells_terrain_connect(0, shape_coords, 0, 0)

func _to_string():
	return "Crate"
