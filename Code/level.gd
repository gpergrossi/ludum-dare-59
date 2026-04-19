@tool
class_name Level extends Node3D

const GRID_SIZE = 1.0

@export var lanes: Array[Lane] = []

@export var towers: Array[Tower] = []

@export var max_health : float = 100.0
@export var current_health : float
@onready var _health_bar : ProgressBar = get_tree().get_first_node_in_group("HealthBar")
@onready var _announce_text : Label = get_tree().get_first_node_in_group("AnnounceText")

enum LevelState {
	PLAYING,
	LOST
}

var _level_state := LevelState.PLAYING


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	%Pianola.song = %SongGenerator.makeSong()
	
	current_health = max_health
	_health_bar.max_value = max_health
	_health_bar.value = current_health

	for lane in lanes:
		lane.on_enemy_spawned.connect(_enemy_spawned)

func _enemy_spawned(enemy : Enemy):
	enemy.on_reach_end.connect(func():
		_take_damage(enemy.damage))

func _take_damage(amount : float):
		current_health -= amount
		_health_bar.value = current_health
		if current_health < 0 && _level_state != LevelState.LOST:
			_level_state = LevelState.LOST
			_announce_text.text = """you lose :(((
				
				thank you for trying anyways.
				please refresh the page to try again.
			"""
			_announce_text.show()
			_announce_text.modulate.a = 0.0
			create_tween().tween_property(_announce_text, "modulate:a", 1.0, 0.5)
		
	
