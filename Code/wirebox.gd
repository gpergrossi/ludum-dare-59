class_name Wirebox extends Node3D

signal hover_changed(hovered: bool)
signal select_changed(selected: bool)

@export var jack_count: int = 3
@export var jack_positions: Array[Node3D] = []

var jacks_filled: int = 0

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
