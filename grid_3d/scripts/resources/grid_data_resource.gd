extends Resource
class_name GridData3D

@export var _placed_objects: Dictionary = {}

func add_object_at( grid_position: Vector3i,
					object_size: Vector3i,
					id: int,
					placed_object_idx: int) -> void:
	var pos_to_ocp: Array[Vector3i] = _calculate_positions(
		grid_position, object_size)
	var data: PlacementData = PlacementData.new(pos_to_ocp, id, placed_object_idx)
	
	for pos: Vector3i in pos_to_ocp:
		if _placed_objects.has(pos):
			printerr("Dictionary already has this cell pos %s" % pos)
		_placed_objects[pos] = data


func _calculate_positions(grid_pos: Vector3i, obj_size: Vector3i) -> Array[Vector3i]:
	var return_val: Array[Vector3i] = []
	for x: int in obj_size.x:
		for y: int in obj_size.y:
			for z: int in obj_size.z:
				return_val.append(grid_pos + Vector3i(x,y,z))
	
	return return_val


func can_place_object_at(grid_pos: Vector3i, obj_size: Vector3i) -> bool:
	var pos_to_ocp: Array[Vector3i] = _calculate_positions(grid_pos, obj_size)
	for pos: Vector3i in pos_to_ocp:
		if _placed_objects.has(pos):
			return false
	return true


func get_representation_index(grid_pos: Vector3i) -> int:
	if !_placed_objects.has(grid_pos):
		return -1
	
	return _placed_objects[grid_pos].placed_object_index


func remove_object_at(grid_pos: Vector3i) -> void:
	for pos: Vector3i in _placed_objects[grid_pos].occupied_positions:
		_placed_objects.erase(pos)
		
