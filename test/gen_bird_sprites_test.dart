import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generate flapping bird sprites', () async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, 320, 60));
    
    final bodyPaint = Paint()..color = const Color(0xFFFF5252); // Red bird
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;
    final beakPaint = Paint()..color = Colors.orange;
    final wingPaint = Paint()..color = const Color(0xFFD50000); // Darker red wing
    
    for (int i=0; i<4; i++) {
       double dx = i * 80.0;
       
       // Draw Body (Oval)
       canvas.drawOval(Rect.fromLTWH(dx + 25, 20, 40, 30), bodyPaint);
       
       // Draw Tail
       Path tail = Path();
       tail.moveTo(dx + 25, 35);
       tail.lineTo(dx + 10, 25);
       tail.lineTo(dx + 15, 35);
       tail.lineTo(dx + 10, 45);
       tail.close();
       canvas.drawPath(tail, wingPaint);
       
       // Draw Eye
       canvas.drawOval(Rect.fromLTWH(dx + 50, 22, 12, 12), eyePaint);
       canvas.drawOval(Rect.fromLTWH(dx + 56, 26, 4, 4), pupilPaint);
       
       // Draw Beak
       Path beak = Path();
       beak.moveTo(dx + 62, 28);
       beak.lineTo(dx + 78, 35);
       beak.lineTo(dx + 62, 42);
       beak.close();
       canvas.drawPath(beak, beakPaint);
       
       // Draw Wing
       double wingAngle = 0;
       if (i == 0) wingAngle = 0.5; // down
       if (i == 1) wingAngle = 0.0; // middle
       if (i == 2) wingAngle = -0.5; // up
       if (i == 3) wingAngle = 0.0; // middle
       
       canvas.save();
       canvas.translate(dx + 35, 30);
       canvas.rotate(wingAngle);
       canvas.drawOval(Rect.fromLTWH(-15, -10, 30, 20), wingPaint);
       canvas.restore();
    }
    
    final image = await recorder.endRecording().toImage(320, 60);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    File('assets/images/bird_spritesheet.png').writeAsBytesSync(byteData!.buffer.asUint8List());
  });
}
