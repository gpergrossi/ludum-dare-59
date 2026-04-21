# @author Vivian
# SongLoader loads song data from a .csv file, and creates a corresponding game-logic Song object.

class_name SongLoader extends SongGenerator

const PARTS: Dictionary[String, Resource] = {
	"percussion": preload("res://Code/Pianola/Songs/kicks_resource.tres"),
	"kick": preload("res://Code/Pianola/Songs/kicks_resource.tres"),
	"hihat": preload("res://Code/Pianola/Songs/hihats_resource.tres"),
	"synth": preload("res://Code/Pianola/Songs/synth_resource.tres"),
	"marimba": preload("res://Code/Pianola/Songs/marimba_resource.tres"),
	"spawn1": preload("uid://c25sck87yn44s"),
	"spawn2": preload("uid://tf55e001gar5"),
	"spawn3": preload("uid://ctvecbluw3187"),
};

const SOUNDS_BY_TRACK = {
	"percussion": {
		"startIndex": 0,
		"sounds": [
			preload("res://Audio/Drums/kick_drum_1.ogg"),
			preload("res://Audio/Drums/hihat_1.ogg"),
			preload("res://Audio/Drums/hihat_2.ogg"),
			preload("res://Audio/Drums/hihat_3.ogg"),
			preload("res://Audio/Drums/hihat_4.ogg"),
		],
	},
	"marimba": {
		"startIndex": 24,
		"sounds": [
			preload("res://Audio/Marimba0/note_024_C1.wav"),
			preload("res://Audio/Marimba0/note_025_C#1.wav"),
			preload("res://Audio/Marimba0/note_026_D1.wav"),
			preload("res://Audio/Marimba0/note_027_D#1.wav"),
			preload("res://Audio/Marimba0/note_028_E1.wav"),
			preload("res://Audio/Marimba0/note_029_F1.wav"),
			preload("res://Audio/Marimba0/note_030_F#1.wav"),
			preload("res://Audio/Marimba0/note_031_G1.wav"),
			preload("res://Audio/Marimba0/note_032_G#1.wav"),
			preload("res://Audio/Marimba0/note_033_A1.wav"),
			preload("res://Audio/Marimba0/note_034_A#1.wav"),
			preload("res://Audio/Marimba0/note_035_B1.wav"),
			preload("res://Audio/Marimba0/note_036_C2.wav"),
			preload("res://Audio/Marimba0/note_037_C#2.wav"),
			preload("res://Audio/Marimba0/note_038_D2.wav"),
			preload("res://Audio/Marimba0/note_039_D#2.wav"),
			preload("res://Audio/Marimba0/note_040_E2.wav"),
			preload("res://Audio/Marimba0/note_041_F2.wav"),
			preload("res://Audio/Marimba0/note_042_F#2.wav"),
			preload("res://Audio/Marimba0/note_043_G2.wav"),
			preload("res://Audio/Marimba0/note_044_G#2.wav"),
			preload("res://Audio/Marimba0/note_045_A2.wav"),
			preload("res://Audio/Marimba0/note_046_A#2.wav"),
			preload("res://Audio/Marimba0/note_047_B2.wav"),
			preload("res://Audio/Marimba0/note_048_C3.wav"),
			preload("res://Audio/Marimba0/note_049_C#3.wav"),
			preload("res://Audio/Marimba0/note_050_D3.wav"),
			preload("res://Audio/Marimba0/note_051_D#3.wav"),
			preload("res://Audio/Marimba0/note_052_E3.wav"),
			preload("res://Audio/Marimba0/note_053_F3.wav"),
			preload("res://Audio/Marimba0/note_054_F#3.wav"),
			preload("res://Audio/Marimba0/note_055_G3.wav"),
			preload("res://Audio/Marimba0/note_056_G#3.wav"),
			preload("res://Audio/Marimba0/note_057_A3.wav"),
			preload("res://Audio/Marimba0/note_058_A#3.wav"),
			preload("res://Audio/Marimba0/note_059_B3.wav"),
			preload("res://Audio/Marimba0/note_060_C4.wav"),
			preload("res://Audio/Marimba0/note_061_C#4.wav"),
			preload("res://Audio/Marimba0/note_062_D4.wav"),
			preload("res://Audio/Marimba0/note_063_D#4.wav"),
			preload("res://Audio/Marimba0/note_064_E4.wav"),
			preload("res://Audio/Marimba0/note_065_F4.wav"),
			preload("res://Audio/Marimba0/note_066_F#4.wav"),
			preload("res://Audio/Marimba0/note_067_G4.wav"),
			preload("res://Audio/Marimba0/note_068_G#4.wav"),
			preload("res://Audio/Marimba0/note_069_A4.wav"),
			preload("res://Audio/Marimba0/note_070_A#4.wav"),
			preload("res://Audio/Marimba0/note_071_B4.wav"),
			preload("res://Audio/Marimba0/note_072_C5.wav"),
			preload("res://Audio/Marimba0/note_073_C#5.wav"),
			preload("res://Audio/Marimba0/note_074_D5.wav"),
			preload("res://Audio/Marimba0/note_075_D#5.wav"),
			preload("res://Audio/Marimba0/note_076_E5.wav"),
			preload("res://Audio/Marimba0/note_077_F5.wav"),
			preload("res://Audio/Marimba0/note_078_F#5.wav"),
			preload("res://Audio/Marimba0/note_079_G5.wav"),
			preload("res://Audio/Marimba0/note_080_G#5.wav"),
			preload("res://Audio/Marimba0/note_081_A5.wav"),
			preload("res://Audio/Marimba0/note_082_A#5.wav"),
			preload("res://Audio/Marimba0/note_083_B5.wav"),
			preload("res://Audio/Marimba0/note_084_C6.wav"),
			preload("res://Audio/Marimba0/note_085_C#6.wav"),
			preload("res://Audio/Marimba0/note_086_D6.wav"),
			preload("res://Audio/Marimba0/note_087_D#6.wav"),
			preload("res://Audio/Marimba0/note_088_E6.wav"),
			preload("res://Audio/Marimba0/note_089_F6.wav"),
			preload("res://Audio/Marimba0/note_090_F#6.wav"),
			preload("res://Audio/Marimba0/note_091_G6.wav"),
			preload("res://Audio/Marimba0/note_092_G#6.wav"),
			preload("res://Audio/Marimba0/note_093_A6.wav"),
			preload("res://Audio/Marimba0/note_094_A#6.wav"),
			preload("res://Audio/Marimba0/note_095_B6.wav"),
		],
	},
	"synth": {
		"startIndex": 36,
		"sounds": [
			preload("res://Audio/Synth0/C2.wav"),
			preload("res://Audio/Synth0/C#2.wav"),
			preload("res://Audio/Synth0/D2.wav"),
			preload("res://Audio/Synth0/D#2.wav"),
			preload("res://Audio/Synth0/E2.wav"),
			preload("res://Audio/Synth0/F2.wav"),
			preload("res://Audio/Synth0/F#2.wav"),
			preload("res://Audio/Synth0/G2.wav"),
			preload("res://Audio/Synth0/G#2.wav"),
			preload("res://Audio/Synth0/A2.wav"),
			preload("res://Audio/Synth0/A#2.wav"),
			preload("res://Audio/Synth0/B2.wav"),
			preload("res://Audio/Synth0/C3.wav"),
			preload("res://Audio/Synth0/C#3.wav"),
			preload("res://Audio/Synth0/D3.wav"),
			preload("res://Audio/Synth0/D#3.wav"),
			preload("res://Audio/Synth0/E3.wav"),
			preload("res://Audio/Synth0/F3.wav"),
			preload("res://Audio/Synth0/F#3.wav"),
			preload("res://Audio/Synth0/G3.wav"),
			preload("res://Audio/Synth0/G#3.wav"),
			preload("res://Audio/Synth0/A3.wav"),
			preload("res://Audio/Synth0/A#3.wav"),
			preload("res://Audio/Synth0/B3.wav"),
			preload("res://Audio/Synth0/C4.wav"),
			preload("res://Audio/Synth0/C#4.wav"),
			preload("res://Audio/Synth0/D4.wav"),
			preload("res://Audio/Synth0/D#4.wav"),
			preload("res://Audio/Synth0/E4.wav"),
			preload("res://Audio/Synth0/F4.wav"),
			preload("res://Audio/Synth0/F#4.wav"),
			preload("res://Audio/Synth0/G4.wav"),
			preload("res://Audio/Synth0/G#4.wav"),
			preload("res://Audio/Synth0/A4.wav"),
			preload("res://Audio/Synth0/A#4.wav"),
			preload("res://Audio/Synth0/B4.wav"),
			preload("res://Audio/Synth0/C5.wav"),
			preload("res://Audio/Synth0/C#5.wav"),
			preload("res://Audio/Synth0/D5.wav"),
			preload("res://Audio/Synth0/D#5.wav"),
			preload("res://Audio/Synth0/E5.wav"),
			preload("res://Audio/Synth0/F5.wav"),
			preload("res://Audio/Synth0/F#5.wav"),
			preload("res://Audio/Synth0/G5.wav"),
			preload("res://Audio/Synth0/G#5.wav"),
			preload("res://Audio/Synth0/A5.wav"),
			preload("res://Audio/Synth0/A#5.wav"),
			preload("res://Audio/Synth0/B5.wav"),
			preload("res://Audio/Synth0/C6.wav"),
		],
	},
};

