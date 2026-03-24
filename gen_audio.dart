import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

void main() {
  Directory('assets/audio').createSync(recursive: true);
  
  generateTone('assets/audio/jump.wav', 300.0, 0.3, 'jump');
  generateTone('assets/audio/hit.wav', 150.0, 0.4, 'hit');
  generateTone('assets/audio/score.wav', 880.0, 0.5, 'score');
  
  print('Audio fixed and generated!');
}

void generateTone(String filename, double frequency, double duration, String type) {
  int sampleRate = 44100;
  int numSamples = (sampleRate * duration).toInt();
  
  var file = File(filename);
  var sink = file.openSync(mode: FileMode.write);
  
  int byteRate = sampleRate * 1 * 2;
  int dataSize = numSamples * 2;
  int chunkSize = 36 + dataSize;
  
  var header = ByteData(44);
  header.setUint32(0, 0x52494646, Endian.big); // "RIFF" correctly in BigEndian
  header.setUint32(4, chunkSize, Endian.little);
  header.setUint32(8, 0x57415645, Endian.big); // "WAVE"
  header.setUint32(12, 0x666d7420, Endian.big); // "fmt "
  header.setUint32(16, 16, Endian.little); 
  header.setUint16(20, 1, Endian.little); 
  header.setUint16(22, 1, Endian.little); 
  header.setUint32(24, sampleRate, Endian.little); 
  header.setUint32(28, byteRate, Endian.little); 
  header.setUint16(32, 2, Endian.little); 
  header.setUint16(34, 16, Endian.little); 
  header.setUint32(36, 0x64617461, Endian.big); // "data"
  header.setUint32(40, dataSize, Endian.little); 
  
  sink.writeFromSync(header.buffer.asUint8List());
  
  var data = ByteData(dataSize);
  for (int i = 0; i < numSamples; i++) {
    double t = i / sampleRate;
    double val = 0.0;
    
    if (type == 'jump') {
      double freq = frequency + (i / numSamples) * frequency * 2;
      val = sin(2.0 * pi * freq * t);
    } else if (type == 'hit') {
      double freq = frequency - (i / numSamples) * frequency * 0.5;
      val = sin(2.0 * pi * freq * t) * (1 - t/duration);
    } else if (type == 'score') {
      val = sin(2.0 * pi * frequency * t) * exp(-t * 5);
    } else {
      val = sin(2.0 * pi * frequency * t);
    }
    
    int sample = (val * 32767 * 0.5).toInt();
    if (sample > 32767) sample = 32767;
    if (sample < -32768) sample = -32768;
    
    data.setInt16(i * 2, sample, Endian.little);
  }
  
  sink.writeFromSync(data.buffer.asUint8List());
  sink.closeSync();
}
