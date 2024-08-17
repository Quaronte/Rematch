extends Moveable
class_name Player


const PLAYER_TILESET = preload("res://GridObjects/PlayerTileset.tres")

func setup(_level : Level, _grid : Grid, _init_coord : Vector2i, _shape_coords : Array[Vector2i]):
	super.setup(_level, _grid, _init_coord, _shape_coords)
	next_coord = _init_coord
	tile_map = TileMap.new()
	add_child(tile_map)
	tile_map.position -= Vector2(Globals.CELL_SIZE, Globals.CELL_SIZE)/2
	tile_map.tile_set = PLAYER_TILESET
	tile_map.set_cells_terrain_connect(0, shape_coords, 0, 0)

func receive_input(current_input):
	return check_move(current_input)
	stumble(current_input)
	move(current_input)

func _to_string():
	return "Player"
