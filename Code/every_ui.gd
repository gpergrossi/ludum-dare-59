class_name EveryUi extends Control

@onready var health_bar: ProgressBar = %HealthBar
@onready var loss_text: Label = %LossText
@onready var restart_button : Button = %RestartButton

var health: float
var max_health: float

signal restart_pressed()

func _ready() -> void:
	refresh_health()
	restart_button.pressed.connect(func ():
		restart_pressed.emit())

func set_health(current: float, max: float) -> void:
	health = current
	max_health = max
	refresh_health()

func refresh_health() -> void:
	if not is_node_ready(): return
	health_bar.max_value = max_health
	health_bar.value = health

func show_lose_screen() -> void:
	if not is_node_ready(): return

	loss_text.show()
	loss_text.modulate.a = 0.0
	restart_button.show()
	restart_button.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(loss_text, "modulate:a", 1.0, 0.5)
	tween.tween_property(restart_button, "modulate:a", 1.0, 0.5)

func hide_lose_screen():
	if not is_node_ready(): return
	var tween = create_tween()
	tween.tween_property(loss_text, "modulate:a", 0.0, 0.5)
	tween.tween_property(restart_button, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func ():
		loss_text.hide()
		restart_button.hide())

	
