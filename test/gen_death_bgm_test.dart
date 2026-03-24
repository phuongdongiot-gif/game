import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generate goofy glitchy death bgm', () async {
    const sampleRate = 44100;
    
    // 2.5 seconds loop of pure 8-bit glitch
    int totalSamples = (sampleRate * 2.5).toInt();
    List<int> pcmData = []; 
    
    for (int t = 0; t < totalSamples; t++) {
        double time = t / sampleRate;
        
        // Base frequency rapidly slides down
        double baseFreq = max(50.0, 600 - (time * 250));
        
        // Glitch effect: high frequency fast alternation (trill)
        double trillSpeed = max(5.0, 40 - time * 15);
        double trill = sin(time * pi * trillSpeed) > 0 ? 200 : 0;
        
        // Stutter (audio cuts out repeatedly)
        bool stutterCut = (time * 12) % 1.0 > 0.6; // 60% on, 40% off
        
        double freq = baseFreq + trill; 
        
        // Pure Square wave generator
        double temp = (time * freq) % 1.0;
        int bit = temp < 0.5 ? 14000 : -14000;
        
        if (stutterCut) bit = 0;
        
        pcmData.add(bit); 
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
    
    File('assets/audio/death_music.wav').writeAsBytesSync(byteData.buffer.asUint8List());
  });
}
