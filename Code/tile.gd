class_name Tile extends Node3D

var level: Level
var coord: Vector2i
var offset: Vector3

func _ready() -> void:
	refresh_tile_position()

func refresh_tile_position() -> void:
	find_level()
	var xi = roundi(global_position.x / Level.GRID_SIZE)
	var zi = roundi(global_position.z / Level.GRID_SIZE)
	var y = global_position.y
	coord = Vector2i(xi, zi)
	offset = global_position - Vector3(-xi, y, -zi)

func find_level() -> void:
	var node := get_parent()
	while node != null:
		if node is Level:
			level = node as Level
			return
		node = node.get_parent()
