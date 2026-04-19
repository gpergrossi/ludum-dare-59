class_name Enemy extends Node3D

@export var curve : Curve3D

@export var velocity := 1.0
@export var offset_on_curve := 0.0

func _ready() -> void:
	assert(is_in_group(&"Enemies"))

func _process(delta: float) -> void:
	offset_on_curve += velocity * delta
	if offset_on_curve > curve.get_baked_length():
		offset_on_curve = curve.get_baked_length()
		# TODO whatever happens when we hit the end.
	
	transform = curve.sample_baked_with_rotation(offset_on_curve)
