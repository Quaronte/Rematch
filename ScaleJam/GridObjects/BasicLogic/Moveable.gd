extends GridObject
class_name Moveable

var next_coord : Vector2i
var is_considering_move := false


enum moveableState {IDLE, THINKING, MOVE, STUMBLE, GROW, SQUISH, TOOSMALL}
var current_state := moveableState.IDLE

func setup(_level : Level, _grid : Grid, _init_coord : Vector2i, _shape_coords : Array[Vector2i]):
	super.setup(_level, _grid, _init_coord, _shape_coords)
	next_coord = _init_coord
	
func place_object(_coord):
	super.place_object(_coord)
	next_coord = _coord
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = coord_to_pos(pivot_smooth_coord)
	pass
	
func check_move(move_dir : int) -> int:
	current_state = moveableState.THINKING
	for shape_coord in shape_coords:
		var looking_coord = grid.get_looking_pos(pivot_coord + shape_coord, move_dir )
		if grid.is_out_of_grid(looking_coord) || !level.has_floor(looking_coord): 
			current_state = moveableState.STUMBLE
			continue
		if grid.is_empty_coord(looking_coord): continue
		var object_in_tile = grid.get_object_in_grid(looking_coord)
		if object_in_tile == self: continue
		if object_in_tile.is_considering_moving(): continue
		if object_in_tile.is_partially_or_fully_inmersed_in_object(self): continue
		current_state = max(object_in_tile.check_move(move_dir), current_state)
	current_state = max(moveableState.MOVE, current_state)
	return current_state


func is_considering_moving() -> bool:
	return current_state != moveableState.IDLE && current_state != moveableState.STUMBLE



func update_moveable_object_in_grid():
	remove_object_from_grid()
	pivot_coord = next_coord
	update_object_in_grid()

func finish_move():
	is_considering_move = false
	current_state = moveableState.IDLE

func move(move_dir):
	next_coord = grid.get_looking_pos(pivot_coord, move_dir)
	#current_state = moveState.MOVING
	var move_tween = create_tween()
	var move_duration = 0.25
	move_tween.tween_property(self, "pivot_smooth_coord", Vector2(next_coord.x, next_coord.y), move_duration).set_trans(Tween.TRANS_CUBIC)
	move_tween.tween_callback(finish_move).finished
	return move_tween
	
func blink_red():
	#current_state = moveState.MOVING
	var move_duration = 0.15
	var blink_tween = create_tween().set_loops(3)
	#blink_tween.tween_property(tile_map, "modulate", Color(0.89, 0.43, 0.34, 1), move_duration/2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN).as_relative()
	blink_tween.tween_property(tile_map, "modulate", Color(1, 0.67, 0.78, 1), move_duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	blink_tween.tween_property(tile_map, "modulate", Color(1, 1, 1, 1), move_duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	

func stumble(move_dir):
	next_coord = pivot_coord
	var stumble_next_vector = grid.get_dir_vector(move_dir)
	#current_state = moveState.MOVING
	var move_duration = 0.15
	var stumble_strength = 0.25
	var stumble_tween = create_tween()
	stumble_tween.tween_property(self, "pivot_smooth_coord", Vector2(stumble_next_vector.x, stumble_next_vector.y) * stumble_strength, move_duration/2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN).as_relative()
	stumble_tween.tween_property(self, "pivot_smooth_coord", Vector2(pivot_coord.x, pivot_coord.y), move_duration/2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	stumble_tween.tween_callback(finish_move).finished
	return stumble_tween
