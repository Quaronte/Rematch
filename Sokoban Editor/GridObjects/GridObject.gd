extends Node2D
class_name GridObject

var current_coord : Vector2i
var current_pos : Vector2
var grid : Grid

var sprite : Sprite2D

#TODO : Necesitamos información del nivel

func _init(_grid : Grid, _init_coord : Vector2i):
	grid = _grid
	current_coord = _init_coord
	current_pos = coord_to_pos(current_coord)
	position = current_pos
	
	sprite = Sprite2D.new()
	add_child(sprite)
	update_object_in_grid()
# Called when the node enters the scene tree for the first time.
func _ready():
	#game = get_tree().get_root().get_child("Level")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func coord_to_pos(_coord : Vector2):
	return Vector2(_coord.x + Globals.CELL_SIZE, _coord.y + Globals.CELL_SIZE)


func update_object_in_grid():
	grid.tiles[current_coord.x][current_coord.y] = self
