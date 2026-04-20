@tool
class_name Tower extends Tile

@onready var min_range_indicator: RangeIndicator = %MinRangeIndicator
@onready var max_range_indicator: RangeIndicator = %MaxRangeIndicator
@onready var laser_beam := %LaserBeam
@onready var laser_emit_position := %LaserEmitPosition
@onready var instrument := %Instrument
@onready var wirebox := %Wirebox
@onready var deactivated_tower: Node3D = %DeactivatedTower
@onready var active_tower_red: Node3D = %ActiveTower_RED
@onready var active_tower_blue: Node3D = %ActiveTower_BLUE
@onready var active_tower_yellow: Node3D = %ActiveTower_YELLOW

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

@export var tower_animation_player : AnimationPlayer
@export var tower_idle_animation : StringName
@export var tower_attack_animation : StringName

var tower_source: TowerSource = null:
	set(s):
		if tower_source != s:
			tower_source = s
			update_color()
			

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
	update_color()
	tower_animation_player = find_child("Yellow_tower_01").find_child("AnimationPlayer")
	if not tower_idle_animation.is_empty():
		tower_animation_player.play(tower_idle_animation)

func update_color() -> void:
	deactivated_tower.visible = (tower_source == null)
	active_tower_red.visible = (tower_source != null and tower_source.color == TowerSource.SourceColor.RED)
	active_tower_blue.visible = (tower_source != null and tower_source.color == TowerSource.SourceColor.BLUE)
	active_tower_yellow.visible = (tower_source != null and tower_source.color == TowerSource.SourceColor.YELLOW)

func _fire(_note : Note) -> void:
	if Engine.is_editor_hint(): return
	if not tower_attack_animation.is_empty():
		tower_animation_player.play(tower_attack_animation)
	if not tower_idle_animation.is_empty():
		tower_animation_player.queue(tower_idle_animation)
	
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
	
