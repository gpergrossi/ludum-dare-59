class_name Plug extends Node3D

@export var wire: Wire
@export var wirebox: Wirebox
@onready var selection: Node3D = %Selection

var selected: bool:
	set(s):
		selected = s
		if is_node_ready():
			selection.visible = selected

func _replace_existing_connections(other: Plug) -> void:
	assert(other != null)
	var others_wirebox := other.wirebox
	assert(others_wirebox != null)
	assert(others_wirebox.find_slot(other) != -1)
	
	transform = other.transform
	
	var slot := others_wirebox.find_slot(other)
	others_wirebox.release_slot(slot, other)
	others_wirebox.claim_slot(slot, self)
