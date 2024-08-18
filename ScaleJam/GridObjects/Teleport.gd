extends Static
class_name Teleport


var can_teleport : bool
var object_to_teleport
var paired_teleport : Teleport

var sprites : Array
const TELEPORT_1 = preload("res://Sprites/Teleport1.png")
const TELEPORT_2 = preload("res://Sprites/Teleport2.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	for shape_coord in shape_coords:
		var new_sprite = Sprite2D.new()
		add_child(new_sprite)
		new_sprite.texture = TELEPORT_1
		new_sprite.position = shape_coord * Globals.CELL_SIZE
		sprites.append(new_sprite)
		
		sprite_on = TELEPORT_1
		sprite_off = TELEPORT_2
		
	update_sprite(sprite_off)

func update_sprite(_sprite : Texture):
	for sprite in sprites:
		sprite.texture = _sprite

func _input(event):
	if !active: return
	if level.current_state != level.levelState.IDLE: return
	if event is InputEventKey:
		if event.is_action_pressed("Teleport"):
			teleport(object_to_teleport)
	

func teleport(_object_to_teleport):
	
	_object_to_teleport.remove_object_from_grid()	
	_object_to_teleport.shape_coords.clear()
	for shape_coord in paired_teleport.shape_coords:
		_object_to_teleport.shape_coords.append(shape_coord)
	_object_to_teleport.place_object(paired_teleport.pivot_coord) 
	_object_to_teleport.update_shape()
	
	var bounce_tween := create_tween()
	bounce_tween.tween_property(_object_to_teleport, "scale", Vector2(1.0, 1.0), 0.5).from(Vector2(1.2, 0.8)).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT) 
	
	level.start_teleport_turn(bounce_tween)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _to_string():
	return "Teleport"
