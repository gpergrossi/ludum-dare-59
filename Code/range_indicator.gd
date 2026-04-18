@tool
class_name RangeIndicator extends StaticBody3D

@onready var hit_sphere: CollisionShape3D = %HitSphere

@export var range := 2.5:
	set(r):
		if range != r:
			range = r
			refresh()

func _ready() -> void:
	refresh()

func refresh() -> void:
	if not is_node_ready(): return
	var sphere := hit_sphere.shape as SphereShape3D
	sphere.radius = range
