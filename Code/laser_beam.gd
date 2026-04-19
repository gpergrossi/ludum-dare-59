class_name LaserBeam extends Node3D

@onready var animation := %AnimationPlayer

func fire(from : Vector3, to : Vector3):
	show()
	global_position = (from + to) / 2.0
	look_at(to)
	scale.z = from.distance_to(to)
	animation.play("FadeOut")
	
