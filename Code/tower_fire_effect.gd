class_name TowerFireEffect extends Node3D

# to allow us to load at game start
@export var fire_immediately := false
@export var particles : Array[GPUParticles3D] = []

func _ready() -> void:
	hide()
	for particle in particles:
		particle.one_shot = true
	if fire_immediately:
		fire()
		
func fire() -> void:
	show()
	for particle in particles:
		particle.restart()
