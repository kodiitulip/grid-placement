extends Resource
class_name PlacementData

var occupied_positions: Array[Vector3i] = []
var id: int = -1
var placed_object_index: int = -1

func _init(poss: Array[Vector3i], i: int, object_idx: int) -> void:
	occupied_positions = poss
	id = i
	placed_object_index = object_idx
