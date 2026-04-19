import numpy as np
import soundfile as sf
import os
import matplotlib.pyplot as plt
from scipy import signal as scipy_signal # Added for easy Square/Triangle

# =========================
# CONFIG
# =========================
SAMPLE_RATE = 44100
OUTPUT_DIR = "notes"

WAVE_TYPE = "TRIANGLE"   # Options: "SINE", "TRIANGLE", "SQUARE"

ATTACK = 0.1      # seconds
DECAY = 0.1       # seconds
RELEASE = 0.1     # seconds
HOLD = 0.1        # seconds

SUSTAIN_LEVEL = 0.0

K_ATTACK = 1.0
K_DECAY = 2.0
K_RELEASE = 2.0

# Harmonic amplitudes (0th = fundamental)
OVERTONES = [1.0, 0.1, 0.2, 0.5, 0.12, 0.0, 0.08, 0.02, 0.03, 0.45]

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
    for octave in range(1, 7):  # C1 to B5
        for n in NOTE_NAMES:
            notes.append((n, octave))
    notes.append(('C', 8))  # final key
    return notes

# =========================
# ENVELOPE
# =========================

def shaped_curve(length, start, end, k):
    if length <= 0:
        return np.array([])

    x = np.linspace(0, 1, length, endpoint=False)
    p = 2 ** k
    y = 1 - (1 - x) ** p

    return start + (end - start) * y


def adsr_envelope():
    attack_s = int(ATTACK * SAMPLE_RATE)
    decay_s = int(DECAY * SAMPLE_RATE)
    hold_s = int(HOLD * SAMPLE_RATE)
    release_s = int(RELEASE * SAMPLE_RATE)

    # Attack
    attack = shaped_curve(attack_s, 0.0, 1.0, K_ATTACK)

    # Decay
    decay = shaped_curve(decay_s, 1.0, SUSTAIN_LEVEL, K_DECAY)

    attack_decay = np.concatenate([attack, decay])

    # Pre-release (hold or decay whichever is longer)
    if len(attack_decay) < hold_s:
        sustain = np.full(hold_s - len(attack_decay), SUSTAIN_LEVEL)
        pre_release = np.concatenate([attack_decay, sustain])
    else:
        pre_release = attack_decay[:hold_s]

    release_start = pre_release[-1] if len(pre_release) > 0 else 0.0

    # Release
    release = shaped_curve(release_s, release_start, 0.0, K_RELEASE)

    return np.concatenate([pre_release, release])

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

def get_oscillator(wave_type, freq, t):
    """Generates the base waveform shape."""
    if wave_type == "SINE":
        return np.sin(2 * np.pi * freq * t)
    elif wave_type == "SQUARE":
        return scipy_signal.square(2 * np.pi * freq * t)
    elif wave_type == "TRIANGLE":
        return scipy_signal.sawtooth(2 * np.pi * freq * t, width=0.5)
    else:
        return np.sin(2 * np.pi * freq * t)

def synthesize(freq, wave_type="SINE"):
    env = adsr_envelope()
    total_samples = len(env)
    duration = total_samples / SAMPLE_RATE
    t = np.linspace(0, duration, total_samples, endpoint=False)

    final_signal = np.zeros_like(t)
    overtone_array = np.array(OVERTONES, dtype=float)
    overtone_array /= np.max(np.abs(overtone_array))

    for i, amp in enumerate(overtone_array):
        harmonic_freq = freq * (i + 1)
        # Apply the chosen wave shape to every harmonic layer
        final_signal += amp * get_oscillator(wave_type, harmonic_freq, t)

    final_signal = normalize_rms(final_signal, target_rms=0.2)
    final_signal *= loudness_compensation(freq)
    final_signal *= env

    return final_signal.astype(np.float32)

# =========================
# PLOTTING LOGIC
# =========================

def plot_adsr(note_name, octave):
    """Generates the envelope for a specific note and plots it."""
    midi = note_to_midi(note_name, octave)
    freq = midi_to_freq(midi)

    # Generate envelope first (it defines true duration)
    env = adsr_envelope()
    total_samples = len(env)
    duration = total_samples / SAMPLE_RATE

    # Time axis matches actual envelope length
    t = np.linspace(0, duration, total_samples, endpoint=False)

    plt.figure(figsize=(10, 4))
    plt.plot(t, env, color='darkorange', linewidth=2)
    plt.fill_between(t, env, color='orange', alpha=0.3)

    plt.title(f"ADSR Envelope for {note_name}{octave} ({freq:.2f} Hz)")
    plt.xlabel("Time (seconds)")
    plt.ylabel("Amplitude")
    plt.grid(True, linestyle='--', alpha=0.6)
    plt.tight_layout()

    print(f"Showing ADSR plot for {note_name}{octave}. Close the window to continue generation...")
    plt.show()

# =========================
# MAIN
# =========================

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    plot_adsr('C', 4)
    notes = generate_notes()

    for note, octave in notes:
        midi = note_to_midi(note, octave)
        freq = midi_to_freq(midi)

        # Pass the WAVE_TYPE from config here
        audio = synthesize(freq, wave_type=WAVE_TYPE)

        filename = f"note_{midi:03}_{note}{octave}.wav"
        path = os.path.join(OUTPUT_DIR, filename)

        sf.write(path, audio, SAMPLE_RATE)
        print(f"Generated {filename} ({freq:.2f} Hz)")

if __name__ == "__main__":
    main()