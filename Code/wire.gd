@tool
class_name Wire extends Node3D

@onready var plug_a: Node3D = %PlugA
@onready var plug_b: Node3D = %PlugB
@onready var wire_path: Path3D = %WirePath
@onready var wire_mesh: MeshInstance3D = %WireMesh

var plug_a_pos: Vector3
var plug_a_rot: Vector3

var plug_b_pos: Vector3
var plug_b_rot: Vector3

func _process(_delta: float) -> void:
	var changed := is_changed()
	if changed:
		do_changes()
		
	
func is_changed() -> bool:
	if (plug_a.position - plug_a_pos).length_squared() > 0.0001:
		return true
	elif (plug_b.position - plug_b_pos).length_squared() > 0.0001:
		return true
	elif (plug_a.rotation - plug_a_rot).length_squared() > 0.01:
		return true
	elif (plug_b.rotation - plug_b_rot).length_squared() > 0.01:
		return true
	return false


func do_changes() -> void:
	plug_a_pos = plug_a.position
	plug_a_rot = plug_a.rotation
	plug_b_pos = plug_b.position
	plug_b_rot = plug_b.rotation
	update_curve()
	update_mesh()


func update_curve() -> void:
	var basis_a := Basis(Quaternion.from_euler(plug_a_rot))
	var basis_b := Basis(Quaternion.from_euler(plug_b_rot))
	
	var curve := wire_path.curve
	curve.clear_points()
	curve.add_point(plug_a_pos, Vector3.ZERO, basis_a.y)
	curve.add_point(plug_a_pos + 0.3 * Vector3.UP, -basis_a.y, basis_a.y)
	
	#if plug_a_pos.distance_to(plug_b_pos) > 3.0:
		#var middle := (plug_a_pos + plug_b_pos) * 0.5 + Vector3.UP
		#var dir := (plug_b_pos - plug_a_pos).normalized()
		#curve.add_point(middle, -dir, dir)
	
	curve.add_point(plug_b_pos + 0.3 * Vector3.UP, basis_b.y, -basis_b.y)
	curve.add_point(plug_b_pos, basis_b.y, Vector3.ZERO)


func update_mesh() -> void:
	if not wire_mesh: return
	var mesh := wire_mesh.mesh as ArrayMesh
	if not mesh: return
	
