@tool
class_name Tower extends Tile

@onready var min_range_indicator: RangeIndicator = %MinRangeIndicator
@onready var max_range_indicator: RangeIndicator = %MaxRangeIndicator
@onready var laser_beam := %LaserBeam
@onready var laser_emit_position := %LaserEmitPosition
@onready var instrument := %Instrument
@onready var wirebox := %Wirebox

@onready var deactivated_tower: Node3D = %DeactivatedTower
@onready var active_tower_red: TowerTopper = %ActiveTower_RED
@onready var active_tower_blue: TowerTopper = %ActiveTower_BLUE
@onready var active_tower_yellow: TowerTopper = %ActiveTower_YELLOW

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

var tower_source: TowerSource = null:
	set(s):
		if tower_source != s:
			tower_source = s
			update_color()
			update_instrument()

var current_topper: TowerTopper = null
var current_part: Part = null
var current_song: Song = null

func refresh_range() -> void:
	if not is_node_ready(): return
	min_range_indicator.visible = (min_range > 0.0)
	min_range_indicator.range = min_range
	max_range_indicator.visible = (max_range > 0.0)
	max_range_indicator.range = max_range


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	refresh_range()
	if not Engine.is_editor_hint():
		instrument.on_play_note.connect(_fire)
	update_color()
	level.song_changed.connect(on_song_changed)
	update_instrument()


func on_song_changed(song: Song) -> void:
	current_song = song
	update_instrument()


func update_color() -> void:
	if current_topper != null: current_topper.pause()
	if tower_source == null:
		current_topper = null
		deactivated_tower.visible = true
		active_tower_red.visible = false
		active_tower_blue.visible = false
		active_tower_yellow.visible = false
	else:
		match tower_source.color:
			TowerSource.SourceColor.RED:
				current_topper = active_tower_red
				deactivated_tower.visible = false
				active_tower_red.visible = true
				active_tower_blue.visible = false
				active_tower_yellow.visible = false
			TowerSource.SourceColor.BLUE:
				current_topper = active_tower_blue
				deactivated_tower.visible = false
				active_tower_red.visible = false
				active_tower_blue.visible = true
				active_tower_yellow.visible = false
			TowerSource.SourceColor.YELLOW:
				current_topper = active_tower_blue
				deactivated_tower.visible = false
				active_tower_red.visible = false
				active_tower_blue.visible = false
				active_tower_yellow.visible = true
	if current_topper != null: current_topper.resume()


func update_instrument() -> void:
	if tower_source == null:
		instrument.part = null
	else:
		match tower_source.color:
			TowerSource.SourceColor.RED: instrument.part = current_song.red_parts[0]
			TowerSource.SourceColor.BLUE: instrument.part = current_song.blue_parts[0]
			TowerSource.SourceColor.YELLOW: instrument.part = current_song.yellow_parts[0]


func _fire(_note : Note) -> void:
	if Engine.is_editor_hint(): return
	current_topper.attack()
	
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
	