const trackMaps = {
	"7nation": {
		"1": "synth", # bass
		"2": "percussion", # mixed kick/hihat per note
		"3": "synth", # guitar
	},
	"gravity_falls": {
		"1": "marimba",
		"2": "synth",
		"3": "percussion",
	},
};

static var SONG_7NATION = "7nation";
static var SONG_GRAVITY_FALLS = "gravity_falls";
@export var my_song: String;

func _init(songName: String = "gravity_falls"):
	my_song = songName;

func makeSong() -> Song:
	var file = "res://SongCsvs/" + my_song + ".min.csv";
	var data = CsvLoader.load(file);
	var trackMap = trackMaps[my_song];
	
	var song = Song.new();
	song.red_parts.append_array([ PARTS.marimba, PARTS.synth ]);
	song.blue_parts.append_array([ PARTS.kick, PARTS.percussion ]);
	song.yellow_parts.append_array([ PARTS.hihat ]);
	song.bps = 1;

	var last_note = 0;

	for datum in data:
		if (not datum.track in trackMap): continue;

		var track = trackMap[datum.track];
		var trackMapping = SOUNDS_BY_TRACK[track];
		var sound = getSound(trackMapping, int(datum.note));
		var beat = int(datum.start) / 1000.0;
		var part = PARTS[track];

		if (beat > last_note): last_note = beat;

		var note = Note.new();
		note.audio_stream = sound;
		note.beat = beat;
		note.part = part;
		song.notes.append(note);

	add_spawns(song, last_note);

	return song;

