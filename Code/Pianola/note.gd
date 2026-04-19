class_name Note extends Resource

enum Enum {
	C2        = 0,
	C2sharp   = 1,
	D2        = 2,
	D2sharp   = 3,
	E2        = 4,
	F2        = 5,
	F2sharp   = 6,
	G2        = 7,
	G2sharp   = 8,
	A2        = 9,
	A2sharp   = 10,
	B2        = 11,

	C3        = 12,
	C3sharp   = 13,
	D3        = 14,
	D3sharp   = 15,
	E3        = 16,
	F3        = 17,
	F3sharp   = 18,
	G3        = 19,
	G3sharp   = 20,
	A3        = 21,
	A3sharp   = 22,
	B3        = 23,

	C4        = 24,
	C4sharp   = 25,
	D4        = 26,
	D4sharp   = 27,
	E4        = 28,
	F4        = 29,
	F4sharp   = 30,
	G4        = 31,
	G4sharp   = 32,
	A4        = 33,
	A4sharp   = 34,
	B4        = 35,

	C5        = 36,
	C5sharp   = 37,
	D5        = 38,
	D5sharp   = 39,
	E5        = 40,
	F5        = 41,
	F5sharp   = 42,
	G5        = 43,
	G5sharp   = 44,
	A5        = 45,
	A5sharp   = 46,
	B5        = 47,

	C6        = 48,
};

# The beat on which this note is triggered.
@export var beat : float
# The part to which this note belongs to.
@export var part : Part
# The enum of which
@export var note: Enum
# Sound that will be played.
@export var audio_stream : AudioStream
