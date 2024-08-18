extends GridObject
class_name Static

var active = false
var sprite_on : Texture
var sprite_off : Texture


func setup(_level : Level, _grid : Grid, _init_coord : Vector2i, _shape_coords : Array[Vector2i]):
	super.setup(_level, _grid, _init_coord,_shape_coords)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func activate():
	active = true
	update_sprite(sprite_on)
	pass


func deactivate():
	active = false
	update_sprite(sprite_off)
	pass

func update_sprite(_sprite : Texture):
	pass
