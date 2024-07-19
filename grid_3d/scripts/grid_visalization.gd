@tool
extends CSGMesh3D
class_name GridVisualization3D

const _grid_shader: ShaderMaterial = preload("res://grid_3d/assets/shaders/grid_material.tres")

@export var grid_size: Vector2 = Vector2(20,20):
	set = _set_grid_size
@export var plane_size: Vector2 = Vector2(20,20):
	set = _set_plane_size
@export var grid_color: Color = Color(1.0, 1.0, 1.0, 0.3):
	set = _set_grid_color
@export var grid_lines_width: float = 0.06:
	set = _set_grid_line_width

var _plane: PlaneMesh = PlaneMesh.new()
var _shader: ShaderMaterial = _grid_shader.duplicate()

func _enter_tree() -> void:
	_plane.size = plane_size
	mesh = _plane
	_shader.set_shader_parameter(&"scale", grid_size)
	_shader.set_shader_parameter(&"color", grid_color)
	_shader.set_shader_parameter(&"line_scale", grid_lines_width)
	material = _shader


func _set_plane_size(value: Vector2) -> void:
	plane_size = value
	_plane.size = plane_size
	if grid_size != plane_size:
		grid_size = plane_size
	mesh = _plane


func _set_grid_size(value: Vector2) -> void:
	grid_size = value
	_shader.set_shader_parameter(&"scale", grid_size)
	if plane_size != grid_size:
		plane_size = grid_size
	material = _shader


func _set_grid_color(value: Color) -> void:
	grid_color = value
	_shader.set_shader_parameter(&"color", grid_color)
	material = _shader


func _set_grid_line_width(value: float) -> void:
	grid_lines_width = value
	_shader.set_shader_parameter(&"line_scale", grid_lines_width)
	material = _shader
