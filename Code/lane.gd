class_name Lane extends Node3D

@export var paths: Array[Path3D]
@export var home_base: HomeBase

signal on_enemy_spawned(enemy : Enemy)

var _next_path_idx := 0

func _ready() -> void:
	assert(not paths.is_empty())

func spawn(enemy_type: EnemyType.Enum) -> void:
	var enemy : Enemy = EnemyType.prototype_for(enemy_type).instantiate()
	enemy.path = paths[_next_path_idx]
	
	add_child(enemy)
	on_enemy_spawned.emit(enemy)
	
	_next_path_idx += 1
	_next_path_idx = _next_path_idx % paths.size()
