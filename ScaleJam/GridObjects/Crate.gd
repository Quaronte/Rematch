extends Moveable
class_name Crate

const CRATE_TILESET = preload("res://GridObjects/Tilesets/CrateTileset.tres")
const CRATE_TILESET2 = preload("res://GridObjects/Tilesets/Crate2Tileset.tres")
const CRATE_TILESET3 = preload("res://GridObjects/Tilesets/Crate3Tileset.tres")

func setup(_level : Level, _grid : Grid, _init_coord : Vector2i, _shape_coords : Array[Vector2i]):
	super.setup(_level, _grid, _init_coord, _shape_coords)
	next_coord = _init_coord
	tile_map = TileMap.new()
	add_child(tile_map)
	tile_map.position -= Vector2(Globals.CELL_SIZE, Globals.CELL_SIZE)/2
	tile_map.tile_set = CRATE_TILESET
	tile_map.set_cells_terrain_connect(0, shape_coords, 0, 0)


func try_to_grow(_grow_dir: int):
	var _grow_vector = grid.get_dir_vector(_grow_dir)
	current_state = moveableState.IDLE
	var possible_grow_coords : Array
	for shape_coord in shape_coords:
		var new_shape_coord = shape_coord + _grow_vector
		if shape_coords.has(new_shape_coord): continue
		if grid.is_out_of_grid(pivot_coord + new_shape_coord) || !level.has_floor(pivot_coord + new_shape_coord): return false
		if grid.is_empty_coord(pivot_coord + new_shape_coord): 
			possible_grow_coords.append(new_shape_coord)
			continue
		var new_object = grid.get_object_in_grid(pivot_coord + new_shape_coord)
		if new_object.check_move(_grow_dir) == moveableState.STUMBLE: 
			return false
		possible_grow_coords.append(new_shape_coord)
	for new_coord in possible_grow_coords:
		shape_coords.append(new_coord)
	tile_map.set_cells_terrain_connect(0, shape_coords, 0, 0)
	return true


func check_squish(_squish_dir: int):
	print("Checking - ", shape_coords, " ", pivot_coord)
	var min_values = Vector2i(0, 0)
	var max_values = Vector2i(0, 0)
	for shape_coord in shape_coords:
		min_values.x = min(min_values.x, shape_coord.x)
		min_values.y = min(min_values.y, shape_coord.y)
		
		max_values.x = max(max_values.x, shape_coord.x)
		max_values.y = max(max_values.y, shape_coord.y)
	
	var positions_to_remove : Array
	match _squish_dir:
		0:
			for shape_coord in shape_coords:
				if shape_coord.x == min_values.x: 
					positions_to_remove.append(shape_coord)
		1:	
			for shape_coord in shape_coords:
				if shape_coord.y == max_values.y: 
					positions_to_remove.append(shape_coord)
		2:
			for shape_coord in shape_coords:
				if shape_coord.x == max_values.x: 
					positions_to_remove.append(shape_coord)
		3:
			for shape_coord in shape_coords:
				if shape_coord.y == min_values.y: 
					positions_to_remove.append(shape_coord)
	
	if positions_to_remove.size() == shape_coords.size():
		print("We choose to not squish!")
		return false
	print("We chose to squish ", shape_coords, " ", pivot_coord)
	return true

func is_partially_or_fully_inmersed_in_object(object) -> bool:
	var my_coords = get_all_coords()
	var other_coords = object.get_all_coords()
	for coord in my_coords:
		if other_coords.has(coord): 
			print("Inmersed in player")
			return true
	return false

func squish(_squish_dir: int):
	print("Starting shape - ", shape_coords, " ", pivot_coord)
	current_state = moveableState.SQUISH
	remove_object_from_grid()
	var min_values = Vector2i(0, 0)
	var max_values = Vector2i(0, 0)
	for shape_coord in shape_coords:
		min_values.x = min(min_values.x, shape_coord.x)
		min_values.y = min(min_values.y, shape_coord.y)
		
		max_values.x = max(max_values.x, shape_coord.x)
		max_values.y = max(max_values.y, shape_coord.y)
	
	var positions_to_remove : Array
	match _squish_dir:
		0:
			for shape_coord in shape_coords:
				if shape_coord.x == min_values.x: 
					positions_to_remove.append(shape_coord)
			if min_values.x == 0:
				for i in shape_coords.size():
					if positions_to_remove.has(shape_coords[i]): continue
					shape_coords[i].x -= 1
				pivot_coord.x += 1
		1:	
			for shape_coord in shape_coords:
				if shape_coord.y == max_values.y: 
					positions_to_remove.append(shape_coord)
			if max_values.y == 0:
				for i in shape_coords.size():
					if positions_to_remove.has(shape_coords[i]): continue
					shape_coords[i].y += 1
				pivot_coord.y -= 1
			pass
		2:
			for shape_coord in shape_coords:
				if shape_coord.x == max_values.x: 
					positions_to_remove.append(shape_coord)
			if max_values.x == 0:
				for i in shape_coords.size():
					if positions_to_remove.has(shape_coords[i]): continue
					shape_coords[i].x += 1
				pivot_coord.x -= 1
			pass
		3:
			for shape_coord in shape_coords:
				if shape_coord.y == min_values.y: 
					positions_to_remove.append(shape_coord)
			if min_values.y == 0:
				for i in shape_coords.size():
					if positions_to_remove.has(shape_coords[i]): continue
					shape_coords[i].y -= 1
				pivot_coord.y += 1
			pass
	
	for position_removed in positions_to_remove:
		shape_coords.erase(position_removed)
	update_shape()
	place_object(pivot_coord)
	print("Final shape coors when squishing ", shape_coords, " ", pivot_coord)

func _to_string():
	return "Crate"
