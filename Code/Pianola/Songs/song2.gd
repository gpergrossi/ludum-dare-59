# @author Vivian

class_name Song2 extends SongGenerator

const PARTS: Dictionary[String, Resource] = {
	"kick": preload("res://Code/Pianola/Songs/kicks_resource.tres"),
	"hihat": preload("res://Code/Pianola/Songs/hihats_resource.tres"),
	"synth": preload("res://Code/Pianola/Songs/synth_resource.tres"),
	"marimba": preload("res://Code/Pianola/Songs/marimba_resource.tres"),
	"spawn1": preload("uid://c25sck87yn44s"),
	"spawn2": preload("uid://tf55e001gar5"),
	"spawn3": preload("uid://ctvecbluw3187"),
}

const kick: AudioStream = preload("res://Audio/Drums/kick_drum_1.ogg");

const hihat1: AudioStream = preload("res://Audio/Drums/hihat_1.ogg");
const hihat2: AudioStream = preload("res://Audio/Drums/hihat_2.ogg");
const hihat3: AudioStream = preload("res://Audio/Drums/hihat_3.ogg");
const hihat4: AudioStream = preload("res://Audio/Drums/hihat_4.ogg");

const s1: AudioStream = preload("res://Audio/Synth0/C2.wav");
const s1s: AudioStream = preload("res://Audio/Synth0/C#2.wav");
const s2: AudioStream = preload("res://Audio/Synth0/D2.wav");
const s2s: AudioStream = preload("res://Audio/Synth0/D#2.wav");
const s3: AudioStream = preload("res://Audio/Synth0/E2.wav");
const s4: AudioStream = preload("res://Audio/Synth0/F2.wav");
const s4s: AudioStream = preload("res://Audio/Synth0/F#2.wav");
const s5: AudioStream = preload("res://Audio/Synth0/G2.wav");
const s5s: AudioStream = preload("res://Audio/Synth0/G#2.wav");
const s6: AudioStream = preload("res://Audio/Synth0/A2.wav");
const s6s: AudioStream = preload("res://Audio/Synth0/A#2.wav");
const s7: AudioStream = preload("res://Audio/Synth0/B2.wav");
const s8: AudioStream = preload("res://Audio/Synth0/C3.wav");
const s8s: AudioStream = preload("res://Audio/Synth0/C#3.wav");
const s9: AudioStream = preload("res://Audio/Synth0/D3.wav");
const s9s: AudioStream = preload("res://Audio/Synth0/D#3.wav");
const s10: AudioStream = preload("res://Audio/Synth0/E3.wav");
const s11: AudioStream = preload("res://Audio/Synth0/F3.wav");
const s11s: AudioStream = preload("res://Audio/Synth0/F#3.wav");
const s12: AudioStream = preload("res://Audio/Synth0/G3.wav");
const s12s: AudioStream = preload("res://Audio/Synth0/G#3.wav");
const s13: AudioStream = preload("res://Audio/Synth0/A3.wav");
const s13s: AudioStream = preload("res://Audio/Synth0/A#3.wav");
const s14: AudioStream = preload("res://Audio/Synth0/B3.wav");
const s15: AudioStream = preload("res://Audio/Synth0/C4.wav");
const s15s: AudioStream = preload("res://Audio/Synth0/C#4.wav");
const s16: AudioStream = preload("res://Audio/Synth0/D4.wav");
const s16s: AudioStream = preload("res://Audio/Synth0/D#4.wav");
const s17: AudioStream = preload("res://Audio/Synth0/E4.wav");
const s18: AudioStream = preload("res://Audio/Synth0/F4.wav");
const s18s: AudioStream = preload("res://Audio/Synth0/F#4.wav");
const s19: AudioStream = preload("res://Audio/Synth0/G4.wav");
const s19s: AudioStream = preload("res://Audio/Synth0/G#4.wav");
const s20: AudioStream = preload("res://Audio/Synth0/A4.wav");
const s20s: AudioStream = preload("res://Audio/Synth0/A#4.wav");
const s21: AudioStream = preload("res://Audio/Synth0/B4.wav");
const s22: AudioStream = preload("res://Audio/Synth0/C5.wav");
const s22s: AudioStream = preload("res://Audio/Synth0/C#5.wav");
const s23: AudioStream = preload("res://Audio/Synth0/D5.wav");
const s23s: AudioStream = preload("res://Audio/Synth0/D#5.wav");
const s24: AudioStream = preload("res://Audio/Synth0/E5.wav");
const s25: AudioStream = preload("res://Audio/Synth0/F5.wav");
const s25s: AudioStream = preload("res://Audio/Synth0/F#5.wav");
const s26: AudioStream = preload("res://Audio/Synth0/G5.wav");
const s26s: AudioStream = preload("res://Audio/Synth0/G#5.wav");
const s27: AudioStream = preload("res://Audio/Synth0/A5.wav");
const s27s: AudioStream = preload("res://Audio/Synth0/A#5.wav");
const s28: AudioStream = preload("res://Audio/Synth0/B5.wav");
const s29: AudioStream = preload("res://Audio/Synth0/C6.wav");

