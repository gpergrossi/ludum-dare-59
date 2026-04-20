class_name Wirebox extends Node3D

signal hover_changed(hovered: bool)
signal select_changed(selected: bool)

@export var jack_count: int = 3
@export var jack_positions: Array[Node3D] = []
@export var jack_plugs: Array[Plug] = []

func _ready() -> void:
	for i in range(jack_count):
		if jack_positions.size() == i:
			jack_positions.append(null)
		if jack_plugs.size() == i:
			jack_plugs.append(null)

var selected := false:
	set(s):
		if selected != s:
			selected = s
			select_changed.emit(selected)

var hovered := false:
	set(h):
		if hovered != h:
			hovered = h
			hover_changed.emit(hovered)

func has_empty_slot() -> bool:
	return find_empty_slot() != -1

func get_slot_transform(slot: int) -> Transform3D:
	if (slot == -1):
		return Transform3D(Basis.IDENTITY, Vector3.UP * 10)
	return jack_positions[slot].global_transform

func find_empty_slot() -> int:
	return find_slot(null)

func claim_slot(slot: int, plug: Plug) -> void:
	assert(jack_plugs[slot] == null)
	jack_plugs[slot] = plug
	plug.wirebox = self

func release_slot(slot: int, plug: Plug) -> void:
	assert(jack_plugs[slot] == plug)
	plug.wirebox = null
	jack_plugs[slot] = null

func find_slot(plug: Plug) -> int:
	for i in range(jack_count):
		if jack_plugs[i] == plug: return i
	return -1
