@tool
class_name Level extends Node3D

@export_tool_button("Scan") var scan: Callable = on_click_scan

const GRID_SIZE = 1.0

@export var enemies: Array[EnemyType] = []
@export var wave_info: Array[WaveInfo] = []

@export var lanes: Array[Path3D] = []
@export var lane_enemy_spawners: Array[Tile] = []
@export var enemy_spawners: Array[Tile] = []


func on_click_scan() -> void:
	for child in get_children():
		if child is Tile:
			var tile := child as Tile
			
