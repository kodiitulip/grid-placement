extends AspectRatioContainer
class_name UIItemButton

signal button_pressed(id: int)


func _on_button_pressed() -> void:
	if !has_meta("ItemMeta"):
		printerr("no meta")
		return
	
	var data: ObjectData3D = get_meta("ItemMeta")
	if !data:
		printerr("no data in meta")
		return
	button_pressed.emit(data.id)
