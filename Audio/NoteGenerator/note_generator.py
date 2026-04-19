import numpy as np
import soundfile as sf
import os

# =========================
# CONFIG
# =========================
SAMPLE_RATE = 44100
OUTPUT_DIR = "piano_notes"

ATTACK = 0.05     # seconds
DECAY = 0.2       # seconds
SUSTAIN_LEVEL = 0.2
RELEASE = 0.3     # seconds
HOLD = 0.25       # seconds

# Harmonic amplitudes (0th = fundamental)
OVERTONES = [1.0, 0.5, 0.25, 0.1, 0.05]

# =========================
# NOTE SETUP
# =========================

NOTE_NAMES = ['C', 'C#', 'D', 'D#', 'E', 'F',
              'F#', 'G', 'G#', 'A', 'A#', 'B']

def note_to_midi(note, octave):
    note_index = NOTE_NAMES.index(note)
    return (octave + 1) * 12 + note_index

def midi_to_freq(midi):
    return 440.0 * (2 ** ((midi - 69) / 12))

def generate_notes():
    notes = []
    for octave in range(2, 6):  # C2 to B5
        for n in NOTE_NAMES:
            notes.append((n, octave))
    notes.append(('C', 6))  # final key
    return notes

# =========================
# ENVELOPE
# =========================

def adsr_envelope(total_samples):
    attack_s = int(ATTACK * SAMPLE_RATE)
    decay_s = int(DECAY * SAMPLE_RATE)
    hold_s = int(HOLD * SAMPLE_RATE)
    release_s = int(RELEASE * SAMPLE_RATE)

    # Segments
    attack = np.linspace(0, 1, attack_s, endpoint=False)
    decay = np.linspace(1, SUSTAIN_LEVEL, decay_s, endpoint=False)
    sustain = np.full(hold_s, SUSTAIN_LEVEL)
    release = np.linspace(SUSTAIN_LEVEL, 0, release_s)

    envelope = np.concatenate([attack, decay, sustain, release])

    # Pad if needed
    if len(envelope) < total_samples:
        envelope = np.pad(envelope, (0, total_samples - len(envelope)))

    return envelope[:total_samples]

# =========================
# SYNTHESIS
# =========================

def normalize_rms(signal, target_rms=0.1):
    rms = np.sqrt(np.mean(signal**2))
    if rms > 0:
        signal = signal * (target_rms / rms)
    return signal
    
def loudness_compensation(freq):
    # Reference frequency (A4)
    ref = 440.0
    
    # Exponent controls how strong the effect is
    alpha = 0.3
    
    return (ref / freq) ** alpha

def synthesize(freq):
    duration = ATTACK + DECAY + HOLD + RELEASE
    t = np.linspace(0, duration, int(SAMPLE_RATE * duration), endpoint=False)

    overtone_array = np.array(OVERTONES, dtype=float)
    overtone_array /= np.max(np.abs(overtone_array))

    signal = np.zeros_like(t)

    for i, amp in enumerate(overtone_array):
        harmonic_freq = freq * (i + 1)
        signal += amp * np.sin(2 * np.pi * harmonic_freq * t)

    # Normalize harmonic mix (RMS instead of peak)
    signal = normalize_rms(signal, target_rms=0.2)

    # Apply perceptual loudness compensation
    signal *= loudness_compensation(freq)

    # Apply ADSR
    env = adsr_envelope(len(signal))
    signal *= env

    return signal.astype(np.float32)

# =========================
# MAIN
# =========================

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    notes = generate_notes()

    for note, octave in notes:
        midi = note_to_midi(note, octave)
        freq = midi_to_freq(midi)

        audio = synthesize(freq)

        filename = f"{note}{octave}.wav"
        path = os.path.join(OUTPUT_DIR, filename)

        sf.write(path, audio, SAMPLE_RATE)

        print(f"Generated {filename} ({freq:.2f} Hz)")

if __name__ == "__main__":
    main()