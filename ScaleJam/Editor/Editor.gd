extends Node2D
class_name Editor

@export_multiline var load_level : String = ""

@onready var camera = $Camera

@onready var editor_scene = $EditorScene

@onready var tile_map_floor := $EditorScene/TileMapFloor
@onready var tile_map_static := $EditorScene/TileMapStatic
@onready var tile_map_moveable := $EditorScene/TileMapMoveable

@onready var editor_ui = $EditorScene/EditorUI

@onready var editing_enabled := true

var level_scene = preload("res://Game/Level.tscn")
var current_level : Level

const EDITOR_BASIC_BUTTON = preload("res://Editor/Editor_BasicButton.tscn")
var editor_basic_button_array : Array[EditorBasicButton]

var editing_layer := Globals.Layer.FLOOR
var editing_brush_value = 0

var level_size :
	get:
		return Vector2(Globals.CELL_SIZE * Globals.columns, Globals.CELL_SIZE * Globals.rows)

#region SETTING UP THE EDITOR
# Called when the node enters the scene tree for the first time.
func _ready():
	if load_level != "":
		load_level_from_string(load_level)
	center_camera_to_grid()
	create_editor_buttons()
	pass # Replace with function body.


func create_editor_buttons():
	var floor_button_total = 1
	for i in floor_button_total:
		create_editor_button(i, Globals.Layer.FLOOR)
		
	var moveable_button_total = Globals.moveableObj.values().size()
	for i in moveable_button_total:
		create_editor_button(i, Globals.Layer.MOVEABLE)
	
	var static_button_total = Globals.staticObj.values().size()
	for i in static_button_total:
		create_editor_button(i, Globals.Layer.STATIC)
	pass

func create_editor_button(_value : int, _layer : int):
	var current_button = EDITOR_BASIC_BUTTON.instantiate()
	current_button.set_button_type(_value, _layer, Vector2(Globals.CELL_SIZE * (_value + 1), Globals.CELL_SIZE * (_layer + 1)))
	editor_ui.add_child(current_button)
	editor_basic_button_array.append(current_button)

func center_camera_to_grid():
	var camera_size = get_viewport().size / camera.zoom.x
	var diff = Vector2((camera_size.x - level_size.x)/2, (camera_size.y - level_size.y)/2)
	camera.position = Vector2(-diff.x + camera_size.x/2, -diff.y + camera_size.y/2)
#endregion

#region STEP EVENTS
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !editing_enabled: return
	edit_level()
	
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("PlayOrEdit"):
			if editing_enabled:
				disable_editor()
				create_level()
			else:
				enable_editor()
		elif event.is_action_pressed("CopyLevel"):
			convert_level_to_string()

		elif event.is_action_pressed("PasteLevel"):
			load_level_from_string(DisplayServer.clipboard_get())
			
#endregion

#region LEVEL EDITOR TOOLS

func update_editor_brush(_layer : int, _brush_value : int):
	editing_layer = _layer
	editing_brush_value = _brush_value
	for editor_button in editor_basic_button_array:
		editor_button.deselect()
		
		
func edit_level():
	var mouse_coord = get_mouse_coord()
	if is_out_of_level(mouse_coord): return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		draw_tiles()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		delete_tiles()
		

func delete_tiles():
	var mouse_coord = get_mouse_coord()
	match editing_layer:
			Globals.Layer.FLOOR:
				tile_map_floor.set_cells_terrain_connect(0, [mouse_coord], 0, -1)
				update_tile_map_borders()
			Globals.Layer.MOVEABLE:
				tile_map_moveable.set_cell(0, mouse_coord)
			Globals.Layer.STATIC:
				tile_map_static.set_cell(0, mouse_coord)
	
func draw_tiles():
	var mouse_coord = get_mouse_coord()
	match editing_layer:
			Globals.Layer.FLOOR:
				tile_map_floor.set_cells_terrain_connect(0, [mouse_coord], 0, 0)
				update_tile_map_borders()
			Globals.Layer.MOVEABLE:
				tile_map_moveable.set_cell(0, mouse_coord, 0, Vector2(editing_brush_value, 0))
			Globals.Layer.STATIC:
				tile_map_static.set_cell(0, mouse_coord, 0, Vector2(editing_brush_value, 0))
				
func clear_level():
	tile_map_floor.clear_layer(0)
	tile_map_floor.clear_layer(1)
	tile_map_moveable.clear_layer(0)
	tile_map_static.clear_layer(0)

#endregion

#region ENTERING PLAY MODE

func disable_editor():
	editing_enabled = false
	editor_scene.visible = false
	editor_ui.visible = false

func enable_editor():
	if current_level != null:
		current_level.destroy_level()
	editing_enabled = true
	editor_scene.visible = true
	editor_ui.visible = true
	

func create_level():
	current_level = level_scene.instantiate()
	add_child(current_level)
	current_level.tilemap_level = tile_map_floor.duplicate()
	current_level.add_child(current_level.tilemap_level)
	convert_unified_moveable_objects()
	convert_unified_static_objects()
	pass
	
