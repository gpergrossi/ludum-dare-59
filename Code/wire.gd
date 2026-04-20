@tool
class_name Wire extends Node3D

@onready var plug_a: Plug = %PlugA
@onready var plug_b: Plug = %PlugB
@onready var wire_path: Path3D = %WirePath
@onready var wire_mesh: MeshInstance3D = %WireMesh

@export var spacing := 0.1
@export var sides := 8
@export var thickness := 0.04

@export_group("internal")
@export var plug_a_pos: Vector3
@export var plug_a_rot: Vector3
@export var plug_b_pos: Vector3
@export var plug_b_rot: Vector3

func _process(_delta: float) -> void:
	var changed := is_changed()
	if changed:
		do_changes()


func is_changed() -> bool:
	if (plug_a.position - plug_a_pos).length_squared() > 0.000001:
		return true
	elif (plug_b.position - plug_b_pos).length_squared() > 0.000001:
		return true
	elif (plug_a.rotation - plug_a_rot).length_squared() > 0.0001:
		return true
	elif (plug_b.rotation - plug_b_rot).length_squared() > 0.0001:
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
	var middle := (plug_a_pos + plug_b_pos) * 0.5
	var dir := (plug_b_pos - plug_a_pos).normalized()
	
	var curve := wire_path.curve
	curve.clear_points()
	curve.add_point(plug_a_pos, Vector3.ZERO, basis_a.y * 0.1)
	curve.add_point(plug_a_pos + dir * 0.01 + 0.3 * basis_a.y, -basis_a.y * 0.1, basis_a.y)
	
	#if plug_a_pos.distance_to(plug_b_pos) > 3.0:
		#curve.add_point(middle + Vector3.UP, -dir, dir)
	
	curve.add_point(plug_b_pos - dir * 0.01 + 0.3 * basis_b.y, basis_b.y, -basis_b.y * 0.1)
	curve.add_point(plug_b_pos, basis_b.y * 0.1, Vector3.ZERO)


func disconnect_plugs() -> void:
	print("Disconnecting wire " + str(self))
	disconnect_plug(plug_a)
	disconnect_plug(plug_b)
	visible = false


func disconnect_plug(plug: Plug) -> void:
	plug.transform.origin = Vector3.UP * 100
	if plug.wirebox != null:
		var slot := plug.wirebox.find_slot(plug)
		if slot != -1:
			plug.wirebox.release_slot(slot, plug)
			print("Removing plug " + str(plug) + " from wirebox " + str(plug.wirebox) + " slot " + str(slot))
		else:
			print("no slot in wirebox matches plug!")
	else:
		print("no wirebox attached to plug")


func get_other_plug(plug: Plug) -> Plug:
	if plug_a == plug: return plug_b
	if plug_b == plug: return plug_a
	assert(false)
	return null


func update_mesh() -> void:
	var curve: Curve3D = wire_path.curve
	if curve == null:
		return

	var length: float = curve.get_baked_length()
	if length <= 0.001:
		return

	# --- determine subdivisions based on spacing ---
	var num_divs: int = max(1, int(ceil(length / spacing)))
	var actual_step: float = length / num_divs

	var rings := num_divs + 1
	var verts_per_ring := sides

	var vertices := PackedVector3Array()
	var normals := PackedVector3Array()
	var uvs := PackedVector2Array()
	var indices := PackedInt32Array()

	vertices.resize(rings * verts_per_ring)
	normals.resize(rings * verts_per_ring)
	uvs.resize(rings * verts_per_ring)

	# --- generate rings ---
	for i in range(rings):
		var dist := minf(i * actual_step, length)

		# Transform along curve (position + orientation)
		var xf: Transform3D = curve.sample_baked_with_rotation(dist, true)
		var origin: Vector3 = xf.origin

		var right := xf.basis.x
		var up := xf.basis.y

		for j in range(sides):
			var t := float(j) / float(sides)
			var angle := t * TAU

			var dir := (right * cos(angle) + up * sin(angle))
			var normal := dir.normalized()

			var v_index := i * sides + j

			vertices[v_index] = origin + dir * thickness
			normals[v_index] = normal

			uvs[v_index] = Vector2(t, float(i) / float(rings - 1))

	# --- build triangle indices ---
	for i in range(rings - 1):
		for j in range(sides):
			var j2 := (j + 1) % sides

			var a := i * sides + j
			var b := i * sides + j2
			var c := (i + 1) * sides + j
			var d := (i + 1) * sides + j2

			# tri 1
			indices.append(a)
			indices.append(b)
			indices.append(c)

			# tri 2
			indices.append(c)
			indices.append(b)
			indices.append(d)

	# --- build mesh ---
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = indices

	var mesh := wire_mesh.mesh as ArrayMesh
	mesh.clear_surfaces()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)


func _replace_existing_connections(other: Wire) -> void:
	plug_a._replace_existing_connections(other.plug_a)
	plug_b._replace_existing_connections(other.plug_b)
