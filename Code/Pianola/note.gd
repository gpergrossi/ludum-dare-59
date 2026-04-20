class_name Note extends Resource

# The beat on which this note is triggered.
@export var beat : float
# The part to which this note belongs to.
@export var part : Part
# Sound that will be played.
@export var audio_stream : AudioStream
# Enemy which will be spawned.
@export var spawn_enemy : EnemyType.Enum

@export var note := NoteName.No_Note
@export var duration := 0.0      # Unlimited if 0, as long as audio sample.
@export var volume_scale := 1.0  # From 0 (silent) to 1 (max loudness / default)

enum NoteName {
	No_Note = -1,
	C1  = 24,	Cs1 = 25,	D1  = 26,	Ds1 = 27,
	E1  = 28,	F1  = 29,	Fs1 = 30,	G1  = 31,
	Gs1 = 32,	A1  = 33,	As1 = 34,	B1  = 35,
	C2  = 36,	Cs2 = 37,	D2  = 38,	Ds2 = 39,
	E2  = 40,	F2  = 41,	Fs2 = 42,	G2  = 43,
	Gs2 = 44,	A2  = 45,	As2 = 46,	B2  = 47,
	C3  = 48,	Cs3 = 49,	D3  = 50,	Ds3 = 51,
	E3  = 52,	F3  = 53,	Fs3 = 54,	G3  = 55,
	Gs3 = 56,	A3  = 57,	As3 = 58,	B3  = 59,
	C4  = 60,	Cs4 = 61,	D4  = 62,	Ds4 = 63,
	E4  = 64,	F4  = 65,	Fs4 = 66,	G4  = 67,
	Gs4 = 68,	A4  = 69,	As4 = 70,	B4  = 71,
	C5  = 72,	Cs5 = 73,	D5  = 74,	Ds5 = 75,
	E5  = 76,	F5  = 77,	Fs5 = 78,	G5  = 79,
	Gs5 = 80,	A5  = 81,	As5 = 82,	B5  = 83,
	C6  = 84,	Cs6 = 85,	D6  = 86,	Ds6 = 87,
	E6  = 88,	F6  = 89,	Fs6 = 90,	G6  = 91,
	Gs6 = 92,	A6  = 93,	As6 = 94,	B6  = 95,
	C7  = 96,	Cs7 = 97,	D7  = 98,	Ds7 = 99,
	E7  = 100,	F7  = 101,	Fs7 = 102,	G7  = 103,
	Gs7 = 104,	A7  = 105,	As7 = 106,	B7  = 107,
	C8  = 108,
	
	Perc_Bass_Drum_1 = 35,
	Perc_Snare_1 = 38,
	Perc_Acoustic_Tom_1 = 41,
	Perc_Hihat_1 = 42,
	Perc_Hihat_2 = 44,
	Perc_Medium_Crash = 57
}

static func string_to_note(s: String) -> NoteName:
	if NAME_TO_VALUE.has(s):
		return NAME_TO_VALUE[s]
	return NoteName.No_Note

static var NAME_TO_VALUE: Dictionary[String, NoteName] = {
	"No_Note": NoteName.No_Note,
	"C1": NoteName.C1,  "Cs1": NoteName.Cs1,  "D1": NoteName.D1,  "Ds1": NoteName.Ds1,
	"E1": NoteName.E1,  "F1": NoteName.F1,  "Fs1": NoteName.Fs1,  "G1": NoteName.G1,
	"Gs1": NoteName.Gs1, "A1": NoteName.A1,  "As1": NoteName.As1, "B1": NoteName.B1,
	"C2": NoteName.C2,  "Cs2": NoteName.Cs2,  "D2": NoteName.D2,  "Ds2": NoteName.Ds2,
	"E2": NoteName.E2,  "F2": NoteName.F2,  "Fs2": NoteName.Fs2,  "G2": NoteName.G2,
	"Gs2": NoteName.Gs2, "A2": NoteName.A2,  "As2": NoteName.As2, "B2": NoteName.B2,
	"C3": NoteName.C3,  "Cs3": NoteName.Cs3,  "D3": NoteName.D3,  "Ds3": NoteName.Ds3,
	"E3": NoteName.E3,  "F3": NoteName.F3,  "Fs3": NoteName.Fs3,  "G3": NoteName.G3,
	"Gs3": NoteName.Gs3, "A3": NoteName.A3,  "As3": NoteName.As3, "B3": NoteName.B3,
	"C4": NoteName.C4,  "Cs4": NoteName.Cs4,  "D4": NoteName.D4,  "Ds4": NoteName.Ds4,
	"E4": NoteName.E4,  "F4": NoteName.F4,  "Fs4": NoteName.Fs4,  "G4": NoteName.G4,
	"Gs4": NoteName.Gs4, "A4": NoteName.A4,  "As4": NoteName.As4, "B4": NoteName.B4,
	"C5": NoteName.C5,  "Cs5": NoteName.Cs5,  "D5": NoteName.D5,  "Ds5": NoteName.Ds5,
	"E5": NoteName.E5,  "F5": NoteName.F5,  "Fs5": NoteName.Fs5,  "G5": NoteName.G5,
	"Gs5": NoteName.Gs5, "A5": NoteName.A5,  "As5": NoteName.As5, "B5": NoteName.B5,
	"C6": NoteName.C6,  "Cs6": NoteName.Cs6,  "D6": NoteName.D6,  "Ds6": NoteName.Ds6,
	"E6": NoteName.E6,  "F6": NoteName.F6,  "Fs6": NoteName.Fs6,  "G6": NoteName.G6,
	"Gs6": NoteName.Gs6, "A6": NoteName.A6,  "As6": NoteName.As6, "B6": NoteName.B6,
	"C7": NoteName.C7,  "Cs7": NoteName.Cs7,  "D7": NoteName.D7,  "Ds7": NoteName.Ds7,
	"E7": NoteName.E7,  "F7": NoteName.F7,  "Fs7": NoteName.Fs7,  "G7": NoteName.G7,
	"Gs7": NoteName.Gs7, "A7": NoteName.A7,  "As7": NoteName.As7, "B7": NoteName.B7,
	"C8": NoteName.C8
}

