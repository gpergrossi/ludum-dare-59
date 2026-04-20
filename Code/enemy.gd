class_name Enemy extends Node3D

@export var path : Path3D

@onready var hit_target_position : Node3D = %HitTargetPosition

@export var velocity := 1.0
@export var offset_on_curve := 0.0

# How much damage this can take.
@export var health := 100.0

# How much damage this deals to the player.
@export var damage := 10.0

# Should be a EnemyDeathEffect
@export var death_effect : PackedScene

@export var enemy_part: Node3D
@export var idle_animation: StringName

# Fired when the enemy reaches the end of the curve.
signal on_reach_end()

func _ready() -> void:
	assert(is_in_group(&"Enemies"))
	global_position = path.curve.sample_baked(0.0)
	if not idle_animation.is_empty():
		var anims := enemy_part.find_child("AnimationPlayer", false, true) as AnimationPlayer
		if anims:
			anims.play(idle_animation)

func _process(delta: float) -> void:
	offset_on_curve += velocity * delta
	var curve = path.curve

	if offset_on_curve > curve.get_baked_length():
		offset_on_curve = curve.get_baked_length()
		on_reach_end.emit()
		queue_free()
		
	var sampled_transform := curve.sample_baked_with_rotation(offset_on_curve)
	global_position = path.to_global(sampled_transform.origin)
	global_rotation.y = path.global_rotation.y + sampled_transform.basis.get_euler().y
	
func take_damage(taken : float):
	health -= taken
	if health < 0.0:
		var effect : EnemyDeathEffect = death_effect.instantiate()
		get_parent().add_child(effect)
		effect.global_transform = global_transform
		queue_free()
