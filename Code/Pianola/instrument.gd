class_name Instrument extends AudioStreamPlayer3D

@export var part : Part
@export var disable_autoregister := false

signal on_play_note(note : Note)

func _ready() -> void:
	if not disable_autoregister: 
		register()

func register() -> void:
	get_tree().current_scene.find_child("Pianola").register_instrument(self)

func play_note(note : Note) -> void:
	stream = note.audio_stream
	play()
	on_play_note.emit(note)
