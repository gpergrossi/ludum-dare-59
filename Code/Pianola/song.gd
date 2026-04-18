class_name Song extends Resource

@export var bps : float = 2

# sort me by start_beat before use!
@export var notes : Array[Note] = []

func sort_notes() -> void:
	notes.sort_custom(func (lhs : Note, rhs : Note):
		return lhs.beat < rhs.beat)
