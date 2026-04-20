@tool
class_name SongGenerator extends Node

@export_tool_button("Make Song") var btn_make_song: Callable = makeSong

@export var song: Song

func makeSong() -> Song:
	return null
