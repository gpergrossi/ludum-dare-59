class_name Lane extends Node3D

@export var path: Path3D
@export var enemy_base: EnemyBase
@export var home_base: HomeBase

func spawn(enemy_type: EnemyType.Enum) -> void:
	print(self.name + " spawns " + EnemyType.name_of(enemy_type))

func _ready() -> void:
	# TODO once we're spawning enemies from here, stop doing this and set their
	#      path when we spawn them instead.
	for enemy : Enemy in get_tree().get_nodes_in_group(&"Enemies"):
		enemy.path = path
