@tool
class_name Level extends Node3D

const GRID_SIZE = 1.0

@export var lanes: Array[Lane] = []

@export var towers: Array[Tower] = []

@export var max_health : float = 100.0
@export var current_health : float
@onready var _health_bar : ProgressBar = get_tree().get_first_node_in_group("HealthBar")


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
		current_health -= enemy.damage
		_health_bar.value = current_health)
