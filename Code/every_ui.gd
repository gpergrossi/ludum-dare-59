class_name EveryUi extends Control

@onready var health_bar: ProgressBar = %HealthBar
@onready var announce_text: Label = %AnnounceText

var health: float
var max_health: float

func _ready() -> void:
	refresh_health()

func set_health(current: float, max: float) -> void:
	health = current
	max_health = max
	refresh_health()

func refresh_health() -> void:
	if not is_node_ready(): return
	health_bar.max_value = max_health
	health_bar.value = health

func lose_screen() -> void:
	if not is_node_ready(): return
	announce_text.text = """you lose :(((
		
		thank you for trying anyways.
		please refresh the page to try again.
	"""
	announce_text.show()
	announce_text.modulate.a = 0.0
	create_tween().tween_property(announce_text, "modulate:a", 1.0, 0.5)
