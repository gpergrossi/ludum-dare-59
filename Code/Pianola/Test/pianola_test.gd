extends Node

func _ready():
	var song = Song.new()
	for i in range(0, 120):
		if i % 4 == 3:
			continue
		var note := Note.new()
		note.part = preload("res://Code/Pianola/Test/kicks_resource.tres")
		note.beat = i
		note.audio_stream = preload("res://Audio/Drums/kick_drum_1.ogg")
		song.notes.push_back(note)
	for i in range(0, 120):
		var in_measure = i % 4
		if in_measure != 1:
			continue
		var note := Note.new()
		note.part = preload("res://Code/Pianola/Test/hihats_resource.tres")
		note.beat = i + 0.5
		note.audio_stream = preload("res://Audio/Drums/hihat_1.ogg")
		song.notes.push_back(note)
		
	var pianola = $Pianola
	pianola.song = song
