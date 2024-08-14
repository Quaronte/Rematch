extends Node2D
class_name Grid

var tiles : Array[Array] #Cada posicion del array guarda una columna, para conservar x e y como elemento espacial

var columns := 5
var rows := 7

enum dirVector{
	RIGHT = 0,
	UP = 1,
	LEFT = 2,
	DOWN = 3
}

const NORMAL_FONT = preload("res://NormalFont.ttf")
# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_grid(null)
	debug_grid()
	pass # Replace with function body.


func initialize_grid(_value):
	for col in columns:
		tiles.append([])
		for row in rows:
			tiles[col].append(_value)
			
func debug_grid():
	for col in columns:
		for row in rows:
			tiles[col][row] = col + row * columns
				

func is_out_of_grid(_coord : Vector2i) -> bool:
	return _coord.x < 0 || _coord.x >= columns || _coord.y < 0 || _coord.y >= rows
	
func is_empty_coord(_coord : Vector2i) -> bool:
	return get_object_in_grid(_coord) == null
	
func get_object_in_grid(_coord : Vector2i):
	return tiles[_coord.x][_coord.y]

func get_looking_dir(_pos : Vector2i, _dir : dirVector):
	var looking_vector = get_dir_vector(_dir)
	
func get_dir_vector(_dir : dirVector):
	return Vector2(round(cos(deg_to_rad(_dir * 90))), round(sin(deg_to_rad(_dir * 90))))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	pass
	
func coord_to_pos(_coord : Vector2i) -> Vector2:
	return Vector2(Globals.CELL_SIZE * _coord.x, Globals.CELL_SIZE * _coord.y)
	
func pos_to_coord(_pos : Vector2) -> Vector2i:
	return floor(_pos / Globals.CELL_SIZE)
	
func remove_object_in_grid(_coord : Vector2i):
	tiles[_coord.x][_coord.y] = null

func _draw():
	draw_grid()

func draw_grid():
	for col in columns:
		for row in rows:
			draw_string(NORMAL_FONT, Vector2(100, 100) + coord_to_pos(Vector2i(col, row)), str(tiles[col][row]))
	
