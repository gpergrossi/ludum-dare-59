class_name Song extends Resource

@export var bps : float = 2

# sort me by start_beat before use!
@export var notes : Array[Note] = []

@export var blue_parts: Array[Part] = []
@export var red_parts: Array[Part] = []
@export var yellow_parts: Array[Part] = []

func sort_notes() -> void:
	notes.sort_custom(func (lhs : Note, rhs : Note):
		return lhs.beat < rhs.beat)
