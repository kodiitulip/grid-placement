extends Node
class_name ObjectPlacer3D

@export var _placed_objects: Array[Node3D] = []


func place_object(obj_scene: PackedScene, position: Vector3, container: Node) -> int:
	var new_object: Node3D = obj_scene.instantiate()
	container.add_child(new_object)
	new_object.position = position
	_placed_objects.append(new_object)
	return _placed_objects.find(new_object)


func remove_object_at(obj_index: int) -> void:
	if _placed_objects.size() <= obj_index or !_placed_objects[obj_index]:
		return
	_placed_objects[obj_index].queue_free()
	_placed_objects[obj_index] = null
