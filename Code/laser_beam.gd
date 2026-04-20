class_name LaserBeam extends Node3D

@onready var mesh : MeshInstance3D = $MeshInstance3D

func set_laser_color(color : Color) -> void:
	var material = mesh.get_surface_override_material(0) as StandardMaterial3D
	material.albedo_color = color

func fire(from : Vector3, to : Vector3) -> void:
	show()
	global_position = (from + to) / 2.0
	look_at(to)
	scale.z = from.distance_to(to)
	var material = mesh.get_surface_override_material(0) as StandardMaterial3D
	material.albedo_color.a = 1.0
	get_tree().create_tween().tween_property(material, "albedo_color:a", 0.0, 0.2)
	
