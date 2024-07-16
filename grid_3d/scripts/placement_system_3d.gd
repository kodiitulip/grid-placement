extends Node
class_name PlacementSystem3D

@export var _mouse_indicator: Node3D
@export var _cell_indicator: Node3D
@export var _input_manager: InputManager3D
@export var _grid: GridMap


func _process(_delta: float) -> void:
	var mouse_pos: Vector3 = _input_manager.get_selected_map_position()
	var grid_pos: Vector3i = _grid.local_to_map(mouse_pos)
	_mouse_indicator.global_position = mouse_pos
	_cell_indicator.global_position = Vector3(grid_pos) + Vector3(0,0.01,0)
	#print(grid_pos, mouse_pos)
