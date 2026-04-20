@tool
class_name Level extends Node3D

const GRID_SIZE = 1.0

@export var lanes: Array[Lane] = []

@export var max_health : float = 100.0
@export var current_health : float

@export var ui: EveryUi
@export var wirebox : WireboxRayInteractor

@onready var _song_generators := %SongGenerators

var _song_queue : Array[Song] = []

enum LevelState {
	PLAYING,
	BETWEEN_SONGS,
	LOST
}

var _level_state := LevelState.PLAYING

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	if _song_queue.is_empty():
		_song_queue = []
		for generator : SongGenerator in _song_generators.get_children():
			_song_queue.push_back(generator.makeSong())
			
	Pianola.INSTANCE.song = _song_queue.front()
	Pianola.INSTANCE.song_finished.connect(_on_song_finished)
	
	current_health = max_health
	ui.set_health(current_health, max_health)

	for lane in lanes:
		lane.on_enemy_spawned.connect(_enemy_spawned)

func _enemy_spawned(enemy : Enemy):
	enemy.on_reach_end.connect(func():
		_take_damage(enemy.damage))

func _take_damage(amount : float):
		current_health -= amount
		ui.set_health(current_health, max_health)
		
		if current_health < 0 && _level_state == LevelState.PLAYING:
			_level_state = LevelState.LOST
			Pianola.INSTANCE.song = null
			await ui.show_popover_screen("""you lose :(((((
				
				thank you for trying anyways.""", "restart current level")
			_reset()

func _on_song_finished(song : Song):
	if _level_state != LevelState.PLAYING:
		return
		
	_level_state = LevelState.BETWEEN_SONGS
	_song_queue.pop_front()
	
	await get_tree().create_timer(2.0).timeout

	if _song_queue.is_empty():
		await ui.show_popover_screen("""congratulations - you won!
		
		thank you for playing!
		""", "now hit repeat")
		_reset()
		return
	
	Pianola.INSTANCE.song = _song_queue.front()
	current_health = max_health
	ui.set_health(current_health, max_health)
	_level_state = LevelState.PLAYING
	# TODO store any unlocks

func _reset():
	wirebox.reset()

	var replacement : Level = load(scene_file_path).instantiate()
	
	replacement.max_health = current_health
	replacement.ui = ui
	replacement.wirebox = wirebox
	
	# TODO: set unlocked stuff.
	replacement._song_queue = _song_queue
	
	get_parent_node_3d().add_child(replacement)
	queue_free()
	
