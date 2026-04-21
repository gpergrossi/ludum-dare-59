class_name LaserBeam extends Node3D

@onready var mesh : MeshInstance3D = $MeshInstance3D
@onready var animation_player := $MeshInstance3D/AnimationPlayer

func set_laser_color(color : Color) -> void:
	var material = mesh.get_surface_override_material(0) as StandardMaterial3D
	color.a = material.albedo_color.a
	material.albedo_color = color

func fire(from : Vector3, to : Vector3) -> void:
	show()
	global_position = (from + to) / 2.0
	look_at(to)
	scale.z = from.distance_to(to)
	animation_player.play("fade_out")
	
