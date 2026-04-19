class_name CameraController
extends Camera3D

# --- CONFIG ---
@export var edge_margin_ratio: float = 0.04

@export var pan_min_speed: float = 10.0
@export var pan_max_speed: float = 20.0
@export var pan_accel_delay: float = 1.0
@export var pan_accel_time: float = 0.1

@export var rotation_speed: float = 1.5
@export var mouse_sensitivity: float = 0.005

@export var zoom_distance: float = 7.0
@export var min_zoom_distance_mult := 1.0
@export var max_zoom_distance_mult := 3.0
@export var zoom_ticks := 5

@export var pitch_center_deg: float = -50.0
@export var pitch_adjust_range: float = 0.0


# --- STATE ---
var origin: Vector3 = Vector3.ZERO

var yaw: float = 0.0
var pitch: float
var zoom_tick := 0
var zoom_dist_mult := 1.0

# Unified input signals
var pan_horizontal: int = 0  # -1, 0, 1
var pan_vertical: int = 0    # -1, 0, 1

# Timing per axis
var pan_time: float = 0.0

var rotating_with_mouse: bool = false

# -------------------------
func _ready() -> void:
	pitch = deg_to_rad(pitch_center_deg)

func _process(delta: float) -> void:
	_handle_mouse_modes()

	_update_pan_input()
	_update_pan_timers(delta)
	_apply_pan(delta)

	_handle_zoom(delta)
	_handle_rotation(delta)
	_update_camera_transform()
	

# -------------------------
# INPUT UNIFICATION
# -------------------------
func _update_pan_input() -> void:
	var h := 0
	var v := 0

	# --- KEYBOARD ---
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("ui_left"):
		h -= 1
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("ui_right"):
		h += 1

	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("ui_up"):
		v += 1
	if Input.is_action_pressed("move_back") or Input.is_action_pressed("ui_down"):
		v -= 1

	# --- EDGE SCROLL ---
	var mouse_pos := get_viewport().get_mouse_position()
	var visible_rect := get_viewport().get_visible_rect()
	var screen_size := visible_rect.size
	
	var in_view := visible_rect.has_point(mouse_pos)
	if in_view:
		var margin_x := screen_size.x * edge_margin_ratio
		var margin_y := screen_size.y * edge_margin_ratio

		if mouse_pos.x < margin_x:
			h -= 1
		elif mouse_pos.x > screen_size.x - margin_x:
			h += 1

		if mouse_pos.y < margin_y:
			v += 1
		elif mouse_pos.y > screen_size.y - margin_y:
			v -= 1

	# Clamp to -1..1 (important when combining inputs)
	pan_horizontal = clamp(h, -1, 1)
	pan_vertical = clamp(v, -1, 1)

# -------------------------
# TIMING MODEL
# -------------------------
func _update_pan_timers(delta: float) -> void:
	if pan_horizontal != 0 or pan_vertical != 0:
		pan_time += delta
	else:
		pan_time = 0.0

func _compute_axis_speed(time: float) -> float:
	if time < pan_accel_delay:
		return pan_min_speed

	var t := (time - pan_accel_delay) / pan_accel_time
	t = clamp(t, 0.0, 1.0)

	return lerp(pan_min_speed, pan_max_speed, t)

# -------------------------
# APPLY MOVEMENT
# -------------------------
func _apply_pan(delta: float) -> void:
	if pan_horizontal == 0 and pan_vertical == 0:
		return

	var pan := Vector2(pan_horizontal, pan_vertical).normalized()

	var speed_x := _compute_axis_speed(pan_time) * pan.x
	var speed_y := _compute_axis_speed(pan_time) * pan.y

	var forward := Vector3.FORWARD.rotated(Vector3.UP, yaw)
	var right := Vector3.RIGHT.rotated(Vector3.UP, yaw)

	var move := (right * speed_x + forward * speed_y) * delta
	origin += move

# -------------------------
# ROTATION (IJKL + MOUSE)
# -------------------------
func _handle_rotation(delta: float) -> void:
	var yaw_input := 0.0
	var pitch_input := 0.0

	if Input.is_action_pressed("pan_left"):
		yaw_input += 1.0
	if Input.is_action_pressed("pan_right"):
		yaw_input -= 1.0

	if Input.is_action_pressed("pan_up"):
		pitch_input += 1.0
	if Input.is_action_pressed("pan_down"):
		pitch_input -= 1.0

	yaw += yaw_input * rotation_speed * delta
	pitch += pitch_input * rotation_speed * delta

	_clamp_pitch()

func _input(event: InputEvent) -> void:
	if rotating_with_mouse and event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		_clamp_pitch()

# -------------------------
# MOUSE MODES
# -------------------------
func _handle_mouse_modes() -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		rotating_with_mouse = false

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		rotating_with_mouse = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		rotating_with_mouse = false

# -------------------------
# CAMERA ZOOM
# -------------------------
func _handle_zoom(_delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		zoom_tick = maxi(0, zoom_tick-1)
	if Input.is_action_just_pressed("zoom_out"):
		zoom_tick = mini(zoom_ticks-1, zoom_tick+1)
	
	var target_dist_mult = lerpf(min_zoom_distance_mult, max_zoom_distance_mult, float(zoom_tick)/float(zoom_ticks-1.0))
	zoom_dist_mult = lerp(zoom_dist_mult, target_dist_mult, 0.05)

# -------------------------
# CAMERA ORBIT
# -------------------------
func _update_camera_transform() -> void:
	var orbit_x := cos(-pitch) * zoom_distance * zoom_dist_mult
	var orbit_y := sin(-pitch) * zoom_distance * zoom_dist_mult
	
	var offset := Vector3(sin(yaw) * orbit_x, orbit_y, cos(yaw) * orbit_x)

	global_position = origin + offset
	look_at(origin, Vector3.UP)
	rotation.x = pitch

# -------------------------
# HELPERS
# -------------------------
func _clamp_pitch() -> void:
	var center := deg_to_rad(pitch_center_deg)
	var min_pitch := center - deg_to_rad(pitch_adjust_range)
	var max_pitch := center + deg_to_rad(pitch_adjust_range)

	pitch = clamp(pitch, min_pitch, max_pitch)
