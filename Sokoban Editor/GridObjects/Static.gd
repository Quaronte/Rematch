extends GridObject
class_name Static

var sprite_on : Texture
var sprite_off : Texture

var active = false


func _init(_grid : Grid, _init_coord : Vector2i):
	super._init(_grid, _init_coord)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate():
	active = true
	sprite.texture = sprite_on
	pass


func deactivate():
	active = false
	sprite.texture = sprite_off
	pass