func getSound(trackMapping: Dictionary, noteId: int) -> AudioStream:
	var startIndex: int = trackMapping.startIndex;
	var sounds = trackMapping.sounds; # Array[AudioStream]
	
	var soundIndex = posmod(noteId - startIndex, sounds.size());
	
	return sounds[soundIndex];

const spawnNone := EnemyType.Enum.None;
const spawnBox := EnemyType.Enum.Box;
const spawnBall := EnemyType.Enum.Ball;
const spawnCone := EnemyType.Enum.Cone;

func add_spawns(song: Song, last_note: float):
	addPatternSpawns(song, PARTS.spawn1, 0, int(last_note * 0.9), [
		spawnBox, spawnBall, spawnCone, spawnNone, spawnBox, spawnBall, spawnCone, spawnNone, spawnNone, spawnNone,
	], 0.5);

static func addPatternSpawns(song: Song, part: Part, startBeat: int, endBeat: int, pattern: Array[EnemyType.Enum], rate: float = 1, offset: float = 0):
	var length := (endBeat - startBeat) * rate;
	for beat in range(0, length):
		var position := beat % pattern.size();
		var enemy_type: EnemyType.Enum = pattern[position];
		if (enemy_type == EnemyType.Enum.None): continue;
		var note := makeNote(beat/rate + offset, part, null, enemy_type);
		song.notes.push_back(note);

