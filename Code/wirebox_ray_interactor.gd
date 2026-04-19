class_name WireboxRayInteractor extends Node3D

signal wirebox_enter(wirebox: Wirebox)
signal wirebox_exit(wirebox: Wirebox)
signal hover(hit_position: Vector3)
signal drag_begin(wirebox: Wirebox, hit_position: Vector3)
signal drag_end(wirebox: Wirebox, hit_position: Vector3)

@export var ray_length: float = 100.0
@export var collision_mask: int = -1

var _current_wirebox: Wirebox = null
var _hit_position: Vector3
var _drag_active := false
var _drag_wirebox_begin: Wirebox = null

func _ready() -> void:
	drag_begin.connect(_drag_begin)
	drag_end.connect(_drag_end)

func _physics_process(_delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return

	var mouse_pos := get_viewport().get_mouse_position()

	var from: Vector3 = camera.project_ray_origin(mouse_pos)
	var dir: Vector3 = camera.project_ray_normal(mouse_pos)
	var to: Vector3 = from + dir * ray_length
	
	var space_state := get_world_3d().direct_space_state

	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = collision_mask
	query.exclude = [self]

	var result := space_state.intersect_ray(query)

	if result.is_empty():
		_hit_position = Vector3.INF
		_handle_no_hit()
		return

	var collider: Object = result["collider"]
	_hit_position = result["position"]

	var wirebox := _get_wirebox_from_collider(collider)

	if wirebox == null:
		_handle_no_hit(_hit_position)
		return

	_handle_wirebox_hit(wirebox, _hit_position)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mbe := event as InputEventMouseButton
		if mbe.pressed:
			if (mbe.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
				if not _drag_active:
					if _current_wirebox != null:
						_drag_active = true
						drag_begin.emit(_current_wirebox, _hit_position)
						_drag_wirebox_begin = _current_wirebox
						_drag_wirebox_begin.selected = true
				else:
					if _current_wirebox != null:
						_drag_active = false
						drag_end.emit(_current_wirebox, _hit_position)
						_drag_wirebox_begin.selected = false
			elif (mbe.button_mask & MOUSE_BUTTON_MASK_RIGHT) != 0:
				if _drag_active:
					_drag_active = false
					drag_end.emit(null, _hit_position)
					_drag_wirebox_begin.selected = false


func _get_wirebox_from_collider(collider: Object) -> Wirebox:
	if collider == null:
		return null

	if collider is Node:
		var node := collider as Node

		# If collider itself is Wirebox
		if node is Wirebox:
			return node as Wirebox

		# If parent is Wirebox
		if node.get_parent() is Wirebox:
			return node.get_parent() as Wirebox

	return null


func _handle_wirebox_hit(wirebox: Wirebox, hit_position: Vector3) -> void:
	# Enter event
	if wirebox != _current_wirebox:
		if _current_wirebox != null:
			wirebox_exit.emit(_current_wirebox)

		_current_wirebox = wirebox
		_current_wirebox.hovered = true
		wirebox_enter.emit(wirebox)

	# Per-frame hover update
	hover.emit(hit_position)


func _handle_no_hit(hit_position: Vector3 = Vector3.INF) -> void:
	if _current_wirebox != null:
		_current_wirebox.hovered = false
		wirebox_exit.emit(_current_wirebox)
		_current_wirebox = null
	
	if _drag_active:
		# Per-frame hover update
		hover.emit(hit_position)

func _drag_begin(wirebox: Wirebox, hit_position: Vector3) -> void:
	print("Begin drag at " + str(wirebox) + " " + str(hit_position))

func _drag_end(wirebox: Wirebox, hit_position: Vector3) -> void:
	print("End drag at " + str(wirebox) + " " + str(hit_position))
