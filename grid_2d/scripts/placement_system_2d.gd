extends Node
class_name PlacementSysytem2D

#@export var _mouse_indicator: Node2D
@export var _input_manager: InputManager2D
@export var _cell_indicator: NinePatchRect
@export var _grid: TileMap

func _process(_delta: float) -> void:
	var grid_position: Vector2i = _input_manager.get_selected_map_position()
	#var grid_position: Vector2i = _grid.local_to_map(mouse_position)
	var tile_size: Vector2 = _grid.tile_set.tile_size
	#_mouse_indicator.global_position = mouse_position
	_cell_indicator.global_position = _grid.to_global(
		_grid.map_to_local(grid_position)) - tile_size / 2
