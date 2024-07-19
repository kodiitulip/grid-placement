extends Node
class_name PlacementSystem3D

@export var _input_manager: InputManager3D
@export var _grid: GridMap
@export var _database: ObjectsDatabase3D
@export var _grid_visualization: GridVisualization3D
@export var _preview_system: PreviewSystem3D
@export var _object_placer: ObjectPlacer3D
@export var _sound_feedback: SoundFeedBack3D

var building_state: IBuildingState3D
var _floor_data: GridData3D
var _furniture_data: GridData3D
var _last_detected_pos: Vector3i = Vector3i.ZERO


func _ready() -> void:
	stop_placement()
	_floor_data = GridData3D.new()
	_furniture_data = GridData3D.new()


func _process(_delta: float) -> void:
	if !building_state:
		return
	
	var mouse_pos: Vector3 = _input_manager.get_selected_map_position()
	var grid_pos: Vector3i = _grid.local_to_map(_grid.to_local(mouse_pos))
	
	if _last_detected_pos != grid_pos:
		building_state.update_state(grid_pos)
		_last_detected_pos = grid_pos


func stop_placement() -> void:
	if !building_state:
		return
	_grid_visualization.hide()
	building_state.end_state()
	if _input_manager.has_clicked.is_connected(_place_structure):
		_input_manager.has_clicked.disconnect(_place_structure)
	if _input_manager.has_exited.is_connected(stop_placement):
		_input_manager.has_exited.disconnect(stop_placement)
	_last_detected_pos = Vector3i.ZERO
	building_state = null


func start_placement(id: int) -> void:
	stop_placement()
	_grid_visualization.show()
	
	building_state = PlacementState3D.new(
		id,
		_grid,
		_preview_system,
		_database,
		_floor_data,
		_furniture_data,
		_object_placer,
		_sound_feedback
	)
	
	_input_manager.has_clicked.connect(_place_structure)
	_input_manager.has_exited.connect(stop_placement)


func start_removing() -> void:
	stop_placement()
	_grid_visualization.show()
	building_state = RemovingState3D.new(
		_grid,
		_preview_system,
		_floor_data,
		_furniture_data,
		_object_placer,
		_sound_feedback
	)
	
	_input_manager.has_clicked.connect(_place_structure)
	_input_manager.has_exited.connect(stop_placement)


func _place_structure() -> void:
	var mouse_pos: Vector3 = _input_manager.get_selected_map_position()
	var grid_pos: Vector3i = _grid.local_to_map(_grid.to_local(mouse_pos))
	
	building_state.on_action(grid_pos)
