class_name SignalOrb extends MeshInstance3D

const RED_PULSE_GLOW: Material = preload("uid://b1aosemp24edf")
const BLUE_PULSE_GLOW: Material = preload("uid://tpqkwgrutkvg")
const YELLOW_PULSE_GLOW: Material = preload("uid://hmryg8aw5w64")


signal signal_finished()

var running := false
var progress := 0.0

var curve: Curve3D
var speed := 1.0
var color: SourceColor.Enum


func begin(curve: Curve3D, color: SourceColor.Enum, speed: float) -> void:
	self.color = color
	self.speed = speed
	self.curve = curve
	
	match (color):
		SourceColor.Enum.RED: material_override = RED_PULSE_GLOW
		SourceColor.Enum.BLUE: material_override = BLUE_PULSE_GLOW
		SourceColor.Enum.YELLOW: material_override = YELLOW_PULSE_GLOW
	
	self.progress = 0.0 if speed > 0 else curve.get_baked_length()
	self.running = true


func _process(delta: float) -> void:
	if not running: return
	
	if speed > 0:
		progress += speed * delta
		var max_progress := curve.get_baked_length()
		if progress >= max_progress:
			progress = max_progress
			signal_finished.emit()
			running = false
			queue_free()
	else:
		progress += speed * delta
		if progress <= 0:
			progress = 0
			signal_finished.emit()
			running = false
			queue_free()
	
	refresh()


func refresh() -> void:
	position = curve.sample_baked(progress)
