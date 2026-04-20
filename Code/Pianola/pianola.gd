class_name Pianola extends Node

static var INSTANCE: Pianola

signal song_changed(song: Song)

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
		_next_note_idx = 0
		if song != null:
			song.sort_notes()
		song_changed.emit(song)
		print("Song starting with " + str(_instruments.size()) + " instruments")

func _ready() -> void:
	# Instruments look this up as %Pianola.
	assert(unique_name_in_owner)
	#assert(name == &"Pianola")   #Disabled so the SongTest scene can use a separate instance
	if (INSTANCE != null): assert(false)
	INSTANCE = self;

func register_instrument(instrument : Instrument) -> void:
	_instruments.push_back(instrument)
	instrument.tree_exiting.connect(func ():
		#print("Unregistered instrument " + instrument.name + " from part " + instrument.part.name)
		_instruments.erase(instrument))
	#print("Registered instrument " + instrument.name + " to part " + instrument.part.name + " totaling " + str(_instruments.size()) + " parts")

func _process(delta: float) -> void:
	_current_time += delta

	if song == null:
		# Not currently playing.
		return
	
	# TODO: there's calculable latency in audio playback - we could try to account for it.
	var beat = (_current_time - _song_start_time) * song.bps

	while _next_note_idx < song.notes.size() and song.notes[_next_note_idx].beat <= beat:
		var note = song.notes[_next_note_idx]
		#print(note.part.name + (" spawn enemy " + EnemyType.name_of(note.spawn_enemy) if note.audio_stream == null else " play note " + note.audio_stream.resource_name))
		for instrument in _instruments:
			if instrument.part != note.part:
				continue
			instrument.play_note(note)
		_next_note_idx += 1
