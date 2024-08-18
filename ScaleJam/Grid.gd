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

func _init(_columns, _rows):
	columns = _columns 
	rows = _rows 
	initialize_grid(null)
	#print_grid()
	queue_redraw()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	#debug_grid()
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

func get_looking_pos(_pos : Vector2i, _dir : dirVector):
	var looking_vector = get_dir_vector(_dir)
	return _pos + looking_vector
	
func get_dir_vector(_dir : dirVector) -> Vector2i:
	return Vector2i(round(cos(deg_to_rad(_dir * 90))), round(- sin(deg_to_rad(_dir * 90))))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	pass
	
func coord_to_pos(_coord : Vector2i) -> Vector2:
	return Vector2(Globals.CELL_SIZE * _coord.x, Globals.CELL_SIZE * _coord.y)
	
func pos_to_coord(_pos : Vector2) -> Vector2i:
	return floor(_pos / Globals.CELL_SIZE)

func remove_object_from_grid(_coord : Vector2i):
	tiles[_coord.x][_coord.y] = null
	
func _draw():
	#draw_grid()
	pass

func draw_grid():
	for col in columns:
		for row in rows:
			if is_empty_coord(Vector2i(col, row)): continue
			draw_string(NORMAL_FONT, coord_to_pos(Vector2i(col, row)) + Vector2(-600, Globals.CELL_SIZE/2), str(get_object_in_grid(Vector2i(col, row))), 2, -1, 24, Color(0.75, 0.43, 0.96))
			
func print_grid():
	for row in range(rows):
		var col_str = ""
		for col in range(columns):
			var tile_str: String
			if is_empty_coord(Vector2i(col, row)):
				tile_str = "(  -  )"
			else:
				tile_str = str(tiles[col][row])
			col_str += tile_str + " "
		print(col_str)
	
