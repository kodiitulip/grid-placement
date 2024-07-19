extends Node
class_name PreviewSystem3D

@export_range(0.0,1.0,0.01) var _preview_y_offset: float = 0.06
@export var _cell_indicator: GridVisualization3D
@export var _preview_material_resource: ShaderMaterial

var _preview_material_instance: ShaderMaterial
var _preview_object: Node3D
var _cursor_offset: Vector3 = Vector3.ZERO

func _ready() -> void:
	_preview_material_instance = _preview_material_resource.duplicate()
	_cell_indicator.show()


func start_showing_placement_preview(obj: PackedScene, size: Vector3i) -> void:
	_preview_object = obj.instantiate()
	_prepare_preview(_preview_object)
	_prepare_cursor(size)
	_cell_indicator.show()


func start_showing_remove_preview() -> void:
	_cell_indicator.show()
	_prepare_cursor(Vector3i.ONE)
	_apply_feedback_to_cursor(false)


func stop_showing_preview() -> void:
	_cell_indicator.hide()
	if _preview_object:
		_preview_object.queue_free()
		_preview_object = null


func update_position(position: Vector3, validity: bool) -> void:
	if _preview_object:
		_move_preview(position)
		_apply_feedback_to_preview(validity)
	
	_move_cursor(position)
	_apply_feedback_to_cursor(validity)


func _move_preview(position: Vector3) -> void:
	_preview_object.position = position + Vector3(0, _preview_y_offset, 0)


func _move_cursor(position: Vector3) -> void:
	_cell_indicator.position = position + _cursor_offset


func _apply_feedback_to_preview(validity: bool) -> void:
	var c: Color = Color.WHITE if validity else Color.RED
	c.a = 0.5
	_preview_material_instance.set_shader_parameter(&"base_color", c)


func _apply_feedback_to_cursor(validity: bool) -> void:
	var c: Color = Color.WHITE if validity else Color.RED
	c.a = 0.5
	_cell_indicator.grid_color = c


func _prepare_preview(preview: Node3D) -> void:
	var col: Array[CollisionObject3D] = []
	var geo: Array[GeometryInstance3D] = []
	
	_find_geometry(preview, geo)
	_find_collision(preview, col)
	
	for child: CollisionObject3D in col:
		child.collision_layer = 0
	
	for child: GeometryInstance3D in geo:
		child.material_override = _preview_material_instance
	
	add_child(preview)


func _prepare_cursor(size: Vector3i) -> void:
	if size.x > 0 and size.z > 0:
		_cursor_offset = Vector3(
			0.5 if size.x % 2 == 0 else 0.0,
			0,
			0.5 if size.z % 2 == 0 else 0.0
		)
		
		_cell_indicator.plane_size = Vector2(size.x, size.z)


func _find_geometry(node: Node, result: Array) -> void:
	if node is GeometryInstance3D:
		result.push_back(node)
	for child: Node in node.get_children():
		_find_geometry(child, result)


func _find_collision(node: Node, result: Array) -> void:
	if node is CollisionObject3D:
		result.push_back(node)
	for child: Node in node.get_children():
		_find_collision(child, result)
