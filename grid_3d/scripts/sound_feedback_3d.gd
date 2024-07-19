extends AudioStreamPlayer
class_name SoundFeedBack3D

enum SoundType {
	CLICK,
	PLACE,
	REMOVE,
	WRONG_PLACE,
}

@export var _click_sound: AudioStream
@export var _place_sound: AudioStream
@export var _remove_sound: AudioStream
@export var _wrong_place_sound: AudioStream


func play_sound(sound_type: SoundType) -> void:
	match sound_type:
		SoundType.CLICK:
			stream = _click_sound
			play()
		SoundType.PLACE:
			stream = _place_sound
			play()
		SoundType.REMOVE:
			stream = _remove_sound
			play()
		SoundType.WRONG_PLACE:
			stream = _wrong_place_sound
			play()
