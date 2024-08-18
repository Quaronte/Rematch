extends Moveable
class_name Player


const PLAYER_TILESET = preload("res://GridObjects/Tilesets/PlayerTileset.tres")

func setup(_level : Level, _grid : Grid, _init_coord : Vector2i, _shape_coords : Array[Vector2i]):
	super.setup(_level, _grid, _init_coord, _shape_coords)
	next_coord = _init_coord
	tile_map = TileMap.new()
	add_child(tile_map)
	tile_map.position -= Vector2(Globals.CELL_SIZE, Globals.CELL_SIZE)/2
	tile_map.tile_set = PLAYER_TILESET
	update_shape()

func receive_input(current_input):
	return check_move(current_input)
	stumble(current_input)
	move(current_input)


func check_embebed_move(move_dir : int) -> bool:
	var current_crate_in = grid.get_object_in_grid(pivot_coord)
	current_state = moveableState.CONSIDERING_MOVE
	for shape_coord in shape_coords:
		var looking_coord = grid.get_looking_pos(pivot_coord + shape_coord, move_dir )
		if grid.is_out_of_grid(looking_coord) || !level.has_floor(looking_coord): return false
		if grid.is_empty_coord(looking_coord): continue
		var object_in_tile = grid.get_object_in_grid(looking_coord)
		if object_in_tile == self: continue
		if object_in_tile == current_crate_in : continue
		if object_in_tile.current_state == moveableState.CONSIDERING_MOVE: continue
		if object_in_tile.check_move(move_dir): continue
		return false
	return true
	
func check_squish_move(move_dir : int) -> bool:
	current_state = moveableState.CONSIDERING_MOVE
	var objects_to_squish : Array
	for shape_coord in shape_coords:
		var looking_coord = grid.get_looking_pos(pivot_coord + shape_coord, move_dir )
		if grid.is_out_of_grid(looking_coord) || !level.has_floor(looking_coord): return false
		if grid.is_empty_coord(looking_coord): continue
		var object_in_tile = grid.get_object_in_grid(looking_coord)
		if object_in_tile == self: continue
		if objects_to_squish.has(object_in_tile): continue
		objects_to_squish.append(object_in_tile)
	print("Doing something", objects_to_squish)
	for object in objects_to_squish:
		print("SQUISHING???")
		object.squish(move_dir)
	return true
	
func check_player_move_freely(move_dir : int) -> bool:
	current_state = moveableState.CONSIDERING_MOVE
	for shape_coord in shape_coords:
		var looking_coord = grid.get_looking_pos(pivot_coord + shape_coord, move_dir )
		if grid.is_out_of_grid(looking_coord) || !level.has_floor(looking_coord): return false
	return true	

func is_player_big():
	
	return shape_coords.size() > 1

func _to_string():
	return "Player"
