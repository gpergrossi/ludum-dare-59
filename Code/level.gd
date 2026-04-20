@tool
class_name Level extends Node3D

const GRID_SIZE = 1.0

@export var lanes: Array[Lane] = []

@export var max_health : float = 100.0
@export var current_health : float

@export var ui: EveryUi
@export var wirebox : WireboxRayInteractor

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

	Pianola.INSTANCE.song_changed.connect(func(song: Song): song_changed.emit(song))
	Pianola.INSTANCE.song = %SongGenerator.makeSong()
	
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
			Pianola.INSTANCE.song = null
			ui.show_lose_screen()
			ui.restart_pressed.connect(func():
				_reset())

func _reset():
	wirebox.reset()
	ui.hide_lose_screen()

	var replacement : Level = load(scene_file_path).instantiate()
	
	replacement.max_health = current_health
	replacement.ui = ui
	replacement.wirebox = wirebox
	
	get_parent_node_3d().add_child(replacement)
	queue_free()
	
