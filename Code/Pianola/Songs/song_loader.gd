# @author Vivian
# SongLoader loads song data from a .csv file, and creates a corresponding game-logic Song object.

class_name SongLoader extends SongGenerator

const PARTS: Dictionary[String, Resource] = {
	"kick": preload("res://Code/Pianola/Songs/kicks_resource.tres"),
	"hihat": preload("res://Code/Pianola/Songs/hihats_resource.tres"),
	"synth": preload("res://Code/Pianola/Songs/synth_resource.tres"),
	"marimba": preload("res://Code/Pianola/Songs/marimba_resource.tres"),
	"spawn1": preload("uid://c25sck87yn44s"),
	"spawn2": preload("uid://tf55e001gar5"),
	"spawn3": preload("uid://ctvecbluw3187"),
};

const SOUNDS_BY_TRACK = {
	"kick": {
		"startIndex": 0,
		"sounds": [
			preload("res://Audio/Drums/kick_drum_1.ogg"),
		],
	},
};

func test():
	var data = CsvLoader.load("res://SongCsvs/7nation.min.csv");
	var song = Song.new();
	
	var trackMap = {
		"2": "kick",
	};

	for datum in data:
		if (datum.track in trackMap):
			var trackMapping = SOUNDS_BY_TRACK[trackMap[datum.track]];
			var sound = getSound(trackMapping, int(datum.note));
			var beat = int(datum.start) / 1000.0;
			print(sound, beat);

	return song;

func getSound(trackMapping: Dictionary, noteId: int) -> AudioStream:
	var startIndex: int = trackMapping.startIndex;
	var sounds = trackMapping.sounds; # Array[AudioStream]
	
	var soundIndex = posmod(noteId - startIndex, sounds.size());
	
	return sounds[soundIndex];
