@tool
class_name Tower extends Tile

@onready var min_range_indicator: RangeIndicator = %MinRangeIndicator
@onready var max_range_indicator: RangeIndicator = %MaxRangeIndicator
@onready var laser_beam := %LaserBeam
@onready var laser_emit_position := %LaserEmitPosition
@onready var instrument := %Instrument

@export var min_range := 0.0:
	set(mr):
		if min_range != mr:
			min_range = mr
			max_range = maxf(max_range, min_range)
			refresh_range()

@export var max_range := 2.5:
	set(mr):
		if max_range != mr:
			max_range = mr
			min_range = minf(min_range, max_range)
			refresh_range()

# Damage dealt per tower firing.
@export var damage := 1.0

func refresh_range() -> void:
	if not is_node_ready(): return
	min_range_indicator.visible = (min_range > 0.0)
	min_range_indicator.range = min_range
	max_range_indicator.visible = (max_range > 0.0)
	max_range_indicator.range = max_range


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_range()
	if not Engine.is_editor_hint():
		instrument.on_play_note.connect(_fire)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _fire(note : Note) -> void:
	if Engine.is_editor_hint(): return
	var enemy := _closest_in_range_enemy()
	if enemy == null:
		instrument.stop()
		return
	laser_beam.fire(laser_emit_position.global_position, enemy.global_position)
	enemy.take_damage(damage)
	
func _closest_in_range_enemy() -> Enemy:
	var closest_enemy : Enemy = null
	var closest_enemy_distance_sqr := INF  # give me FLOAT_MAX please gdscript
	# TODO O(n*m) - potential performance issue for lots of enemies.
	for enemy : Enemy in get_tree().get_nodes_in_group(&"Enemies"):  
		var distance_sqr = enemy.global_position.distance_squared_to(global_position)
		if distance_sqr < min_range * min_range or max_range * max_range < distance_sqr:
			continue
		if distance_sqr < closest_enemy_distance_sqr:
			closest_enemy = enemy
			closest_enemy_distance_sqr = distance_sqr
	return closest_enemy
	