# These ones we're going to number diffferently; sharps get their own numeral, unlike above.
# Range used to run from note 36 (C2) to 84 (C6).
const m24: AudioStream = preload("res://Audio/Marimba0/note_024_C1.wav");
const m25: AudioStream = preload("res://Audio/Marimba0/note_025_C#1.wav");
const m26: AudioStream = preload("res://Audio/Marimba0/note_026_D1.wav");
const m27: AudioStream = preload("res://Audio/Marimba0/note_027_D#1.wav");
const m28: AudioStream = preload("res://Audio/Marimba0/note_028_E1.wav");
const m29: AudioStream = preload("res://Audio/Marimba0/note_029_F1.wav");
const m30: AudioStream = preload("res://Audio/Marimba0/note_030_F#1.wav");
const m31: AudioStream = preload("res://Audio/Marimba0/note_031_G1.wav");
const m32: AudioStream = preload("res://Audio/Marimba0/note_032_G#1.wav");
const m33: AudioStream = preload("res://Audio/Marimba0/note_033_A1.wav");
const m34: AudioStream = preload("res://Audio/Marimba0/note_034_A#1.wav");
const m35: AudioStream = preload("res://Audio/Marimba0/note_035_B1.wav");
const m36: AudioStream = preload("res://Audio/Marimba0/note_036_C2.wav");
const m37: AudioStream = preload("res://Audio/Marimba0/note_037_C#2.wav");
const m38: AudioStream = preload("res://Audio/Marimba0/note_038_D2.wav");
const m39: AudioStream = preload("res://Audio/Marimba0/note_039_D#2.wav");
const m40: AudioStream = preload("res://Audio/Marimba0/note_040_E2.wav");
const m41: AudioStream = preload("res://Audio/Marimba0/note_041_F2.wav");
const m42: AudioStream = preload("res://Audio/Marimba0/note_042_F#2.wav");
const m43: AudioStream = preload("res://Audio/Marimba0/note_043_G2.wav");
const m44: AudioStream = preload("res://Audio/Marimba0/note_044_G#2.wav");
const m45: AudioStream = preload("res://Audio/Marimba0/note_045_A2.wav");
const m46: AudioStream = preload("res://Audio/Marimba0/note_046_A#2.wav");
const m47: AudioStream = preload("res://Audio/Marimba0/note_047_B2.wav");
const m48: AudioStream = preload("res://Audio/Marimba0/note_048_C3.wav");
const m49: AudioStream = preload("res://Audio/Marimba0/note_049_C#3.wav");
const m50: AudioStream = preload("res://Audio/Marimba0/note_050_D3.wav");
const m51: AudioStream = preload("res://Audio/Marimba0/note_051_D#3.wav");
const m52: AudioStream = preload("res://Audio/Marimba0/note_052_E3.wav");
const m53: AudioStream = preload("res://Audio/Marimba0/note_053_F3.wav");
const m54: AudioStream = preload("res://Audio/Marimba0/note_054_F#3.wav");
const m55: AudioStream = preload("res://Audio/Marimba0/note_055_G3.wav");
const m56: AudioStream = preload("res://Audio/Marimba0/note_056_G#3.wav");
const m57: AudioStream = preload("res://Audio/Marimba0/note_057_A3.wav");
const m58: AudioStream = preload("res://Audio/Marimba0/note_058_A#3.wav");
const m59: AudioStream = preload("res://Audio/Marimba0/note_059_B3.wav");
const m60: AudioStream = preload("res://Audio/Marimba0/note_060_C4.wav");
const m61: AudioStream = preload("res://Audio/Marimba0/note_061_C#4.wav");
const m62: AudioStream = preload("res://Audio/Marimba0/note_062_D4.wav");
const m63: AudioStream = preload("res://Audio/Marimba0/note_063_D#4.wav");
const m64: AudioStream = preload("res://Audio/Marimba0/note_064_E4.wav");
const m65: AudioStream = preload("res://Audio/Marimba0/note_065_F4.wav");
const m66: AudioStream = preload("res://Audio/Marimba0/note_066_F#4.wav");
const m67: AudioStream = preload("res://Audio/Marimba0/note_067_G4.wav");
const m68: AudioStream = preload("res://Audio/Marimba0/note_068_G#4.wav");
const m69: AudioStream = preload("res://Audio/Marimba0/note_069_A4.wav");
const m70: AudioStream = preload("res://Audio/Marimba0/note_070_A#4.wav");
const m71: AudioStream = preload("res://Audio/Marimba0/note_071_B4.wav");
const m72: AudioStream = preload("res://Audio/Marimba0/note_072_C5.wav");
const m73: AudioStream = preload("res://Audio/Marimba0/note_073_C#5.wav");
const m74: AudioStream = preload("res://Audio/Marimba0/note_074_D5.wav");
const m75: AudioStream = preload("res://Audio/Marimba0/note_075_D#5.wav");
const m76: AudioStream = preload("res://Audio/Marimba0/note_076_E5.wav");
const m77: AudioStream = preload("res://Audio/Marimba0/note_077_F5.wav");
const m78: AudioStream = preload("res://Audio/Marimba0/note_078_F#5.wav");
const m79: AudioStream = preload("res://Audio/Marimba0/note_079_G5.wav");
const m80: AudioStream = preload("res://Audio/Marimba0/note_080_G#5.wav");
const m81: AudioStream = preload("res://Audio/Marimba0/note_081_A5.wav");
const m82: AudioStream = preload("res://Audio/Marimba0/note_082_A#5.wav");
const m83: AudioStream = preload("res://Audio/Marimba0/note_083_B5.wav");
const m84: AudioStream = preload("res://Audio/Marimba0/note_084_C6.wav");
const m85: AudioStream = preload("res://Audio/Marimba0/note_085_C#6.wav");
const m86: AudioStream = preload("res://Audio/Marimba0/note_086_D6.wav");
const m87: AudioStream = preload("res://Audio/Marimba0/note_087_D#6.wav");
const m88: AudioStream = preload("res://Audio/Marimba0/note_088_E6.wav");
const m89: AudioStream = preload("res://Audio/Marimba0/note_089_F6.wav");
const m90: AudioStream = preload("res://Audio/Marimba0/note_090_F#6.wav");
const m91: AudioStream = preload("res://Audio/Marimba0/note_091_G6.wav");
const m92: AudioStream = preload("res://Audio/Marimba0/note_092_G#6.wav");
const m93: AudioStream = preload("res://Audio/Marimba0/note_093_A6.wav");
const m94: AudioStream = preload("res://Audio/Marimba0/note_094_A#6.wav");
const m95: AudioStream = preload("res://Audio/Marimba0/note_095_B6.wav");

