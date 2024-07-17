extends Resource
class_name ObjectData3D

@export_placeholder("Object Name") var name: String:
	set(value):
		name = value
		resource_name = name
@export var id: int = 0
@export var size: Vector3i = Vector3i(1,1,1)
@export var object_scene: PackedScene
