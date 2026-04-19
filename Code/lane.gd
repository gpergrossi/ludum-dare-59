class_name Lane extends Node3D

@export var path: Path3D
@export var enemy_base: EnemyBase
@export var home_base: HomeBase

func spawn(enemy_type: EnemyType.Enum) -> void:
	print(self.name + " spawns " + EnemyType.name_of(enemy_type))
