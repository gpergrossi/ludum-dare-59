class_name CameraBounds extends Area3D

@onready var box_shape: CollisionShape3D = %BoxShape

var size: Vector3:
	get(): return (box_shape.shape as BoxShape3D).size

var min_x: float:
	get(): return global_position.x - 0.5 * size.x  if is_node_ready() else 0
	
var max_x: float:
	get(): return global_position.x + 0.5 * size.x  if is_node_ready() else 0

var min_y: float:
	get(): return global_position.y - 0.5 * size.y if is_node_ready() else 0
	
var max_y: float:
	get(): return global_position.y + 0.5 * size.y  if is_node_ready() else 0

var min_z: float:
	get(): return global_position.z - 0.5 * size.z  if is_node_ready() else 0
	
var max_z: float:
	get(): return global_position.z + 0.5 * size.z  if is_node_ready() else 0
