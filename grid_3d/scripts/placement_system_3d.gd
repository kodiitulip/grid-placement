extends Node
class_name PlacementSystem3D

@export var _cell_indicator: Sprite3D
@export var _input_manager: InputManager3D
@export var _grid: GridMap
@export var _database: ObjectsDatabase3D
@export var _grid_visualization: GridVisualization3D
var _floor_data: GridData3D
var _furniture_data: GridData3D
var _placed_objects: Array[Node3D] = []
var _selected_object_index: int = -1


func _ready() -> void:
	_stop_placement()
	_floor_data = GridData3D.new()
	_furniture_data = GridData3D.new()


func _process(_delta: float) -> void:
	if !_grid or !_input_manager or !_cell_indicator:
		printerr("Missing dependancies")
		return
	if _selected_object_index < 0:
		return
	
	var mouse_pos: Vector3 = _input_manager.get_selected_map_position()
	var grid_pos: Vector3i = _grid.local_to_map(_grid.to_local(mouse_pos))
	
	var place_valid: bool = _check_placement_validity(
		grid_pos, _selected_object_index)
	_cell_indicator.modulate = Color.WHITE if place_valid else Color.RED
	
	_cell_indicator.global_position = _grid.to_global(
		_grid.map_to_local(grid_pos))


func _stop_placement() -> void:
	_selected_object_index = -1
	_grid_visualization.hide()
	_cell_indicator.hide()
	if _input_manager.has_clicked.is_connected(_place_structure):
		_input_manager.has_clicked.disconnect(_place_structure)
	if _input_manager.has_exited.is_connected(_stop_placement):
		_input_manager.has_exited.disconnect(_stop_placement)


func _start_placement(id: int) -> void:
	_stop_placement()
	var obj: ObjectData3D = _database.objects_data.filter(
		func(data: ObjectData3D) -> bool:
			return data.id == id
	).front()
	_selected_object_index = _database.objects_data.find(obj)
	
	if _selected_object_index < 0:
		printerr("the id %s was not fond" % id)
		return
	
	_grid_visualization.show()
	_cell_indicator.show()
	_input_manager.has_clicked.connect(_place_structure)
	_input_manager.has_exited.connect(_stop_placement)


func _place_structure() -> void:
	var mouse_pos: Vector3 = _input_manager.get_selected_map_position()
	var grid_pos: Vector3i = _grid.local_to_map(_grid.to_local(mouse_pos))
	
	var place_valid: bool = _check_placement_validity(
		grid_pos, _selected_object_index)
	
	if !place_valid: 
		return
	
	var new_object: Node3D = _database.objects_data[_selected_object_index] \
		.object_scene.instantiate()
	_grid.add_child(new_object)
	new_object.global_position = _grid.to_global(
		_grid.map_to_local(grid_pos))
	_placed_objects.append(new_object)
	
	var selected_data: GridData3D = _floor_data \
		 if _database.objects_data[_selected_object_index].id == 0 \
		 else _furniture_data
	
	selected_data.add_object_at(
		grid_pos, 
		_database.objects_data[_selected_object_index].size,
		_database.objects_data[_selected_object_index].id,
		_placed_objects.size() - 1
	)


func _check_placement_validity(grid_pos: Vector3i, _sel_obj_idx: int) -> bool:
	var selected_data: GridData3D = _floor_data \
		 if _database.objects_data[_sel_obj_idx].id == 0 \
		 else _furniture_data
	
	return selected_data.can_place_object_at(
		grid_pos, _database.objects_data[_sel_obj_idx].size)
