extends Node2D
class_name GridObject

var pivot_coord : Vector2i
var pivot_smooth_coord : Vector2
var grid : Grid

var shape_coords : Array[Vector2i]

var sprite : Sprite2D
var level : Level

var tile_map : TileMap
#TODO : Necesitamos información del nivel

func setup(_level : Level, _grid : Grid, _init_coord : Vector2i, _shape_coords : Array[Vector2i]):
	level = _level
	grid = _grid
	pivot_coord = _init_coord
	pivot_smooth_coord = pivot_coord
	shape_coords = _shape_coords
	position = coord_to_pos(pivot_coord)
	
	#sprite = Sprite2D.new()
	#add_child(sprite)
	
	update_object_in_grid()
# Called when the node enters the scene tree for the first time.
func _ready():
	#game = get_tree().get_root().get_child("Level")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func coord_to_pos(_coord : Vector2):
	return Vector2(_coord.x * Globals.CELL_SIZE + Globals.CELL_SIZE/2, _coord.y * Globals.CELL_SIZE + Globals.CELL_SIZE/2)

func update_object_in_grid():
	#grid.tiles[pivot_coord.x][pivot_coord.y] = self
	
	for shape_coord in shape_coords:
		grid.tiles[pivot_coord.x + shape_coord.x][pivot_coord.y + shape_coord.y] = self
	
	
