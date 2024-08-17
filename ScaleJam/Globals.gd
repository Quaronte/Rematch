extends Node


var rows = 10
var columns = 15
const CELL_SIZE = 64
const BIG_CELL_SIZE = 72


#TODO: Cambiar estos valores y los tilemaps asociados
enum Layer {FLOOR, MOVEABLE, STATIC}
enum moveableObj {PLAYER, CRATE, CRATE2}
enum staticObj {TARGET}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_json_dict_from_loaded_level(_loaded_level) -> Dictionary:
	# print("initial_grids_json_string: ", initial_grids_json_string)
	var level_info = JSON.parse_string(_loaded_level)
	print("My json array is : ", level_info, "   ", _loaded_level)
	return level_info
