@tool
class_name TowerTopper extends Node3D

@onready var animation_player := tower_part.find_child("AnimationPlayer", false, true) as AnimationPlayer

@export var tower_part: Node3D
@export var idle_animation: StringName
@export var attack_animation: StringName
@export var fire_effect : TowerFireEffect
@export var laser_color : Color

func _ready() -> void:
	if animation_player:
		animation_player.animation_finished.connect(on_finished)
		if not idle_animation.is_empty():
			animation_player.play(idle_animation)

func pause() -> void:
	animation_player.pause()

func resume() -> void:
	if animation_player.current_animation == null:
		animation_player.play(idle_animation)
	else:
		animation_player.play()

func on_finished(anim_name : StringName) -> void:
	animation_player.play(idle_animation)

func attack() -> void:
	animation_player.play(attack_animation)