# Rest. 3-char abbreviation so that it lines up visually with the 3-character sound codes.
const rst := null;

const spawnNone := EnemyType.Enum.None
const spawnBox := EnemyType.Enum.Box
const spawnBall := EnemyType.Enum.Ball
const spawnCone := EnemyType.Enum.Cone

const IN_THE_HALL = [
	# Key: F and C sharp
	# 8th notes

	# Opening chord
	[m66, m54], rst, rst, rst, rst, rst, rst, rst,

	# 1st movement, low
	m35, m37, m38, m40, m42, m38, m42, rst,
	m41, m37, m41, rst, m40, m36, m40, rst,
	m35, m37, m38, m40, m42, m38, m42, m47,
	m45, m42, m38, m42, m45, rst, rst, rst,

	# 2nd movement, higher
	m47, m49, m50, m52, m54, m50, m54, rst,
	m53, m49, m53, rst, m52, m48, m52, rst,
	m47, m49, m50, m52, m54, m50, m54, m59,
	m57, m54, m50, m54, [m57, m45], rst, rst, rst,

	# 3rd movement, higher and tense
	m42, m44, m46, m47, m49, m45, m49, rst,
	m50, m46, m50, rst, m49, m45, m49, rst,
	m42, m44, m46, m47, m49, m45, m49, rst,
	m50, m46, m50, rst, m49, rst, rst, rst,

	# 4th movement, higherer
	m54, m56, m58, m59, m61, m58, m61, rst,
	m62, m58, m62, rst, m61, m58, m61, rst,
	m54, m56, m58, m59, m61, m58, m61, rst,
	m62, m58, m62, rst, [m61, m49], rst, rst, rst,

	# 5th movement, duplicate of #1
	m35, m37, m38, m40, m42, m38, m42, rst,
	m41, m37, m41, rst, m40, m36, m40, rst,
	m35, m37, m38, m40, m42, m38, m42, m47,
	m45, m42, m38, m42, m45, rst, rst, rst,

	# 6th movement, near-duplicate of #2 (final note is non-chord)
	m47, m49, m50, m52, m54, m50, m54, rst,
	m53, m49, m53, rst, m52, m48, m52, rst,
	m47, m49, m50, m52, m54, m50, m54, m59,
	m57, m54, m50, m54, m47, rst, rst, rst,

	# 7th movement, shift to treble clef, increasingly discordant
	m59, m61, [m62, m54], m64, m66, m62, [m66, m54], rst,
	m65, m61, [m65, m54], rst, m64, m60, [m64, m54], rst,
	m59, m61, [m62, m54], m64, m66, m62, m66, m71,
	m69, m66, [m62, m57], m66, m69, rst, [m62, m57], rst,

	# 8th movement, higher
	m71, m73, m74, m76, m78, m74, m78, rst,
	m77, m73, m77, rst, m76, m72, m76, rst,
	m71, m73, m74, m76, m78, m74, m78, m83,
	m81, m78, [m74, m69], m78, m81, rst, [m74, m69], rst,

	# 9th movement, lower, more chordant
	m66, m68, [m70, m66], m71, m73, m69, [m73, m69, m66], rst,
	m74, m70, [m74, m69, m66], rst, m73, m69, [m73, m69, m66], rst,
	m66, m68, [m70, m66], m71, m73, m69, [m73, m69, m66], rst,
	m74, m70, [m74, m69, m66], rst, m73, rst, [m69, m66], rst,

	# 10th movement, higher, still chordant, less dischordant
	m78, m80, [m82, m78], m83, m85, m82, [m85, m82, m78], rst,
	m86, m82, [m86, m82, m78], rst, m85, m82, [m85, m82, m78], rst,
	m78, m80, [m82, m78], m83, m85, m82, [m85, m82, m78], rst,
	m86, m82, [m86, m82, m78], rst, m85, rst, [m82, m78], rst,

	# 11th movement, duplicate of #7
	m59, m61, [m62, m54], m64, m66, m62, [m66, m54], rst,
	m65, m61, [m65, m54], rst, m64, m60, [m64, m54], rst,
	m59, m61, [m62, m54], m64, m66, m62, m66, m71,
	m69, m66, [m62, m57], m66, m69, rst, [m62, m57], rst,

	# 12th movement, near-dupe of #8
	m71, m73, m74, m76, m78, m74, m78, rst,
	m77, m73, m77, rst, m76, m72, m76, rst,
	m71, m73, m74, m76, m78, m74, [m78, m74, m71], m83,
	m78, m74, [m78, m74, m71], m83, m71, rst, rst, rst,

	# 13th movement, keyshift; not one, but TWO m71s
	[m71, m71], m73, m74, m76, [m78, m71], m74, m78, rst,
	[m77, m71], m73, m77, rst, [m76, m71], m73, m76, rst,
	[m71, m71], m73, m74, m76, m78, m74, m78, m83,
	[m81, m74, m69], m78, m74, m78, [m81, m74, m69], rst, rst, rst,

	# 14th movement, dupe of #13
	[m71, m71], m73, m74, m76, [m78, m71], m74, m78, rst,
	[m77, m71], m73, m77, rst, [m76, m71], m73, m76, rst,
	[m71, m71], m73, m74, m76, m78, m74, m78, m83,
	[m81, m74, m69], m78, m74, m78, [m81, m74, m69], rst, rst, rst,

	# 15th movement, high & tinny; not one, but TWO m78s
	[m78, m78], m80, m82, m83, [m85, m78, m73], m82, [m85, m78, m73], rst,
	[m86, m78, m74], m82, [m86, m78, m74], rst, [m85, m78, m73], m82, [m85, m78, m73], rst,
	m78, [m80, m78], [m82, m78], [m83, m78], [m85, m78, m73], [m82, m78, m73], [m85, m78, m73], rst,
	[m86, m78, m74], [m82, m78, m74], [m86, m78, m74], rst, [m85, m78, m73], rst, rst, rst,

	# 16th movement, near-dupe of #15; brighter, a few extra sharps in measures 2 and 4
	[m78, m78], m80, m82, m83, [m85, m78, m73], m82, [m85, m78, m73], rst,
	[m87, m78, m75], m82, [m87, m78, m75], rst, [m85, m78, m73], m82, [m85, m78, m73], rst,
	m78, [m80, m78], [m82, m78], [m83, m78], [m85, m78, m73], [m82, m78, m73], [m85, m78, m73], rst,
	[m87, m78, m75], [m82, m78, m75], [m87, m78, m75], rst, [m85, m78, m73], rst, rst, rst,

	# 17th movement, lower, dupe of #13
	[m71, m71], m73, m74, m76, [m78, m71], m74, m78, rst,
	[m77, m71], m73, m77, rst, [m76, m71], m73, m76, rst,
	[m71, m71], m73, m74, m76, m78, m74, m78, m83,
	[m81, m74, m69], m78, m74, m78, [m81, m74, m69], rst, rst, rst,

	# 18th movement, chordant and crashes at end
	m71, [m73, m71], [m74, m71], [m76, m71], [m78, m71], [m74, m71], [m78, m74, m71], rst,
	[m77, m71], [m73, m71], [m77, m73, m71], rst, [m76, m71], [m72, m71], [m76, m72, m71], rst,
	m71, m73, m74, m76, m78, m74, m78, m83,
	m78, m74, m78, m83, m71, rst, rst, rst,

	# 19th, bum-scree bum-scree, plus key shift
	[m35, m47], rst, [m49, m50, m54, m57], [m79, m80, m81], [m83, m74], rst, rst, rst,
	[m35, m47], rst, [m50, m54, m59], [m79, m80, m81], [m83, m74], rst, rst, rst,
	m71, m72, m74, m76, m77, m74, m77, m83,
	m82, m77, m82, m84, m83, rst, rst, rst,

	# 20th, bum-scree bum-scree, original key
	[m35, m47], rst, [m49, m50, m54, m57], [m79, m80, m81], [m83, m74], rst, rst, rst,
	[m35, m47], rst, [m50, m54, m59], [m79, m80, m81], [m83, m74], rst, rst, rst,
	m71, m73, m74, m76, m78, m74, m78, m83,
	m82, m77, m82, m84, m83, rst, rst, rst,
	
	# 21st, bum-scree bum-scree, scree scree scree scree scree scree scree
	[m35, m47], rst, [m49, m50, m54, m57], [m79, m80, m81], [m83, m74], rst, rst, rst,
	[m35, m47], rst, [m49, m50, m54, m57], [m79, m80, m81], [m83, m74], rst, rst, rst,
	[m35, m47], rst, [m49, m50, m54, m57, m79, m80, m81], [m83, m74], [m49, m50, m54, m57, m79, m80, m81], [m83, m74], [m49, m50, m54, m57, m79, m80, m81], [m83, m74],
	[m49, m50, m54, m57, m79, m80, m81], [m83, m74], [m49, m50, m54, m57, m79, m80, m81], [m83, m74], [m49, m50, m54, m57, m79, m80, m81], [m83, m74], [m49, m50, m54, m57, m79, m80, m81], [m83, m74],

	# 22nd, improv. outro
	[m35, m47], rst,
	m74, m72, m74, m76, m77, m74, m77, m83,
	m82, m77, m82, m84, m83, rst, rst, rst,
	m71, rst, rst, rst, rst, rst,
];

