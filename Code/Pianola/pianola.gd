class_name Pianola extends Node

var _current_time : float = 0.0

var _instruments : Array[Instrument] = []

var _song_start_time : float = 0.0
var _next_note_idx : int
var song : Song :
	get:
		return song
	set(value):
		song = value
		_song_start_time = _current_time
		song.sort_notes()
		_next_note_idx = 0

func _ready() -> void:
	# Instruments look this up as %Pianola.
	assert(unique_name_in_owner)
	assert(name == &"Pianola")

func register_instrument(instrument : Instrument) -> void:
	_instruments.push_back(instrument)
	instrument.tree_exiting.connect(func ():
		_instruments.erase(instrument))

func _process(delta: float) -> void:
	_current_time += delta

	if song == null:
		# Not currently playing.
		return
	
	# TODO: there's calculable latency in audio playback - we could try to account for it.
	var beat = (_current_time - _song_start_time) * song.bps

	while _next_note_idx < song.notes.size() and song.notes[_next_note_idx].beat <= beat:
		var note = song.notes[_next_note_idx]
		for instrument in _instruments:
			if instrument.part != note.part:
				continue
			instrument.play_note(note)
		_next_note_idx += 1
