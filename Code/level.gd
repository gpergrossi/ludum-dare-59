@tool
class_name Level extends Node3D

const GRID_SIZE = 1.0

@export var lanes: Array[Lane] = []

@export var tower_bases: Array[TowerBase] = []

@export var song: PackedScene


func _ready() -> void:
	if not Engine.is_editor_hint():
		var song_node = song.instantiate() as SongGenerator
		add_child(song_node)
		%Pianola.song = song_node.makeSong()
