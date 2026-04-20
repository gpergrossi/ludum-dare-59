class_name WireboxRayInteractor extends Node3D

const MAX_DISTANCE := 5.0
const MAX_DISTANCE_FUDGE := 1.0

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

var _sources: Array[TowerSource] = []
var _towers: Array[Tower] = []
var _connections: ConnectionGraphManager
var _wires : Array[Wire] = []

func _ready() -> void:
	hover.connect(_hover)
	_connections = ConnectionGraphManager.new()

func reset() -> void:
	_current_wirebox = null
	_current_plug = null
	_hit_position = Vector3.ZERO
	_drag_active= false
	_drag_wirebox = null
	_drag_wirebox_slot = -1
	_drag_basis = Basis.IDENTITY	
	
	_sources.clear()
	_towers.clear()
	_connections = ConnectionGraphManager.new()
	for wire in _wires:
		if is_instance_valid(wire):
			wire.queue_free()
	_wires.clear()

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
		_handle_no_hit(_hit_position)
		return

	var collider: Object = result["collider"]
	_hit_position = result["position"]

	var wirebox := _get_wirebox_from_collider(collider)
	var plug = _get_plug_from_collider(collider)

	if _current_plug != plug:
		if _current_plug != null:
			_current_plug.selected = false
		_current_plug = plug
		if plug != null:
			plug.selected = true

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
						_drag_begin(_current_wirebox, _hit_position)
					else:
						_drag_end(_current_wirebox, _hit_position)
				elif not _drag_active and _current_plug != null and _current_plug.wire != wire:
					var this_end := _current_plug
					var this_box := _current_plug.wirebox
					var other_end := _current_plug.wire.get_other_plug(_current_plug)
					var other_box := other_end.wirebox
					_connections.disconnect_items(this_box, other_box)
					update_tower_sources()
					_current_plug.wire.disconnect_plugs()
					_current_plug.wire.queue_free()
					_current_plug = null
					if other_end != null and other_box != null:
						_drag_active = true
						_handle_wirebox_hit(other_box, _hit_position)
						_drag_begin(other_box, _hit_position)
						_handle_wirebox_hit(this_box, _hit_position)
			elif (mbe.button_mask & MOUSE_BUTTON_MASK_RIGHT) != 0:
				if _drag_active:
					_drag_end(null, _hit_position)


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


func _handle_no_hit(hit_position: Vector3) -> void:
	if _current_wirebox != null:
		_current_wirebox.hovered = false
		wirebox_exit.emit(_current_wirebox)
		_current_wirebox = null
	
	if _drag_active:
		# Per-frame hover update
		hover.emit(hit_position)
	

func _drag_begin(wirebox: Wirebox, hit_position: Vector3) -> void:
	_drag_active = true
	
	_drag_wirebox = _current_wirebox
	_drag_wirebox_slot = _drag_wirebox.find_empty_slot()
	_drag_wirebox.selected = true
	wire.visible = true
	
	_drag_wirebox.claim_slot(_drag_wirebox_slot, wire.plug_a)
	_drag_basis = Basis.IDENTITY
	wire.plug_a.transform = _drag_wirebox.get_slot_transform(_drag_wirebox_slot)
	
	drag_begin.emit(wirebox, hit_position)


func _drag_end(wirebox: Wirebox, hit_position: Vector3) -> void:
	if wirebox == null:
		_drag_wirebox.selected = false
		_drag_wirebox.release_slot(_drag_wirebox_slot, wire.plug_a)
		_drag_wirebox = null
		_drag_wirebox_slot = -1
		wire.disconnect_plugs()
		wire.visible = false
		_drag_active = false
		return
	
	var slot := wirebox.find_empty_slot()
	
	# Add a new connection
	var old_plug_b_xform := wire.plug_b.transform 
	
	wirebox.claim_slot(slot, wire.plug_b)
	wire.plug_b.transform = wirebox.get_slot_transform(slot)
	var box_a := wire.plug_a.wirebox
	var box_b := wire.plug_b.wirebox
	_ensure_tracking(box_a)
	_ensure_tracking(box_b)
	
	var self_connected := (box_a == box_b or _connections.is_connected_including_indirectly(box_a, box_b))
	var too_far_away := wire.plug_a.global_position.distance_to(wire.plug_b.global_position) > (MAX_DISTANCE + MAX_DISTANCE_FUDGE)
	
	if self_connected or too_far_away:
		# Cancel this drag_end
		wirebox.release_slot(slot, wire.plug_b)
		wire.plug_b.transform = old_plug_b_xform
		return
	else:
		_connections.connect_items(box_a, box_b)
		var connected_sources : Array[TowerSource] = []
		for source in _sources:
			if _connections.is_connected_including_indirectly(source.wirebox, box_a) or \
				_connections.is_connected_including_indirectly(source.wirebox, box_b):
					connected_sources.append(source)
					print("New wire connected to source " + str(source))
		if connected_sources.size() > 1:
			print("Too many connect sources!")
			wirebox.release_slot(slot, wire.plug_b)
			wire.plug_b.transform = old_plug_b_xform
			_connections.disconnect_items(box_a, box_b)
			return
	
	var new_wire := WIRE.instantiate() as Wire
	self.add_child(new_wire)
	_wires.push_back(new_wire)
	new_wire._replace_existing_connections(wire)
	wire.disconnect_plugs()
	
	update_tower_sources()
	
	_drag_active = false
	drag_end.emit(wirebox, hit_position)


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
		
		if _current_wirebox != null and _current_wirebox.find_empty_slot() != -1:
			var xform := _current_wirebox.get_slot_transform(_current_wirebox.find_empty_slot())
			var socket_position := xform.origin + xform.basis.y * 0.1
			if (wire.plug_a.position.distance_to(socket_position) < MAX_DISTANCE + MAX_DISTANCE_FUDGE):
				wire.plug_b.position = socket_position
				wire.plug_b.basis = xform.basis
				return
		
		wire.plug_b.position = hit_position + Vector3.UP * 0.75
		
		var a := wire.plug_a.position
		var b := wire.plug_b.position
		if (a.distance_to(b) > MAX_DISTANCE):
			var dir_ab := (b - a).normalized()
			wire.plug_b.position = a + dir_ab * MAX_DISTANCE
			_drag_basis = Basis.looking_at(dir_ab, Vector3.UP)
			_drag_basis = _drag_basis.rotated(_drag_basis.x, 0.5 * PI)
		
		wire.plug_b.basis = _drag_basis


func update_tower_sources() -> void:
	var source_assignments: Dictionary[Tower, TowerSource] = {}
	for tower in _towers:
		tower.tower_source = null
		for source in _sources:
			if _connections.is_connected_including_indirectly(tower.wirebox, source.wirebox):
				assert(not source_assignments.has(tower))
				source_assignments[tower] = source
	
	for tower in _towers:
		if not source_assignments.has(tower): continue
		var source := source_assignments[tower]
		if tower.tower_source != source:
			tower.tower_source = source


func _ensure_tracking(box: Wirebox) -> void:
	if box.wirebox_owner is TowerSource:
		var source := box.wirebox_owner as TowerSource
		if not _sources.has(source):
			print("Identified new source " + str(source))
			_sources.append(source)
	if box.wirebox_owner is Tower:
		var tower := box.wirebox_owner as Tower
		if not _towers.has(tower):
			print("Identified new tower " + str(tower))
			_towers.append(tower)
	if not _connections.has_item(box):
		_connections.add_item(box)
