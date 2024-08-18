extends Node2D
class_name Level


var tilemap_level : TileMap

var moveable_grid : Grid
var static_grid : Grid

const CRATE = preload("res://GridObjects/Crate.tscn")
const PLAYER = preload("res://GridObjects/Player.tscn")
const TELEPORT = preload("res://GridObjects/Teleport.tscn")

enum levelState {IDLE, MOVING}
var current_state := levelState.IDLE

var moveable_objects : Array
var teleports : Array

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
	
	var player_will_move = player.check_player_move_freely(current_input)
	var objects_will_move = true
	#NORMAL MOVE
	var current_crate_in = player.grid.get_object_in_grid(player.pivot_coord)
	if current_crate_in is Crate:
		if player.check_embebed_move(current_input):
			if player.grid.get_object_in_grid(player.pivot_coord) != player.grid.get_object_in_grid(player.grid.get_looking_pos(player.pivot_coord, current_input)):
				if current_crate_in.try_to_grow(current_input):
					objects_will_move = true
				else:
					for moveable in moveable_objects:
						moveable.current_state = moveable.moveableState.IDLE
					objects_will_move = player.check_move(current_input)
		else:
			objects_will_move = false
			
	else:
		objects_will_move = player.check_move(current_input)
		if !objects_will_move:
			if player.is_player_big():
				print("Checking for squish move")
				player_will_move = player.check_squish_move(current_input)
	
	current_state = levelState.MOVING
	#Activate the tweens
	for moveable in moveable_objects:
		if moveable is Player: continue
		if !moveable.is_considering_moving(): continue
		if objects_will_move:
			movement_tween = moveable.move(current_input)
		else:
			movement_tween = moveable.stumble(current_input)
	if player_will_move:
		movement_tween = player.move(current_input)
	else:
		movement_tween = player.stumble(current_input)
	
	movement_tween.tween_callback(finished_turn).finished
	
	pass

func start_level():
	setup_teleporters()
	

func destroy_level():
	self.queue_free()
	
func start_teleport_turn(_tween : Tween):
	current_state = levelState.MOVING
	_tween.tween_callback(finished_turn).finished

func finished_turn():
	print("-------------------- FINISHED TURN -----------------------")
	current_state = levelState.IDLE
	for moveable in moveable_objects:
		moveable.update_moveable_object_in_grid()
	check_teleports()
	
func check_teleports(): 
	for teleport in teleports:
		var object_on_top = moveable_grid.get_object_in_grid(teleport.pivot_coord)
		var covered = !moveable_grid.is_empty_coord(teleport.pivot_coord)
		for shape_coord in teleport.shape_coords:
			if moveable_grid.get_object_in_grid(teleport.pivot_coord + shape_coord) != object_on_top: 
				covered = false
				
		
		if covered:
			if teleport.shape_coords.size() != object_on_top.shape_coords.size(): 
				if teleport.active:
					teleport.deactivate()
			else:
				teleport.activate()
				teleport.object_to_teleport = object_on_top
		else:
			if teleport.active:
				teleport.deactivate()
		
			
	
func instanciate_moveable(moveable_type, _all_coords):
	var _spawn_pos = _all_coords[0]
	var _shape_coords : Array[Vector2i]
	for coord in _all_coords:
		_shape_coords.append(coord - _spawn_pos)
	var new_moveable 
	match moveable_type:
		Globals.moveableObj.PLAYER:
			new_moveable = PLAYER.instantiate()
			player = new_moveable
		Globals.moveableObj.CRATE, Globals.moveableObj.CRATE2:
			new_moveable = CRATE.instantiate()
	new_moveable.setup(self, moveable_grid, _spawn_pos, _shape_coords)
	add_child(new_moveable)
	moveable_objects.append(new_moveable)
		
		
func instanciate_static(static_type, _all_coords):
	var _spawn_pos = _all_coords[0]
	var _shape_coords : Array[Vector2i]
	for coord in _all_coords:
		_shape_coords.append(coord - _spawn_pos)
	match static_type:
		Globals.staticObj.TELEPORT, Globals.staticObj.TELEPORT2:
			var new_static = TELEPORT.instantiate()
			new_static.setup(self, static_grid, _spawn_pos, _shape_coords)
			add_child(new_static)
			teleports.append(new_static)

func setup_teleporters():
	teleports[0].paired_teleport = teleports[1]
	teleports[1].paired_teleport = teleports[0]

func has_floor(_cell_to_check : Vector2i) -> bool:
	return tilemap_level.get_cell_source_id(0, _cell_to_check) != -1
