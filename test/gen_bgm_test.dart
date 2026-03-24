import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generate goofy 8-bit bgm', () async {
    const sampleRate = 44100;
    const bpm = 160;
    const beatDuration = 60.0 / bpm; 
    const noteDuration = beatDuration / 4; // 16th notes
    
    final Map<String, double> notes = {
      'C4': 261.63, 'D4': 293.66, 'E4': 329.63, 'F4': 349.23,
      'G4': 392.00, 'A4': 440.00, 'A#4': 466.16, 'B4': 493.88,
      'C5': 523.25, 'D5': 587.33, 'E5': 659.25, 'F5': 698.46,
      'G5': 783.99, '-1': 0.0 // REST
    };
    
    // Goofy bouncy chiptune melody (32 steps = ~3 seconds, loops perfectly)
    final List<String> melody = [
      'C4', 'E4', 'G4', 'C5', 'G4', 'E4', 'C4', 'E4',
      'F4', 'A4', 'C5', 'F5', 'C5', 'A4', 'F4', 'A4',
      'G4', 'B4', 'D5', 'G5', 'D5', 'B4', 'G4', 'B4',
      'G4', '-1', 'F4', '-1', 'E4', '-1', 'D4', '-1'
    ];
    
    List<int> pcmData = []; 
    
    for (int i = 0; i < melody.length; i++) {
        double freq = notes[melody[i]]!;
        int samplesPerNote = (noteDuration * sampleRate).toInt();
        
        for (int j = 0; j < samplesPerNote; j++) {
            double time = j / sampleRate;
            int bit = 0;
            if (freq > 0) {
               // Square wave generator for an 8-bit retro sound
               double temp = (time * freq) % 1.0;
               bit = temp < 0.5 ? 12000 : -12000;
               
               // Envelope (staccato/plucky effect)
               double env = 1.0 - (j / samplesPerNote * 1.5);
               if (env < 0) env = 0;
               bit = (bit * env).toInt(); 
            }
            pcmData.add(bit); 
        }
    }
    
    final byteData = ByteData(44 + pcmData.length * 2);
    // RIFF chunk descriptor
    byteData.setUint32(0, 0x52494646, Endian.big); // "RIFF"
    byteData.setUint32(4, 36 + pcmData.length * 2, Endian.little);
    byteData.setUint32(8, 0x57415645, Endian.big); // "WAVE"
    
    // fmt sub-chunk
    byteData.setUint32(12, 0x666D7420, Endian.big); // "fmt "
    byteData.setUint32(16, 16, Endian.little); 
    byteData.setUint16(20, 1, Endian.little); // PCM
    byteData.setUint16(22, 1, Endian.little); // Mono
    byteData.setUint32(24, sampleRate, Endian.little); // Sample rate
    byteData.setUint32(28, sampleRate * 1 * 2, Endian.little); // Byte rate
    byteData.setUint16(32, 2, Endian.little); // Block align
    byteData.setUint16(34, 16, Endian.little); // 16 bits per sample
    
    // data sub-chunk
    byteData.setUint32(36, 0x64617461, Endian.big); // "data"
    byteData.setUint32(40, pcmData.length * 2, Endian.little);
    
    for (int i = 0; i < pcmData.length; i++) {
      byteData.setInt16(44 + i * 2, pcmData[i], Endian.little);
    }
    
    File('assets/audio/bgm.wav').writeAsBytesSync(byteData.buffer.asUint8List());
  });
}
