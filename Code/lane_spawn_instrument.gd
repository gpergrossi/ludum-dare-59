class_name LaneSpawnInstrument extends Node3D

@export var part: Part
@export var lane: Lane

@onready var spawnstrument: Instrument = %Spawnstrument

func _ready() -> void:
	spawnstrument.part = part
	spawnstrument.register()

func _on_instrument_on_play_note(note: Note) -> void:
	lane.spawn(note.spawn_enemy)
