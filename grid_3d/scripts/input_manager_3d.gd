extends Node
class_name InputManager3D

signal has_clicked()
signal has_exited()

@export var _scene_camera: Camera3D
@export var _ray_length: float = 1000.0
@export_flags_3d_physics var _placement_layer_mask: int = 2

var _last_position: Vector3 = Vector3.ZERO

static var _space: PhysicsDirectSpaceState3D
static var _ray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()


func _ready() -> void:
	_space = _scene_camera.get_world_3d().direct_space_state
	_ray_query.collision_mask = _placement_layer_mask
	_ray_query.hit_back_faces = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("l_click"):
		has_clicked.emit()
		get_viewport().set_input_as_handled()
	if event.is_action_pressed("exit"):
		has_exited.emit()
		get_viewport().set_input_as_handled()


func get_selected_map_position() -> Vector3:
	if not _space:
		return _last_position
	
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var from: Vector3 = _scene_camera.project_ray_origin(mouse_pos)
	var to: Vector3 = _scene_camera.project_ray_normal(mouse_pos) * _ray_length
	_ray_query.from = from
	_ray_query.to = to
	var raycast_result: Dictionary = _space.intersect_ray(_ray_query)
	
	if raycast_result.has("position"):
		var pos: Vector3 = raycast_result["position"]
		_last_position = pos
	
	return _last_position