# Equal temperament, A4 = 440 Hz
const A4_MIDI = 69
const A4_FREQ = 440.0

static var note_frequencies: Dictionary[NoteName, float] = {
	NoteName.C1: 32.70319566257483,
	NoteName.Cs1: 34.64782887210901,
	NoteName.D1: 36.70809598967594,
	NoteName.Ds1: 38.890872965260115,
	NoteName.E1: 41.20344461410875,
	NoteName.F1: 43.653528929125485,
	NoteName.Fs1: 46.2493028389543,
	NoteName.G1: 48.99942949771866,
	NoteName.Gs1: 51.91308719749314,
	NoteName.A1: 55.0,
	NoteName.As1: 58.27047018976124,
	NoteName.B1: 61.7354126570155,
	NoteName.C2: 65.40639132514966,
	NoteName.Cs2: 69.29565774421802,
	NoteName.D2: 73.41619197935188,
	NoteName.Ds2: 77.78174593052023,
	NoteName.E2: 82.4068892282175,
	NoteName.F2: 87.30705785825097,
	NoteName.Fs2: 92.4986056779086,
	NoteName.G2: 97.99885899543732,
	NoteName.Gs2: 103.82617439498628,
	NoteName.A2: 110.0,
	NoteName.As2: 116.54094037952248,
	NoteName.B2: 123.47082531403103,
	NoteName.C3: 130.8127826502993,
	NoteName.Cs3: 138.59131548843604,
	NoteName.D3: 146.8323839587038,
	NoteName.Ds3: 155.56349186104046,
	NoteName.E3: 164.813778456435,
	NoteName.F3: 174.61411571650194,
	NoteName.Fs3: 184.9972113558172,
	NoteName.G3: 195.99771799087463,
	NoteName.Gs3: 207.65234878997256,
	NoteName.A3: 220.0,
	NoteName.As3: 233.08188075904496,
	NoteName.B3: 246.94165062806206,
	NoteName.C4: 261.6255653005986,
	NoteName.Cs4: 277.1826309768721,
	NoteName.D4: 293.6647679174076,
	NoteName.Ds4: 311.1269837220809,
	NoteName.E4: 329.6275569128699,
	NoteName.F4: 349.2282314330039,
	NoteName.Fs4: 369.9944227116344,
	NoteName.G4: 391.99543598174927,
	NoteName.Gs4: 415.3046975799451,
	NoteName.A4: 440.0,
	NoteName.As4: 466.1637615180899,
	NoteName.B4: 493.8833012561241,
	NoteName.C5: 523.2511306011972,
	NoteName.Cs5: 554.3652619537443,
	NoteName.D5: 587.3295358348151,
	NoteName.Ds5: 622.2539674441618,
	NoteName.E5: 659.2551138257398,
	NoteName.F5: 698.4564628660078,
	NoteName.Fs5: 739.9888454232688,
	NoteName.G5: 783.9908719634986,
	NoteName.Gs5: 830.6093951598903,
	NoteName.A5: 880.0,
	NoteName.As5: 932.3275230361799,
	NoteName.B5: 987.7666025122483,
	NoteName.C6: 1046.5022612023945,
	NoteName.Cs6: 1108.7305239074886,
	NoteName.D6: 1174.6590716696303,
	NoteName.Ds6: 1244.5079348883237,
	NoteName.E6: 1318.5102276514797,
	NoteName.F6: 1396.9129257320155,
	NoteName.Fs6: 1479.9776908465376,
	NoteName.G6: 1567.981743926997,
	NoteName.Gs6: 1661.2187903197805,
	NoteName.A6: 1760.0,
	NoteName.As6: 1864.6550460723597,
	NoteName.B6: 1975.533205024496,
	NoteName.C7: 2093.004522404789,
	NoteName.Cs7: 2217.4610478149773,
	NoteName.D7: 2349.31814333926,
	NoteName.Ds7: 2489.0158697766474,
	NoteName.E7: 2637.0204553029594,
	NoteName.F7: 2793.825851464031,
	NoteName.Fs7: 2959.9553816930755,
	NoteName.G7: 3135.9634878539946,
	NoteName.Gs7: 3322.437580639561,
	NoteName.A7: 3520.0,
	NoteName.As7: 3729.3100921447194,
	NoteName.B7: 3951.066410048992,
	NoteName.C8: 4186.009044809578
}

static func get_frequency(nn: NoteName) -> float:
	if note_frequencies.has(nn):
		return note_frequencies[nn]
	
	# compute if outside table
	var semitone_diff = int(nn) - A4_MIDI
	return A4_FREQ * pow(2.0, semitone_diff / 12.0)
