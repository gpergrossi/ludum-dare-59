extends Node

@onready var pianola_test_instance: Pianola = %"Pianola Test Instance"
@onready var drumstrument: Instrument = %Drumstrument
@onready var marimbastrument: Instrument = %Marimbastrument
@onready var synthstrument: Instrument = %Synthstrument

func _ready() -> void:
	print("Registering instruments");
	drumstrument.register(Pianola.INSTANCE);
	marimbastrument.register(Pianola.INSTANCE);
	synthstrument.register(Pianola.INSTANCE);

	print("Generating song");
	#var song = SongLoader.new(SongLoader.SONG_GRAVITY_FALLS).makeSong();
	var song = Song2.new().makeSong();
	Pianola.INSTANCE.song = song;
