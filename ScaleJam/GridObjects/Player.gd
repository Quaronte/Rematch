extends Moveable
class_name Player


const PLAYER_TILESET = preload("res://GridObjects/Tilesets/PlayerTileset.tres")

func setup(_level : Level, _grid : Grid, _init_coord : Vector2i, _shape_coords : Array[Vector2i]):
	super.setup(_level, _grid, _init_coord, _shape_coords)
	tile_map = TileMap.new()
	add_child(tile_map)
	tile_map.position -= Vector2(Globals.CELL_SIZE, Globals.CELL_SIZE)/2
	tile_map.tile_set = PLAYER_TILESET
	update_shape()

func receive_input(current_input):
	return check_move(current_input)


func check_embebed_move(move_dir : int) -> bool:
	var current_crate_in = grid.get_object_in_grid(pivot_coord)
	for shape_coord in shape_coords:
		var looking_coord = grid.get_looking_pos(pivot_coord + shape_coord, move_dir )
		if grid.is_out_of_grid(looking_coord) || !level.has_floor(looking_coord): 
			current_state = moveableState.STUMBLE
			return false
		if grid.is_empty_coord(looking_coord): continue
		var object_in_tile = grid.get_object_in_grid(looking_coord)
		if object_in_tile == self: continue
		if object_in_tile == current_crate_in : continue
		if object_in_tile.is_considering_moving(): continue
		if object_in_tile.check_move(move_dir): continue
		current_state = moveableState.STUMBLE
		return false
	return true
	
func check_squish_move(move_dir : int) -> bool:
	var objects_to_squish : Array
	var valid_squish = true
	for shape_coord in shape_coords:
		var looking_coord = grid.get_looking_pos(pivot_coord + shape_coord, move_dir )
		if grid.is_out_of_grid(looking_coord) || !level.has_floor(looking_coord): 
			current_state = moveableState.STUMBLE
			return false
		if grid.is_empty_coord(looking_coord): continue
		var object_in_tile = grid.get_object_in_grid(looking_coord)
		if object_in_tile == self: continue
		if object_in_tile.current_state == object_in_tile.moveableState.MOVE: continue
		if objects_to_squish.has(object_in_tile): continue
		objects_to_squish.append(object_in_tile)
	for object in objects_to_squish:
		var can_squish = object.check_squish(move_dir)
		if !can_squish:
			object.current_state = moveableState.TOOSMALL
			valid_squish = false
	if !valid_squish: 
		return false
	for object in objects_to_squish:
		object.squish(move_dir)
	return true
	
func check_player_move_freely(move_dir : int) -> bool:
	for shape_coord in shape_coords:
		var looking_coord = grid.get_looking_pos(pivot_coord + shape_coord, move_dir )
		if grid.is_out_of_grid(looking_coord) || !level.has_floor(looking_coord): return false
	return true	

func is_applying_big_force(_dir: int) -> bool:
	match _dir:
		0, 2:
			return size.y > 1
		1, 3:
			return size.x > 1
		_:
			return false


func is_fully_inmersed_in_slime() -> bool:
	var inmersed_in_candidate = grid.get_object_in_grid(pivot_coord)
	if grid.is_empty_coord(pivot_coord) || inmersed_in_candidate == self: return false
		
	for shape_coord in shape_coords:
		if grid.get_object_in_grid(pivot_coord + shape_coord) != inmersed_in_candidate: return false
	
	print("Player fully inmersed")
	return true

func is_partially_inmersed_in_slime() -> bool:
	var inmersed_in_candidate = grid.get_object_in_grid(pivot_coord)	
	for shape_coord in shape_coords:
		if grid.get_object_in_grid(pivot_coord + shape_coord) != inmersed_in_candidate: 
			print("Player partially inmersed")
			return true
	return false
	
func _to_string():
	return "Player"
