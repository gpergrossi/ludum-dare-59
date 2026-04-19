@tool
class_name Level extends Node3D

const GRID_SIZE = 1.0

@export var enemy_bindings: Array[EnemyType] = []
@export var wave_bindings: Array[WaveInfo] = []

@export var lanes: Array[Path3D] = []
@export var lane_enemy_spawners: Array[EnemyBase] = []
@export var lane_home_base: Array[HomeBase] = []

@export var tower_bases: Array[TowerBase] = []
