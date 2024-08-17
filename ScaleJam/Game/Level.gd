extends Node2D
class_name Level


var tilemap_level : TileMap

var moveable_grid : Grid
var static_grid : Grid

const CRATE = preload("res://GridObjects/Crate.tscn")
const PLAYER = preload("res://GridObjects/Player.tscn")
const TARGET = preload("res://GridObjects/Target.tscn")

enum levelState {IDLE, MOVING}
var current_state := levelState.IDLE

var moveable_objects : Array

var player : Player
# Called when the node enters the scene tree for the first time.
func _ready():
	moveable_grid = Grid.new(Globals.columns, Globals.rows)
	add_child(moveable_grid)
	static_grid = Grid.new(Globals.columns, Globals.rows)
	add_child(static_grid)
	pass # Replace with function body.

func get_input_direction() -> int:
	if Input.is_action_pressed("ui_right"): return 0
	if Input.is_action_pressed("ui_up"): return 1
	if Input.is_action_pressed("ui_left"): return 2
	if Input.is_action_pressed("ui_down"): return 3
	return -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state == levelState.MOVING: return
	var current_input = get_input_direction()
	if current_input == -1: return
	#var moveables_can_move = player.receive_input(current_input)
	var movement_tween : Tween
	#NORMAL MOVE
	var current_crate_in = player.grid.get_object_in_grid(player.pivot_coord)
	if current_crate_in is Crate:
		print("Here")
		if player.check_embebed_move(current_input):
			print("Embebed move")
			if player.grid.get_object_in_grid(player.pivot_coord) != player.grid.get_object_in_grid(player.grid.get_looking_pos(player.pivot_coord, current_input)):
				current_crate_in.try_to_grow(player.grid.get_dir_vector(current_input))
			for moveable in moveable_objects:
				if !moveable.is_considering_moving(): continue
				movement_tween = moveable.move(current_input)
		else:
			print("Mmm?")
			for moveable in moveable_objects:
				if !moveable.is_considering_moving(): continue
				movement_tween = moveable.stumble(current_input)
	else:
		if player.check_move(current_input):
			print("Normal move")
			for moveable in moveable_objects:
				if moveable.is_considering_moving():
					movement_tween = moveable.move(current_input)
		#FREE MOVE
		else:
			print("Forced move move")
			for moveable in moveable_objects:
				if moveable is Player: continue
				if !moveable.is_considering_moving(): continue
				movement_tween = moveable.stumble(current_input)
			if player.check_squishy_move(current_input):
				movement_tween = player.move(current_input)
			else:
				movement_tween = player.stumble(current_input)
	current_state = levelState.MOVING

	
	movement_tween.tween_callback(finished_turn).finished
	
	pass


	

func destroy_level():
	print("Destorying level?")
	self.queue_free()

func finished_turn():
	print("-------------------------------------------")
	current_state = levelState.IDLE
	for moveable in moveable_objects:
		moveable.update_moveable_object_in_grid()
	
func instanciate_moveable(moveable_type, _all_coords):
	print("Creating Moveable : ", Globals.moveableObj.keys()[moveable_type], _all_coords)
	var _spawn_pos = _all_coords[0]
	var _shape_coords : Array[Vector2i]
	for coord in _all_coords:
		_shape_coords.append(coord - _spawn_pos)
	print("With shape: ", _shape_coords)
	match moveable_type:
		Globals.moveableObj.PLAYER:
			var new_moveable = PLAYER.instantiate()
			new_moveable.setup(self, moveable_grid, _spawn_pos, _shape_coords)
			add_child(new_moveable)
			player = new_moveable
			moveable_objects.append(new_moveable)
		Globals.moveableObj.CRATE, Globals.moveableObj.CRATE2:
			var new_moveable = CRATE.instantiate()
			new_moveable.setup(self, moveable_grid, _spawn_pos, _shape_coords)
			add_child(new_moveable)
			moveable_objects.append(new_moveable)
		
		
func instanciate_static(static_type, _all_coords):
	var _spawn_pos = _all_coords[0]
	var _shape_coords : Array[Vector2i]
	for coord in _all_coords:
		_shape_coords.append(coord - _spawn_pos)
	print("Creating  Static : ", Globals.staticObj.keys()[static_type])
	match static_type:
		Globals.staticObj.TARGET:
			var new_moveable = TARGET.instantiate()
			new_moveable.setup(self, static_grid, _spawn_pos, _shape_coords)
			add_child(new_moveable)

func has_floor(_cell_to_check : Vector2i) -> bool:
	return tilemap_level.get_cell_source_id(0, _cell_to_check) != -1
