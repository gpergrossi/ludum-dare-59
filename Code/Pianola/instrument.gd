class_name Instrument extends AudioStreamPlayer3D

@export var part : Part
@export var disable_autoregister := false
@export var fade_time := 0.01

@export var samples_folder: String
@export var sample_streams: Array[AudioStream] = []
@export var sample_keys: Array[Note.NoteName] = []

@export var manual_sample_override: Dictionary[Note.NoteName, AudioStream] = {}

var default_volume_db := 0.0
var note_tween : Tween

signal on_play_note(note : Note)

func _ready() -> void:
	load_audio_from_folder()
	default_volume_db = volume_db
	finished.connect(on_finished)
	if not disable_autoregister: 
		register()

func register(registration_target: Pianola = null) -> void:
	if (registration_target == null): registration_target = get_tree().current_scene.find_child("Pianola") as Pianola;
	registration_target.register_instrument(self);

func play_note(note : Note) -> void:
	if note_tween and note_tween.is_valid():
		note_tween.kill()

	# Reset volume before playing
	volume_db = default_volume_db + linear_to_db(note.volume_scale)
	
	# Play audio stream
	if note.note != Note.NoteName.No_Note:
		var sample := get_sample_for_note(note.note)
		stream = sample.stream
		pitch_scale = sample.pitch_bend
		play()
	
		if note.duration > 0.0:
			# Handle note duration + fade out
			note_tween = create_tween()
			note_tween.tween_interval(note.duration)
			note_tween.tween_property(self, "volume_db", -80.0, fade_time)
			note_tween.tween_callback(stop)
	
	# Send event
	on_play_note.emit(note)

func on_finished() -> void:
	if note_tween and note_tween.is_valid():
		note_tween.kill()

func load_audio_from_folder():
	sample_streams.clear()

	var dir := DirAccess.open(samples_folder)
	if dir == null:
		push_error("Could not open folder: " + samples_folder)
		return

	var files: Array[String] = []

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir():
			var ext = file_name.get_extension().to_lower()

			# Filter common audio formats Godot can import
			if ext in ["ogg", "wav", "mp3", "flac"]:
				files.append(file_name)

		file_name = dir.get_next()

	dir.list_dir_end()

	# Ensure alphabetical order (filesystem may already be sorted, but this guarantees it)
	files.sort()

	const letter_indices: Dictionary[String, int] = {
		"C" = 0, "D" = 2, "E" = 4, "F" = 5, "G" = 7, "A" = 9, "B" = 11,
	}

	var dic: Dictionary[Note.NoteName, AudioStream]

	# Load them as AudioStreams
	for f in files:
		var name_part := f.substr(0, f.rfind("."))
		name_part = name_part.substr(name_part.rfind("_")+1)
		
		if not letter_indices.has(name_part[0]): continue
		var num := letter_indices[name_part[0]]
		if name_part[1] == "s" or name_part[1] == "#": num += 1
		var oct := int(name_part[len(name_part)-1])
		if oct < 1 or oct > 9: continue
		num += 12 + oct * 12
		
		var full_path = samples_folder.path_join(f)
		var stream = ResourceLoader.load(full_path)
		
		var useless_id: int = Note.NoteName.values().find(num)
		var note_name: String = Note.NoteName.keys()[useless_id]
		var note := Note.string_to_note(note_name)
		
		print(note_name + " (" + str(note) + ") loaded from file " + full_path)

		if stream is AudioStream:
			dic[note] = stream
	
	for key in manual_sample_override.keys():
		dic[key] = manual_sample_override[key]
	
	var keys_list := dic.keys()
	keys_list.sort()
	for key in keys_list:
		sample_keys.append(key)
		sample_streams.append(dic[key])


func get_sample_for_note(note: Note.NoteName) -> Dictionary:
	var target_freq: float = Note.get_frequency(note)

	if sample_streams.is_empty() or sample_keys.is_empty():
		push_error("No samples or keys assigned.")
		return {}

	# Find closest sample by frequency distance
	var closest_index := 0
	var closest_distance := INF

	for i in sample_keys.size():
		var sample_freq := Note.get_frequency(sample_keys[i])
		var dist := absf(target_freq - sample_freq)

		if dist < closest_distance:
			closest_distance = dist
			closest_index = i

	var sample_note := sample_keys[closest_index]
	var sample_freq := Note.get_frequency(sample_note)

	var stream: AudioStream = sample_streams[closest_index]

	# Avoid division by zero safety
	var pitch_bend := 1.0
	if sample_freq > 0.0:
		pitch_bend = target_freq / sample_freq

	return {
		"stream": stream,
		"pitch_bend": pitch_bend
	}
