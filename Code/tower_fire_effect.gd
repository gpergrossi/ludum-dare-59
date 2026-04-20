class_name TowerFireEffect extends Node3D

@export var particles : Array[GPUParticles3D] = []

func _ready() -> void:
	hide()
	for particle in particles:
		particle.one_shot = true
		
func fire() -> void:
	show()
	for particle in particles:
		particle.restart()