func makeSong() -> Song:
	var song = Song.new();
	song.song_name = "SecondSong"
	song.blue_parts.append_array([ PARTS.kick ])
	song.red_parts.append_array([ PARTS.hihat ])
	song.yellow_parts.append_array([ PARTS.marimba ])
	
	addPatternSpawns(song, PARTS.spawn1, 0, 80, [
		spawnBox, spawnBall, spawnCone, spawnNone, spawnBox, spawnBall, spawnCone, spawnNone, spawnNone, spawnNone,
	], 0.5);
	
	addPattern(song, PARTS.kick,  0, 352, [
		kick, null, null, null,
		null, null, null, null,
		kick, kick, null, null,
		kick, kick, null, null,
	], 2.0);
	addPattern(song, PARTS.hihat, 0, 352, [
		hihat1, hihat2, null, null,
		hihat3, hihat4, null, null,
	], 2.0);
	addPattern(song, PARTS.marimba, 0, 704, IN_THE_HALL, 4.0);
	
	print(IN_THE_HALL.size());
	
	addPatternSpawns(song, PARTS.spawn1, 0, 800, [
		spawnBox, spawnBall, spawnCone, spawnNone, spawnBox, spawnBall, spawnCone, spawnNone, spawnNone, spawnNone,
	], 0.5);
	
	song.sort_notes()
	song.notes.resize(500)
	
	return song;

static func addPattern(song: Song, part: Part, startBeat: int, endBeat: int, pattern: Array, rate: float = 1, offset: float = 0):
	var length := (endBeat - startBeat) * rate;
	for beat in range(0, length):
		var position := beat % pattern.size();
		var maybeChord = pattern[position];
		if (maybeChord == null): continue;
		
		# Type: Array[AudioStream | Array[AudioStream]] | null
		if (maybeChord is Array):
			#for audio in maybeChord:
			var audio = maybeChord[0]; # Placeholder, until engine supports polyphony & chords
			var note := makeNote(beat/rate + offset, part, audio, EnemyType.Enum.None);
			song.notes.push_back(note);
		else:
			var audio = maybeChord;
			var note := makeNote(beat/rate + offset, part, audio, EnemyType.Enum.None);
			song.notes.push_back(note);

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
