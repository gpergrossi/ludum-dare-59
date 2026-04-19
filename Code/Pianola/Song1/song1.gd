# @author Vivian

extends Node

@onready var kickstrument: Instrument = $Kickstrument;
@onready var hihatstrument: Instrument = $Hihatstrument;
@onready var synthstrument: Instrument = $Synthstrument;

const PARTS: Dictionary[String, Resource] = {
	"kick": preload("res://Code/Pianola/Song1/kicks_resource.tres"),
	"hihat": preload("res://Code/Pianola/Song1/hihats_resource.tres"),
	"synth": preload("res://Code/Pianola/Song1/synth_resource.tres"),
	"spawners": preload("uid://c25sck87yn44s")
}

const kick: AudioStream = preload("res://Audio/Drums/kick_drum_1.ogg");
const hihat: AudioStream = preload("res://Audio/Drums/hihat_1.ogg");
const s1: AudioStream = preload("res://Audio/Synth0/C2.wav");
const s2: AudioStream = preload("res://Audio/Synth0/D2.wav");
const s3: AudioStream = preload("res://Audio/Synth0/E2.wav");
const s4: AudioStream = preload("res://Audio/Synth0/F2.wav");
const s5: AudioStream = preload("res://Audio/Synth0/G2.wav");
const s6: AudioStream = preload("res://Audio/Synth0/A2.wav");
const s7: AudioStream = preload("res://Audio/Synth0/B2.wav");
const s8: AudioStream = preload("res://Audio/Synth0/C3.wav");
const s9: AudioStream = preload("res://Audio/Synth0/D3.wav");
const s10: AudioStream = preload("res://Audio/Synth0/E3.wav");
const s11: AudioStream = preload("res://Audio/Synth0/F3.wav");
const s12: AudioStream = preload("res://Audio/Synth0/G3.wav");
const s13: AudioStream = preload("res://Audio/Synth0/A3.wav");
const s14: AudioStream = preload("res://Audio/Synth0/B3.wav");
const s15: AudioStream = preload("res://Audio/Synth0/C4.wav");
const s16: AudioStream = preload("res://Audio/Synth0/D4.wav");
const s17: AudioStream = preload("res://Audio/Synth0/E4.wav");
const s18: AudioStream = preload("res://Audio/Synth0/F4.wav");
const s19: AudioStream = preload("res://Audio/Synth0/G4.wav");
const s20: AudioStream = preload("res://Audio/Synth0/A4.wav");
const s21: AudioStream = preload("res://Audio/Synth0/B4.wav");
const s22: AudioStream = preload("res://Audio/Synth0/C5.wav");
const s23: AudioStream = preload("res://Audio/Synth0/D5.wav");
const s24: AudioStream = preload("res://Audio/Synth0/E5.wav");
const s25: AudioStream = preload("res://Audio/Synth0/F5.wav");
const s26: AudioStream = preload("res://Audio/Synth0/G5.wav");
const s27: AudioStream = preload("res://Audio/Synth0/A5.wav");
const s28: AudioStream = preload("res://Audio/Synth0/B5.wav");
const s29: AudioStream = preload("res://Audio/Synth0/C6.wav");

const spawnBox := EnemyType.Enum.Box
const spawnBall := EnemyType.Enum.Ball
const spawnCone := EnemyType.Enum.Cone

func _ready():
	var song := makeSong1();
	%Pianola.song = song;

func makeSong1() -> Song:
	var song = Song.new();
	addPattern(song, PARTS.kick,  0, 120, [kick, kick, kick, null]);
	addPattern(song, PARTS.kick,  0, 120, [kick, kick, kick, null]);
	addPattern(song, PARTS.hihat, 0, 120, [null, hihat, null, null], 1.0, 0.5);
	addPattern(song, PARTS.synth, 0, 120, [
		s5, s6, s7, null, s6, s5, s4, s3, s2, s2, null,
		s1, null, s3, s7, null, s6, s10, s9, null, null, null,
		
	], 2);
	addPatternSpawns(song, PARTS.spawners, 0, 10, [
		spawnBox
	], 0.125)
	return song;

func addPattern(song: Song, part: Part, startBeat: int, endBeat: int, pattern: Array[AudioStream], rate: float = 1, offset: float = 0):
	var length := (endBeat - startBeat) * rate;
	for beat in range(0, length):
		var position := beat % pattern.size();
		var audio = pattern[position];
		if (audio == null): continue;
		var note := makeNote(beat/rate + offset, part, audio, EnemyType.Enum.None);
		song.notes.push_back(note);

func addPatternSpawns(song: Song, part: Part, startBeat: int, endBeat: int, pattern: Array[EnemyType.Enum], rate: float = 1, offset: float = 0):
	var length := (endBeat - startBeat) * rate;
	for beat in range(0, length):
		var position := beat % pattern.size();
		var enemy_type: EnemyType.Enum = pattern[position];
		if (enemy_type == EnemyType.Enum.None): continue;
		var note := makeNote(beat/rate + offset, part, null, enemy_type);
		song.notes.push_back(note);

func makeNote(beat: float, part: Part, audio: AudioStream, enemy: EnemyType.Enum) -> Note:
	var note := Note.new();
	
	note.beat = beat;
	note.part = part;
	note.audio_stream = audio;
	note.spawn_enemy = enemy;
	
	return note;
