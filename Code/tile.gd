class_name Tile extends Node3D

@export var walkable := false

var coord: Vector2i
var offset: Vector3


func _ready() -> void:
	refresh_tile_position()

func refresh_tile_position() -> void:
	var xi = roundi(global_position.x / Level.GRID_SIZE)
	var zi = roundi(global_position.z / Level.GRID_SIZE)
	var y = global_position.y
	coord = Vector2i(xi, zi)
	offset = global_position - Vector3(-xi, y, -zi)

func _process(delta: float) -> void:
	pass
