extends IBuildingState3D
class_name PlacementState3D

var _selected_object_index: int = -1
var id: int
var grid: GridMap
var preview_system: PreviewSystem3D
var database: ObjectsDatabase3D
var floor_data: GridData3D
var furniture_data: GridData3D
var object_placer: ObjectPlacer3D
var sound_feedback: SoundFeedBack3D

func _init( sid: int,
			sgrid: GridMap,
			preview: PreviewSystem3D,
			datab: ObjectsDatabase3D,
			flo_data: GridData3D,
			fur_data: GridData3D,
			obj_placer: ObjectPlacer3D,
			sound: SoundFeedBack3D) -> void:
	id = sid
	grid = sgrid
	preview_system = preview
	database = datab
	floor_data = flo_data
	furniture_data = fur_data
	object_placer = obj_placer
	sound_feedback = sound
	
	var obj: ObjectData3D = database.objects_data.filter(
		func(data: ObjectData3D) -> bool:
			return data.id == id
	).front()
	_selected_object_index = database.objects_data.find(obj)
	
	if _selected_object_index > -1:
		preview_system.start_showing_placement_preview(
			database.objects_data[_selected_object_index].object_scene,
			database.objects_data[_selected_object_index].size
		)
	else:
		printerr("No object with id %s" % id)


func end_state() -> void:
	self.preview_system.stop_showing_preview()


func on_action(grid_pos: Vector3i) -> void:
	var place_valid: bool = _check_placement_validity(
		grid_pos, _selected_object_index)
	if !place_valid:
		sound_feedback.play_sound(SoundFeedBack3D.SoundType.WRONG_PLACE)
		return
	sound_feedback.play_sound(SoundFeedBack3D.SoundType.PLACE)
	var obj_idx: int = object_placer.place_object(
		database.objects_data[_selected_object_index].object_scene,
		grid.to_global(grid.map_to_local(grid_pos)),
		grid
	)
	
	var selected_data: GridData3D = floor_data \
		 if database.objects_data[_selected_object_index].id == 0 \
		 else furniture_data
	
	selected_data.add_object_at(
		grid_pos, 
		database.objects_data[_selected_object_index].size,
		database.objects_data[_selected_object_index].id,
		obj_idx
	)
	
	preview_system.update_position(
		grid.to_global(grid.map_to_local(grid_pos)),
		false
	)


func _check_placement_validity(grid_pos: Vector3i, _sel_obj_idx: int) -> bool:
	var selected_data: GridData3D = floor_data \
		 if database.objects_data[_sel_obj_idx].id == 0 \
		 else furniture_data
	
	return selected_data.can_place_object_at(
		grid_pos, database.objects_data[_sel_obj_idx].size)


func update_state(grid_pos: Vector3i) -> void:
	var place_valid: bool = _check_placement_validity(
		grid_pos, _selected_object_index)
	preview_system.update_position(
		grid.to_global(grid.map_to_local(grid_pos)),
		place_valid
	)
