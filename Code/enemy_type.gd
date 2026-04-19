class_name EnemyType extends Resource

enum Enum {
	None,
	Box,
	Ball,
	Cone
}

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
