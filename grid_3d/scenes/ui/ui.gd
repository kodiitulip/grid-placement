extends Control
class_name BuildUIManager3D

const UI_ITEM_BUTTON: PackedScene = preload("./ui_item_button.tscn")

signal build_object_selected(idx: int)
signal remove_mode_selected()

@export var _object_database: ObjectsDatabase3D

func _ready() -> void:
	for item: ObjectData3D in _object_database.objects_data:
		var b: UIItemButton = UI_ITEM_BUTTON.instantiate()
		b.set_meta("ItemMeta", item)
		b.button_pressed.connect(on_item_button_pressed)
		%ItemsContainer.add_child(b)


func on_item_button_pressed(id: int) -> void:
	build_object_selected.emit(id)


func _on_remove_pressed() -> void:
	remove_mode_selected.emit()
