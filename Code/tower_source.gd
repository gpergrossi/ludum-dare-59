@tool
class_name TowerSource extends Node3D

@export var tower_part: Node3D
@export var idle_animation: StringName
@export var wirebox: Wirebox

func _ready() -> void:
	if not idle_animation.is_empty():
		var anims := tower_part.find_child("AnimationPlayer", false, true) as AnimationPlayer
		if anims:
			anims.play(idle_animation)
	
