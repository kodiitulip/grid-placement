extends Node
class_name PlacementSystem3D

#@export var _mouse_indicator: Node3D
@export var _cell_indicator: Node3D
@export var _input_manager: InputManager3D
@export var _grid: GridMap

var _selected_index: int = 0


func _process(_delta: float) -> void:
	if !_grid or !_input_manager:
		return
	if !_cell_indicator:
		return
	
	var mouse_pos: Vector3 = _input_manager.get_selected_map_position()
	var grid_pos: Vector3i = _grid.local_to_map(_grid.to_local(mouse_pos))
	#_mouse_indicator.global_position = mouse_pos
	_cell_indicator.global_position = _grid.to_global(_grid.map_to_local(grid_pos))
	
	if Input.is_action_pressed("l_click"):
		_place_item(grid_pos, _selected_index)
	if Input.is_action_pressed("r_click"):
		_remove_item(grid_pos)


func _place_item(pos: Vector3i, idx: int) -> void:
	if _grid.get_cell_item(pos) != GridMap.INVALID_CELL_ITEM:
		return
	_grid.set_cell_item(pos, idx)


func _remove_item(pos: Vector3i) -> void:
	if _grid.get_cell_item(pos) == GridMap.INVALID_CELL_ITEM:
		return
	_grid.set_cell_item(pos, GridMap.INVALID_CELL_ITEM)
