import wave
import math
import struct
import os

def generate_tone(filename, frequency, duration, volume=0.5, type='sine'):
    sample_rate = 44100
    num_samples = int(sample_rate * duration)
    
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        
        for i in range(num_samples):
            t = float(i) / sample_rate
            if type == 'jump':
                # Sweeping up
                freq = frequency + (i / num_samples) * frequency * 2
                val = math.sin(2.0 * math.pi * freq * t)
            elif type == 'hit':
                # Noise down
                freq = frequency - (i / num_samples) * frequency * 0.5
                val = math.sin(2.0 * math.pi * freq * t) * (1 - t/duration)
            elif type == 'score':
                # High ping
                val = math.sin(2.0 * math.pi * frequency * t) * math.exp(-t * 5)
            else:
                val = math.sin(2.0 * math.pi * frequency * t)
                
            sample = int(val * 32767 * volume)
            sample = max(-32768, min(32767, sample))
            wav_file.writeframes(struct.pack('h', sample))

os.makedirs('assets/audio', exist_ok=True)
generate_tone('assets/audio/jump.wav', 300.0, 0.3, type='jump')
generate_tone('assets/audio/hit.wav', 150.0, 0.4, type='hit')
generate_tone('assets/audio/score.wav', 880.0, 0.5, type='score')
print("Audio generated!")
