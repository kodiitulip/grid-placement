@tool
extends CSGMesh3D
class_name GridVisualization3D

const _grid_shader: Shader = preload("res://grid_3d/assets/shaders/grid_shader.gdshader")

@export var _grid_size: Vector2 = Vector2(20,20):
	set = _set_grid_size
@export var _plane_size: Vector2 = Vector2(20,20):
	set = _set_plane_size
@export var _grid_color: Color = Color.WHITE:
	set = _set_grid_color
@export var _grid_lines_width: float = 0.06:
	set = _set_grid_line_width

var _plane: PlaneMesh
var _shader: ShaderMaterial

func _enter_tree() -> void:
	_plane = PlaneMesh.new()
	_plane.size = Vector2(20,20)
	mesh = _plane
	_shader = ShaderMaterial.new()
	_shader.shader = _grid_shader
	_shader.set_shader_parameter(&"scale", _grid_size)
	_shader.set_shader_parameter(&"color", _grid_color)
	_shader.set_shader_parameter(&"line_scale", _grid_lines_width)
	material = _shader


func _set_plane_size(value: Vector2) -> void:
	_plane_size = value
	_plane.size = _plane_size
	mesh = _plane


func _set_grid_size(value: Vector2) -> void:
	_grid_size = value
	_shader.set_shader_parameter(&"scale", _grid_size)
	_plane_size = _grid_size
	material = _shader


func _set_grid_color(value: Color) -> void:
	_grid_color = value
	_shader.set_shader_parameter(&"color", _grid_color)
	material = _shader


func _set_grid_line_width(value: float) -> void:
	_grid_lines_width = value
	_shader.set_shader_parameter(&"line_scale", _grid_lines_width)
	material = _shader
