extends GridObject
class_name Moveable

var next_coord : Vector2i


func _init(_grid : Grid, _init_coord : Vector2i):
	super._init(_grid, _init_coord)
	next_coord = _init_coord
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_move(move_dir : int):
	pass

func update_moveable_object_in_grid():
	var old_position_cell = grid.get_object_in_grid(current_coord)
	if old_position_cell == self:
		grid.remove_object_from_grid()
	update_object_in_grid()
