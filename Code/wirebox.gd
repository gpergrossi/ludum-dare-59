class_name Wirebox extends Node3D

signal hover_changed(hovered: bool)
signal select_changed(selected: bool)

@export var jack_count: int = 3

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

@onready var jack_position: Node3D = $JackPosition
