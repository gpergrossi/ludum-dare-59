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
@export var damage := 10.0 # Probably needs editing per-tower, and depending on pitch/enemy type, etc.

@export var tower_animation_find_keys : Array[String] = []
var _tower_animation_player : AnimationPlayer
@export var tower_idle_animation : StringName
@export var tower_attack_animation : StringName

var tower_source: TowerSource = null

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
	
	# Find animation player. This is messy, but it's to pull something from
	# a subscene.
	if tower_animation_find_keys != null and not tower_animation_find_keys.is_empty():
		var next_look : Node = self
		for n in tower_animation_find_keys:
			next_look = next_look.find_child(n)
		_tower_animation_player = next_look
	
	if not tower_idle_animation.is_empty():
		_tower_animation_player.play(tower_idle_animation)

func _fire(_note : Note) -> void:
	if Engine.is_editor_hint(): return
	if not tower_attack_animation.is_empty():
		_tower_animation_player.play(tower_attack_animation)
	if not tower_idle_animation.is_empty():
		_tower_animation_player.queue(tower_idle_animation)
	
	var enemy := _closest_in_range_enemy()
	if enemy == null:
		instrument.stop()
		return
	laser_beam.fire(laser_emit_position.global_position, enemy.hit_target_position.global_position)
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
	
