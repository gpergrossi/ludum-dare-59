class_name EnemyType extends Resource

enum Enum {
	None,
	Box,
	Ball,
	Cone
}

static func prototype_for(type : Enum) -> PackedScene:
	match(type):
		Enum.Box: return preload("res://Scenes/Enemies/box_enemy.tscn")
		Enum.Ball: return preload("res://Scenes/Enemies/ball_enemy.tscn")
		Enum.Cone: return preload("res://Scenes/Enemies/cone_enemy.tscn")
	return null

static func name_of(type: Enum) -> String:
	match(type):
		Enum.Box: return "Box"
		Enum.Ball: return "Ball"
		Enum.Cone: return "Cone"
	return ""

@export var type_enum: Enum
@export var scene_uid: PackedScene

var name: String:
	get(): return name_of(type_enum)
