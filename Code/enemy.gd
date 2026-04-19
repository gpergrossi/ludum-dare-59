class_name Enemy extends Node3D

func _ready() -> void:
	assert(is_in_group(&"enemies"))
