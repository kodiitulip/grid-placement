extends Control
class_name BuildUIManager3D

signal build_object_selected(idx: int)

@export var _object_database: ObjectsDatabase3D

func _on_cube_pressed() -> void:
	build_object_selected.emit(1)


func _on_slab_pressed() -> void:
	build_object_selected.emit(0)
