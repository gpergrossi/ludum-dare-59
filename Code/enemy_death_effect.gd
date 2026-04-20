class_name EnemyDeathEffect extends Node3D

@export var particles : Array[GPUParticles3D] = []
@export var lifespan = 1.0

func _ready() -> void:
	for particle in particles:
		particle.one_shot = true
	
	get_tree().create_timer(lifespan).timeout.connect(func():
		queue_free())
	
