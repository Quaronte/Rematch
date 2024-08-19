extends Node2D
class_name GridObject

var pivot_coord : Vector2i
var pivot_smooth_coord : Vector2
var grid : Grid

var shape_coords : Array[Vector2i]
var size : Vector2

var sprite : Sprite2D
var level : Level

var tile_map : TileMap
#TODO : Necesitamos información del nivel

func setup(_level : Level, _grid : Grid, _init_coord : Vector2i, _shape_coords : Array[Vector2i]):
	level = _level
	grid = _grid
	shape_coords = _shape_coords
	calculate_size()
	place_object(_init_coord)
	
	#sprite = Sprite2D.new()
	#add_child(sprite)

func place_object(_coord):
	print("Placing object in ", _coord)
	pivot_coord = _coord
	pivot_smooth_coord = pivot_coord
	position = coord_to_pos(pivot_coord)
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
	for shape_coord in shape_coords:
		grid.tiles[pivot_coord.x + shape_coord.x][pivot_coord.y + shape_coord.y] = self

func remove_object_from_grid():
	for shape_coord in shape_coords:
		if grid.tiles[pivot_coord.x + shape_coord.x][pivot_coord.y + shape_coord.y] != self: continue
		grid.tiles[pivot_coord.x + shape_coord.x][pivot_coord.y + shape_coord.y] = null

func calculate_size():
	size = Vector2i.ZERO
	var boundaries_shape_x = Vector2i(Globals.columns, 0)
	var boundaries_shape_y = Vector2i(Globals.rows, 0)
	for shape_coord in shape_coords:
		boundaries_shape_x.x = min(boundaries_shape_x.x, shape_coord.x)
		boundaries_shape_x.y = max(boundaries_shape_x.y, shape_coord.x)
		
		boundaries_shape_y.x = min(boundaries_shape_y.x, shape_coord.y)
		boundaries_shape_y.y = max(boundaries_shape_y.y, shape_coord.y)
		
	size.x = boundaries_shape_x.y - boundaries_shape_x.x + 1
	size.y = boundaries_shape_y.y - boundaries_shape_y.x + 1
	

func get_all_coords() -> Array[Vector2i]:
	var current_coords : Array[Vector2i]
	for shape_coord in shape_coords:
		current_coords.append(pivot_coord + shape_coord)
	current_coords.sort()
	return current_coords

func update_shape():
	tile_map.clear()
	tile_map.set_cells_terrain_connect(0, shape_coords, 0, 0)
	calculate_size()
