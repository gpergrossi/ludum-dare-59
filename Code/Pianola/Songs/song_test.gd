extends Node

@onready var pianola_test_instance: Pianola = %"Pianola Test Instance"
@onready var kickstrument: Instrument = %Kickstrument
@onready var hihatstrument: Instrument = %Hihatstrument
@onready var marimbastrument: Instrument = %Marimbastrument
@onready var synthstrument: Instrument = %Synthstrument

func _ready() -> void:
	print("Registering instruments");
	kickstrument.register(Pianola.INSTANCE);
	hihatstrument.register(Pianola.INSTANCE);
	marimbastrument.register(Pianola.INSTANCE);
	synthstrument.register(Pianola.INSTANCE);

	print("Generating song");
	var song = Song2.new().makeSong();
	Pianola.INSTANCE.song = song;
