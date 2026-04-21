class_name EveryUi extends Control

@onready var health_bar: ProgressBar = %HealthBar
@onready var loss_text: Label = %LossText
@onready var restart_button : Button = %RestartButton
@onready var wire_earn_progress: ProgressBar = %WireEarnProgress
@onready var wire_earn_label: Label = %WireEarnLabel
@onready var wire_use_label: Label = %WireUseLabel


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
	
func show_popover_screen(label_text : String, button_text : String) -> void:
	if not is_node_ready(): return
	
	loss_text.text = label_text
	loss_text.show()
	loss_text.modulate.a = 0.0
	restart_button.text = button_text
	restart_button.show()
	restart_button.modulate.a = 0.0
	var show_tween = create_tween()
	show_tween.tween_property(loss_text, "modulate:a", 1.0, 0.5)
	show_tween.tween_property(restart_button, "modulate:a", 1.0, 0.5)
	
	await restart_button.pressed
	
	var hide_tween = create_tween()
	hide_tween.tween_property(loss_text, "modulate:a", 0.0, 0.5)
	hide_tween.tween_property(restart_button, "modulate:a", 0.0, 0.5)
	hide_tween.tween_callback(func ():
		loss_text.hide()
		restart_button.hide())

func set_wire_earn(current: int, max: int) -> void:
	if not is_node_ready(): return
	wire_earn_progress.max_value = max
	wire_earn_progress.value = current
	wire_earn_label.text = str(current) + " / " + str(max)
	
func set_wires_used(used: int, max: int) -> void:
	if not is_node_ready(): return
	wire_use_label.text = "Wires Used:    " + str(used) + " / " + str(max)
	
