@tool
class_name Tower extends Tile

@onready var min_range_indicator: RangeIndicator = %MinRangeIndicator
@onready var max_range_indicator: RangeIndicator = %MaxRangeIndicator

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

func refresh_range() -> void:
	if not is_node_ready(): return
	min_range_indicator.visible = (min_range > 0.0)
	min_range_indicator.range = min_range
	max_range_indicator.visible = (max_range > 0.0)
	max_range_indicator.range = max_range


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_range()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