static func makeNote(beat: float, part: Part, audio: AudioStream, enemy: EnemyType.Enum) -> Note:
	var note := Note.new();
	
	note.beat = beat;
	note.part = part;
	note.audio_stream = audio;
	note.spawn_enemy = enemy;
	
	return note;

func analyzeSongCsv(file: String = "res://SongCsvs/7nation.min.csv"):
	var data = CsvLoader.load(file);
	
	var trackInfos: Dictionary[int, TrackInfo] = {};
	for datum in data:
		var trackId := int(datum.track);
		
		if (not trackId in trackInfos):
			trackInfos[trackId] = TrackInfo.new(datum);
		else:
			trackInfos[trackId].logNote(datum);
	
	print("Analyzed song in " + file);
	print("Tracks: " + str(trackInfos.size()));
	print("");
	
	for key in trackInfos:
		var info = trackInfos[key];
		print("Track " + str(key) + ":");
		info.logInfo();

class TrackInfo:
	var id: int;
	var note_min: int;
	var note_max: int;
	var volume_min: int;
	var volume_max: int;
	var volume_average: float;
	var note_count: int = 1;
	var duration_min: int;
	var duration_max: int;
	var duration_average: float;
	var start_earliest: int;
	var start_average: float;
	var end_latest: int;

	func _init(musicData: Dictionary):
		var track := int(musicData.track);
		var note := int(musicData.note);
		var volume := int(musicData.volume);
		var start := int(musicData.start);
		var duration := int(musicData.duration);
		var end := start + duration;
		
		id = track;
		note_min = note;
		note_max = note;
		volume_min = volume;
		volume_max = volume;
		volume_average = volume;
		duration_min = duration;
		duration_max = duration;
		duration_average = duration;
		start_earliest = start;
		start_average = start;
		end_latest = end;

	func logNote(musicData: Dictionary):
		var note := int(musicData.note);
		var volume := int(musicData.volume);
		var start := int(musicData.start);
		var duration := int(musicData.duration);
		var end := start + duration;

		note_count += 1;

		if (note < note_min): note_min = note;
		if (note > note_max): note_max = note;
		if (volume < volume_min): volume_min = volume;
		if (volume > volume_max): volume_max = volume;
		if (duration < duration_min): duration_min = duration;
		if (duration > duration_max): duration_max = duration;
		if (start < start_earliest): start_earliest = start;
		if (end > end_latest): end_latest = end;
		
		# Multiply old rolling averages by e.g. 7/8,
		var aveFrac: float = (note_count - 1.0) / note_count;
		# Then add e.g. 1/8 of new value.
		var aveDelta: float = 1.0 / note_count;

		volume_average   = volume_average   * aveFrac + volume   * aveDelta;
		duration_average = duration_average * aveFrac + duration * aveDelta;
		start_average    = start_average    * aveFrac + start    * aveDelta;

	func logInfo(prefix: String = "  "):
		print(prefix + "Id: " + str(id));
		print(prefix + "Number of Notes: " + str(note_count));
		print(prefix + "Earliest Note:       " + str(start_earliest / 1000) + "s");
		print(prefix + "Average Note Starts: " + str(start_average / 1000) + "s");
		print(prefix + "Last Note Ends:      " + str(end_latest / 1000) + "s");
		print(prefix + "Low Note:  " + str(note_min));
		print(prefix + "High Note: " + str(note_max));
		print(prefix + "Min Volume: " + str(volume_min));
		print(prefix + "Ave Volume: " + str(volume_average));
		print(prefix + "Max Volume: " + str(volume_max));
		print(prefix + "Shortest Note Length: " + str(duration_min) + "ms");
		print(prefix + "Average Note Length:  " + str(duration_average) + "ms");
		print(prefix + "Longest Note Length:  " + str(duration_max) + "ms");
