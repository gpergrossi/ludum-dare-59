class_name EnemyType extends Resource

enum Enum {
	Box,
	Ball,
	Cone
}

static func get_type_name(type: Enum) -> String:
	match(type):
		Enum.Box: return "Box"
		Enum.Ball: return "Ball"
		Enum.Cone: return "Cone"
	return ""

@export var type_enum: Enum
@export var scene_uid: PackedScene

var name: String:
	get(): return get_type_name(type_enum)