func convert_unified_moveable_objects():
	#TODO: Hacer que shape_coords sea dinamico
	var shape_coords_global := [[], [], []]
	for row in Globals.rows:
		for col in Globals.columns:
			var current_object = tile_map_moveable.get_cell_atlas_coords(0, Vector2i(col, row)).x
			if current_object == -1: continue
			shape_coords_global[current_object].append(Vector2i(col, row))
	for i in shape_coords_global.size():
		print(shape_coords_global[i])
		if shape_coords_global[i].is_empty(): continue
		current_level.instanciate_moveable(i, shape_coords_global[i])


func convert_independent_moveable_objects():
	for row in Globals.rows:
		for col in Globals.columns:
			var current_object = tile_map_moveable.get_cell_atlas_coords(0, Vector2i(col, row)).x
			if current_object == -1: continue
			current_level.instanciate_moveable(current_object, [Vector2i(col, row)])


func convert_unified_static_objects():
	#TODO: Hacer que shape_coords sea dinamico
	var shape_coords_global = [[], [], []]
	for row in Globals.rows:
		for col in Globals.columns:
			var current_object = tile_map_static.get_cell_atlas_coords(0, Vector2i(col, row)).x
			if current_object == -1: continue
			shape_coords_global[current_object].append(Vector2i(col, row))
	for i in shape_coords_global.size():
		if shape_coords_global[i].is_empty(): continue
		current_level.instanciate_static(i, shape_coords_global[i])


func convert_independent_static_objects():
	for row in Globals.rows:
		for col in Globals.columns:
			var current_object = tile_map_static.get_cell_atlas_coords(0, Vector2i(col, row)).x
			if current_object == -1: continue
			current_level.instanciate_static(current_object, [Vector2i(col, row)])

#endregion

#region SAVING AND LOADING
func convert_tilemap_to_string(_current_tilemap : TileMap):
	var grid_array = []
	
	for col in Globals.columns:
		var col_array = []
		for row in Globals.rows:
			var current_pos = Vector2i(col, row)
			col_array.append(_current_tilemap.get_cell_atlas_coords(0, current_pos).x)
		grid_array.append(col_array)
	
	var tilemap_text = "["
	for col in grid_array:
		tilemap_text += str(col) + ","
	tilemap_text += "]"
	return tilemap_text
	
func convert_level_to_string():
	var floor_tilemap = convert_tilemap_to_string(tile_map_floor)
	var moveable_tilemap = convert_tilemap_to_string(tile_map_moveable)
	var static_tilemap = convert_tilemap_to_string(tile_map_static)
	var grids_str = "{
	\"COLUMNS\":\n" + str(Globals.columns) + ",
	\"ROWS\":\n" + str(Globals.rows) + ",
	\"FLOOR\":\n" + floor_tilemap + ",
	\"MOVEABLE\":\n" + moveable_tilemap + ",
	\"STATIC\":\n" + static_tilemap + "
	}"
	DisplayServer.clipboard_set(str(grids_str))
	print("------------------- SAVING ------------------------")
	print(grids_str)
	

func load_level_from_string(_string):
	print("------------------- LOADING ------------------------")
	clear_level()
	var loaded_level = Globals.get_json_dict_from_loaded_level(_string)
	Globals.columns = loaded_level["COLUMNS"]
	Globals.rows = loaded_level["ROWS"]
	
	print("Changing values ", Globals.columns, " ", Globals.rows)
	
	load_tilemap_terrain_from_string(tile_map_floor, loaded_level["FLOOR"])
	load_tilemap_from_string(tile_map_moveable, loaded_level["MOVEABLE"])
	load_tilemap_from_string(tile_map_static, loaded_level["STATIC"])
	update_tile_map_borders()

func load_tilemap_terrain_from_string(_current_tilemap : TileMap, _new_grid):
	print(_new_grid)
	for row in Globals.rows:
		for col in Globals.columns:
			var current_pos = Vector2i(col, row)
			if _new_grid[col][row] == -1: continue
			_current_tilemap.set_cells_terrain_connect(0, [current_pos], 0, 0)
			
func load_tilemap_from_string(_current_tilemap : TileMap, _new_grid):
	print(_new_grid)
	for row in Globals.rows:
		for col in Globals.columns:
			var current_pos = Vector2i(col, row)
			if _new_grid[col][row] == -1: continue
			_current_tilemap.set_cell(0, current_pos, 0, Vector2(_new_grid[col][row], 0))

#endregion

#region UTILITIES

func has_floor(_cell_to_check : Vector2i) -> bool:
	return tile_map_floor.get_cell_source_id(0, _cell_to_check) != -1


func get_mouse_coord() -> Vector2i:
	var mouse_position = get_global_mouse_position()
	return floor(mouse_position / Globals.CELL_SIZE)

func is_out_of_level(_coord : Vector2i):
	return _coord.x < 0 || _coord.x >= Globals.columns || _coord.y < 0 || _coord.y >= Globals.rows

#endregion
	
#region POLISH:
func _draw():
	draw_rect(Rect2( Vector2(0, 0), level_size), Color(1, 1, 1, 1), false, 5)

func update_tile_map_borders():
	tile_map_floor.clear_layer(1)
	for row in Globals.rows:
		for col in Globals.columns:
			var _current_coord = Vector2i(col, row)
			var aux_coord = Vector2i(col, row - 1)
			if !has_floor(_current_coord): continue
			if has_floor(aux_coord): continue
			tile_map_floor.set_cells_terrain_connect(1, [aux_coord], 0, 1)
			
#endregion