@tool
class_name Level extends Node3D

const GRID_SIZE = 1.0

@export var lanes: Array[Lane] = []
@export var songs: Array[Song] = []

@export var max_health : float = 100.0
@export var current_health : float

@export var ui: EveryUi

signal song_changed(song: Song)

var song: Song:
	get(): return null if not is_node_ready() else %Pianola.song

enum LevelState {
	PLAYING,
	LOST
}

var _level_state := LevelState.PLAYING


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	%Pianola.song_changed.connect(func(song: Song): song_changed.emit(song))
	%Pianola.song = %SongGenerator.makeSong()
	
	current_health = max_health
	ui.set_health(current_health, max_health)

	for lane in lanes:
		lane.on_enemy_spawned.connect(_enemy_spawned)

func _enemy_spawned(enemy : Enemy):
	enemy.on_reach_end.connect(func():
		_take_damage(enemy.damage))

func _take_damage(amount : float):
		current_health -= amount
		ui.set_health(current_health, max_health)
		
		if current_health < 0 && _level_state != LevelState.LOST:
			_level_state = LevelState.LOST
			ui.lose_screen()
		
	
