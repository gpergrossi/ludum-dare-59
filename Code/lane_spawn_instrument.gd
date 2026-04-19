@tool
class_name LaneSpawnInstrument extends Node3D

@export var part: Part:
	set(p):
		part = p
		if is_node_ready():
			instrument.part = p
	get():
		if is_node_ready():
			return instrument.part
		return null

@export var lane: Lane

@onready var instrument: Instrument = $Instrument

func _ready() -> void:
	instrument.part = part

func _on_instrument_on_play_note(note: Note) -> void:
	pass # Replace with function body.
