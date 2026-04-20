class_name WireboxRayInteractor extends Node3D

signal wirebox_enter(wirebox: Wirebox)
signal wirebox_exit(wirebox: Wirebox)
signal hover(hit_position: Vector3)
signal drag_begin(wirebox: Wirebox, hit_position: Vector3)
signal drag_end(wirebox: Wirebox, hit_position: Vector3)

@export var ray_length: float = 100.0
const collision_mask_all: int = -1
const collision_mask_clickables: int = 16
const collision_mask_plugs: int = 32

@onready var wire: Wire = %Wire

const WIRE = preload("uid://cxryvqj7s6ok1")

var _current_wirebox: Wirebox = null
var _current_plug: Plug = null
var _hit_position: Vector3
var _drag_active := false
var _drag_wirebox: Wirebox = null
var _drag_wirebox_slot: int = -1
var _drag_basis := Basis.IDENTITY

func _ready() -> void:
	drag_begin.connect(_drag_begin)
	drag_end.connect(_drag_end)
	hover.connect(_hover)

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
	if _drag_active:
		query.collision_mask = collision_mask_all & (~collision_mask_plugs)
	else:
		query.collision_mask = collision_mask_all
	query.exclude = [self]

	var result := space_state.intersect_ray(query)

	if result.is_empty():
		_hit_position = Vector3.INF
		_handle_no_hit()
		return

	var collider: Object = result["collider"]
	_hit_position = result["position"]

	var wirebox := _get_wirebox_from_collider(collider)
	_current_plug = _get_plug_from_collider(collider)

	if wirebox == null:
		_handle_no_hit(_hit_position)
		return

	_handle_wirebox_hit(wirebox, _hit_position)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mbe := event as InputEventMouseButton
		if mbe.pressed:
			if (mbe.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
				if _current_wirebox != null and _current_wirebox.has_empty_slot():
					if not _drag_active:
						_drag_active = true
						drag_begin.emit(_current_wirebox, _hit_position)
					else:
						_drag_active = false
						drag_end.emit(_current_wirebox, _hit_position)
				elif not _drag_active and _current_plug != null and _current_plug.wire != wire:
					var this_end := _current_plug
					var this_box := _current_plug.wirebox
					var other_end := _current_plug.wire.get_other_plug(_current_plug)
					var other_box := other_end.wirebox
					_current_plug.wire.disconnect_plugs()
					_current_plug.wire.queue_free()
					_current_plug = null
					if other_end != null and other_box != null:
						_drag_active = true
						_handle_wirebox_hit(other_box, _hit_position)
						drag_begin.emit(other_box, _hit_position)
						_handle_wirebox_hit(this_box, _hit_position)
						print("started new drag")
					else:
						print("no other end")
			elif (mbe.button_mask & MOUSE_BUTTON_MASK_RIGHT) != 0:
				if _drag_active:
					_drag_active = false
					drag_end.emit(null, _hit_position)


func _get_wirebox_from_collider(collider: Object) -> Wirebox:
	if collider == null: return null
	if collider is Node:
		var node := collider as Node

		# If collider itself is Wirebox
		if node is Wirebox:
			return node as Wirebox

		# If parent is Wirebox
		if node.get_parent() is Wirebox:
			return node.get_parent() as Wirebox

	return null


func _get_plug_from_collider(collider: Object) -> Plug:
	if collider == null: return null
	if collider is Node:
		var node := collider as Node

		# If collider itself is Wirebox
		if node is Wirebox:
			return node as Plug

		# If parent is Wirebox
		if node.get_parent() is Plug:
			return node.get_parent() as Plug

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
	_drag_wirebox = _current_wirebox
	_drag_wirebox_slot = _drag_wirebox.find_empty_slot()
	_drag_wirebox.selected = true
	wire.visible = true
	
	_drag_wirebox.claim_slot(_drag_wirebox_slot, wire.plug_a)
	_drag_basis = Basis.IDENTITY
	wire.plug_a.transform = _drag_wirebox.get_slot_transform(_drag_wirebox_slot)


func _drag_end(wirebox: Wirebox, hit_position: Vector3) -> void:
	print("End drag at " + str(wirebox) + " " + str(hit_position))
	_drag_wirebox.selected = false
	wire.visible = false
	
	if wirebox == null:
		_drag_wirebox.release_slot(_drag_wirebox_slot, wire.plug_a)
		_drag_wirebox = null
		_drag_wirebox_slot = -1
	else:
		var slot := wirebox.find_empty_slot()
		wirebox.claim_slot(slot, wire.plug_b)
		
		wire.plug_b.transform = wirebox.get_slot_transform(slot)
		
		var new_wire := WIRE.instantiate() as Wire
		self.add_child(new_wire)
		new_wire._replace_existing_connections(wire)
		
		wire.disconnect_plugs()


func _hover(hit_position: Vector3) -> void:
	if _drag_active:
		var pull := (hit_position - wire.plug_b.position)
		var up := Vector3(-pull); up.y = 1.0; up = up.normalized()
		
		var axis := Vector3.UP.cross(up)
		if axis.length() > 0:
			axis = axis.normalized()
			var angle := Vector3.UP.signed_angle_to(up, axis)
			_drag_basis = Basis(Quaternion(axis, angle)) * _drag_basis
			
			var axis2 :=  _drag_basis.y.cross(Vector3.UP)
			if axis2.length() > 0:
				axis2 = axis2.normalized()
				var angle2 := _drag_basis.y.signed_angle_to(Vector3.UP, axis2)
				angle2 -= PI * 0.5
				if angle2 > 0:
					_drag_basis = Basis(Quaternion(axis2, angle2)) * _drag_basis
		
		if _drag_basis.y.angle_to(Vector3.UP) > PI * 0.25:
			_drag_basis = _drag_basis.slerp(Quaternion.IDENTITY, 0.01)
		
		if _current_wirebox == null or _current_wirebox.find_empty_slot() == -1:
			wire.plug_b.position = hit_position + Vector3.UP * 0.75
			wire.plug_b.basis = _drag_basis
		else:
			var xform := _current_wirebox.get_slot_transform(_current_wirebox.find_empty_slot())
			wire.plug_b.position = xform.origin + xform.basis.y * 0.1
			wire.plug_b.basis = xform.basis
