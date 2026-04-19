class_name Note extends Resource

# The beat on which this note is triggered.
@export var beat : float
# The part to which this note belongs to.
@export var part : Part
# Sound that will be played.
@export var audio_stream : AudioStream
# Enemy which will be spawned.
@export var spawn_enemy : EnemyType.Enum
