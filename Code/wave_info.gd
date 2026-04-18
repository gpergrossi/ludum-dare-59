class_name WaveInfo extends Resource

@export var lanes: PackedInt32Array = []
@export var hint_text: String   ## E.g. Drums, Bass, Solo

## Unit name and count
@export var spawn_counts: Dictionary[EnemyType.Enum, int] = {}

@export var spawn_duration: float
@export var expected_kill_duration: float
