extends IBuildingState3D
class_name RemovingState3D

var _object_index: int = -1
var grid: GridMap
var preview_system: PreviewSystem3D
var floor_data: GridData3D
var furniture_data: GridData3D
var object_placer: ObjectPlacer3D
var sound_feedback: SoundFeedBack3D

func _init( sgrid: GridMap,
			preview: PreviewSystem3D,
			flo_data: GridData3D,
			fur_data: GridData3D,
			obj_placer: ObjectPlacer3D,
			sound: SoundFeedBack3D) -> void:
	grid = sgrid
	preview_system = preview
	floor_data = flo_data
	furniture_data = fur_data
	object_placer = obj_placer
	sound_feedback = sound
	
	preview_system.start_showing_remove_preview()


func end_state() -> void:
	preview_system.stop_showing_preview()


func on_action(grid_pos: Vector3i) -> void:
	var selected_data: GridData3D = null
	if !furniture_data.can_place_object_at(grid_pos, Vector3i.ONE):
		selected_data = furniture_data
	elif !floor_data.can_place_object_at(grid_pos, Vector3i.ONE):
		selected_data = floor_data
	
	if !selected_data:
		sound_feedback.play_sound(SoundFeedBack3D.SoundType.WRONG_PLACE)
		return
	else:
		_object_index = selected_data.get_representation_index(grid_pos)
		if _object_index == -1:
			sound_feedback.play_sound(SoundFeedBack3D.SoundType.WRONG_PLACE)
			return
		sound_feedback.play_sound(SoundFeedBack3D.SoundType.REMOVE)
		selected_data.remove_object_at(grid_pos)
		object_placer.remove_object_at(_object_index)
	var cell_pos: Vector3 = grid.to_global(grid.map_to_local(grid_pos))
	preview_system.update_position(cell_pos, check_selection_valid(grid_pos))


func update_state(grid_pos: Vector3i) -> void:
	var validity: bool = check_selection_valid(grid_pos)
	preview_system.update_position(
		grid.to_global(grid.map_to_local(grid_pos)),
		validity
	)


func check_selection_valid(grid_pos: Vector3i) -> bool:
	return !(furniture_data.can_place_object_at(grid_pos, Vector3i.ONE) and \
		floor_data.can_place_object_at(grid_pos, Vector3i.ONE))
