extends Node2D
class_name Editor

@onready var camera = $Camera

@onready var tile_map_floor = $TileMapFloor
@onready var tile_map_static = $TileMapStatic
@onready var tile_map_moveable = $TileMapMoveable

@onready var game_ui = $GameUi

const EDITOR_BASIC_BUTTON = preload("res://Editor/Editor_BasicButton.tscn")
var editor_basic_button_array : Array[EditorBasicButton]

#TODO: Cambiar estos valores y los tilemaps asociados
enum Layer {FLOOR, MOVEABLE, STATIC}
enum moveableObj {PLAYER, ZIP, FILE}
enum staticObj {FOLDER, FOLDER2}

var editing_layer := Layer.FLOOR
var editing_brush_value = 0

var level_size :
	get:
		return Vector2(Globals.CELL_SIZE * Globals.columns, Globals.CELL_SIZE * Globals.rows)



# Called when the node enters the scene tree for the first time.
func _ready():
	center_camera_to_grid()
	create_editor_buttons()
	pass # Replace with function body.


func create_editor_buttons():
	var floor_button_total = 1
	for i in floor_button_total:
		create_editor_button(i, Layer.FLOOR)
		
	var moveable_button_total = moveableObj.values().size()
	for i in moveable_button_total:
		create_editor_button(i, Layer.MOVEABLE)
	
	var static_button_total = staticObj.values().size()
	for i in static_button_total:
		create_editor_button(i, Layer.STATIC)
	pass

func create_editor_button(_value : int, _layer : int):
	var current_button = EDITOR_BASIC_BUTTON.instantiate()
	current_button.set_button_type(_value, _layer, Vector2(Globals.CELL_SIZE * (_value + 1), Globals.CELL_SIZE * (_layer + 1)))
	game_ui.add_child(current_button)
	editor_basic_button_array.append(current_button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	edit_level()
	pass


func edit_level():
	var mouse_coord = get_mouse_coord()
	
	if is_out_of_level(mouse_coord): return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		match editing_layer:
			Layer.FLOOR:
				tile_map_floor.set_cells_terrain_connect(0, [mouse_coord], 0, 0)
				update_tile_map_borders()
			Layer.MOVEABLE:
				tile_map_moveable.set_cell(0, mouse_coord, 0, Vector2(editing_brush_value, 0))
			Layer.STATIC:
				tile_map_static.set_cell(0, mouse_coord, 0, Vector2(editing_brush_value, 0))
				
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		match editing_layer:
			Layer.FLOOR:
				tile_map_floor.set_cells_terrain_connect(0, [mouse_coord], 0, -1)
				update_tile_map_borders()
			Layer.MOVEABLE:
				tile_map_moveable.set_cell(0, mouse_coord)
			Layer.STATIC:
				tile_map_static.set_cell(0, mouse_coord)

func update_tile_map_borders():
	tile_map_floor.clear_layer(1)
	for row in Globals.rows:
		for col in Globals.columns:
			var current_coord = Vector2i(col, row)
			var aux_coord = Vector2i(col, row - 1)
			if !has_floor(current_coord): continue
			if has_floor(aux_coord): continue
			tile_map_floor.set_cells_terrain_connect(1, [aux_coord], 0, 1)


func has_floor(_cell_to_check : Vector2i) -> bool:
	return tile_map_floor.get_cell_source_id(0, _cell_to_check) != -1


func get_mouse_coord() -> Vector2i:
	var mouse_position = get_global_mouse_position()
	return floor(mouse_position / Globals.CELL_SIZE)

func is_out_of_level(_coord : Vector2i):
	return _coord.x < 0 || _coord.x >= Globals.columns || _coord.y < 0 || _coord.y >= Globals.rows


func center_camera_to_grid():
	var camera_size = get_viewport().size / camera.zoom.x
	var diff = Vector2((camera_size.x - level_size.x)/2, (camera_size.y - level_size.y)/2)
	camera.position = Vector2(-diff.x + camera_size.x/2, -diff.y + camera_size.y/2)

func update_editor_brush(_layer : int, _brush_value : int):
	editing_layer = _layer
	editing_brush_value = _brush_value
	for editor_button in editor_basic_button_array:
		editor_button.deselect()

func _draw():
	draw_rect(Rect2( Vector2(0, 0), level_size), Color(1, 1, 1, 1), false, 5)
