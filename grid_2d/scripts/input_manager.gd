extends Node
class_name InputManager

#@export var _scene_camera: Camera2D
@export var _building_grid: TileMap

var _last_position: Vector2

func get_selected_map_position() -> Vector2:
	var mouse_pos: Vector2 = _building_grid.get_local_mouse_position()
	var grid_pos: Vector2i = _building_grid.local_to_map(mouse_pos)
	var cell_data: TileData = _building_grid.get_cell_tile_data(0, grid_pos)
	if !cell_data:
		return _last_position
	if cell_data.get_custom_data("can_build_on"):
		_last_position = grid_pos
	return _last_position
