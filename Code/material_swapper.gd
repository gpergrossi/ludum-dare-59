class_name MaterialSwapper extends Node3D

var all_meshes: Array[MeshInstance3D] = []

func _ready() -> void:
	scan(self)
	print("Found " + str(all_meshes.size()) + " meshes")

func scan(obj: Node) -> void:
	if obj is MeshInstance3D:
		all_meshes.append(obj as MeshInstance3D)
	for child in obj.get_children():
		scan(child)

func set_override_material(mat: Material) -> void:
	for mesh in all_meshes:
		mesh.material_override = mat
