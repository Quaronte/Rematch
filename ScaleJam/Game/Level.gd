extends Node2D
class_name Level


var tilemap_level : TileMap

var moveable_grid : Grid
var static_grid : Grid

const CRATE = preload("res://GridObjects/Crate.tscn")
const PLAYER = preload("res://GridObjects/Player.tscn")
const TELEPORT = preload("res://GridObjects/Teleport.tscn")
const GOAL = preload("res://GridObjects/Goal.tscn")

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
	if !player_will_move:
		pass
	#INSIDE A SLIME
	elif player.is_fully_inmersed_in_slime():
		if player.check_embebed_move(current_input): 
			var current_crate_in = player.grid.get_object_in_grid(player.pivot_coord)
			if current_crate_in != player.grid.get_object_in_grid(player.grid.get_looking_pos(player.pivot_coord, current_input)):
				if player.is_applying_big_force(current_input):
					if current_crate_in.try_to_grow(current_input):
						pass
					else:
						for moveable in moveable_objects:
							moveable.current_state = moveable.moveableState.IDLE
						player.check_move(current_input)
	#PARTIALLY INSIDE A SLIME
	elif player.is_partially_inmersed_in_slime():
		if (current_input % 2 == 1 && player.size.x > 1) || (current_input % 2 == 0 && player.size.y > 1):
			for shape_coord in player.shape_coords:
				var something = player.grid.get_object_in_grid(player.pivot_coord + shape_coord)
				if something is Crate:
					if !something.is_considering_moving():
						something.check_move(current_input)
	#OUTSIDE A SLIME
	else:
		var print = player.check_move(current_input)
		if print == player.moveableState.STUMBLE:
			if player.is_applying_big_force(current_input):
				player_will_move = player.check_squish_move(current_input)
				print("Squishing")
				#if player_will_move
			else:
				for moveable in moveable_objects:
					if moveable.current_state == moveable.moveableState.MOVE:
						moveable.current_state = moveable.moveableState.STUMBLE
	
	current_state = levelState.MOVING
	#Activate the tweens
	for moveable in moveable_objects:
		if moveable is Player:continue
		#print(moveable, " Se considera en ", c)
		match moveable.current_state:
			moveable.moveableState.MOVE:
				movement_tween = moveable.move(current_input)
			moveable.moveableState.STUMBLE, moveable.moveableState.SQUISH, moveable.moveableState.GROW:
				movement_tween = moveable.stumble(current_input)
			moveable.moveableState.TOOSMALL:
				moveable.blink_red()
				movement_tween = moveable.stumble(current_input)
			moveable.moveableState.IDLE:
				pass
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
		#moveable.current_state = moveable
	check_teleports()
	
func check_teleports(): 
	for teleport in teleports:
		teleport.is_teleporting = false
		teleport.objects_to_teleport.clear()
		var teleport_coords = teleport.get_all_coords()
		for moveable in moveable_objects:
			var moveable_coords = moveable.get_all_coords()
			var covered = true
			if teleport_coords.size() != moveable_coords.size(): continue
			for i in teleport_coords.size():
				if teleport_coords[i] != moveable_coords[i]:
					covered = false
			if covered:
				teleport.objects_to_teleport.append(moveable)
		teleport.check_activation()
	
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
		Globals.moveableObj.CRATE, Globals.moveableObj.CRATE2, Globals.moveableObj.CRATE3:
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
		Globals.staticObj.GOAL:
			var new_static = GOAL.instantiate()
			new_static.setup(self, static_grid, _spawn_pos, _shape_coords)
			add_child(new_static)


func setup_teleporters():
	if teleports.size() != 2: return
	teleports[0].paired_teleport = teleports[1]
	teleports[1].paired_teleport = teleports[0]

func has_floor(_cell_to_check : Vector2i) -> bool:
	return tilemap_level.get_cell_source_id(0, _cell_to_check) != -1
