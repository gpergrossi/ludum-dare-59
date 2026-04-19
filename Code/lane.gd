class_name Lane extends Node3D

@export var path: Path3D
@export var enemy_base: EnemyBase
@export var home_base: HomeBase

signal on_enemy_spawned(enemy : Enemy)

func spawn(enemy_type: EnemyType.Enum) -> void:
	var enemy : Enemy = EnemyType.prototype_for(enemy_type).instantiate()
	enemy.path = path
	add_child(enemy)
	on_enemy_spawned.emit(enemy)
