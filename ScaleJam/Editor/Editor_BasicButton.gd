extends Area2D
class_name EditorBasicButton


@onready var icon := $Icon
@onready var selected_button = $SelectedButton

const FLOOR_TILESET = preload("res://Sprites/Floor_Tileset.png")
const MOVEABLE_TILESET = preload("res://Sprites/Moveable_Tileset.png")
const STATIC_TILESET = preload("res://Sprites/Static_Tileset.png")


var active := false
var selected := false
var value : int
var layer : int

signal basic_button_pressed_signal

func set_button_type(_value : int, _layer : int,  _pos : Vector2):
	value = _value
	layer = _layer
	position = _pos
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var editor = get_tree().get_root().get_node("Editor")
	basic_button_pressed_signal.connect(editor.update_editor_brush.bind(layer, value))
	match layer:
		Globals.Layer.FLOOR:
			icon.texture = FLOOR_TILESET
		Globals.Layer.MOVEABLE:
			icon.texture = MOVEABLE_TILESET
		Globals.Layer.STATIC:
			icon.texture = STATIC_TILESET
	icon.region_rect = Rect2(Vector2(Globals.BIG_CELL_SIZE * value, 0), Vector2(Globals.BIG_CELL_SIZE, Globals.BIG_CELL_SIZE))

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !active: return
	if Input.is_action_just_pressed("LeftClick"):
		emit_signal("basic_button_pressed_signal")
		select()
		pass


func deselect():
	selected = false
	selected_button.visible = false
	
func select():
	selected = true
	selected_button.visible = true
	
func _on_mouse_entered():
	active = true
	pass # Replace with function body.


func _on_mouse_exited():
	active = false
	pass # Replace with function body.
