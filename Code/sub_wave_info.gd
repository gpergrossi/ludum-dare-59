class_name SubWaveInfo extends Resource

@export var lane: int

@export var delay_duration: float   ## Time until this wave starts
@export var spawn_duration: float   ## Time this wave spends spawning all enemies evenly spaces
@export var kill_duration: float    ## Time this wave expects to wait before next wave set

## Unit type maps to Vector2i(count, lane_number)
@export var spawn_counts: Dictionary[EnemyType.Enum, Vector2i] = {}
