import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generate goofy player sprites', () async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, 800, 80));
    
    final bodyPaint = Paint()..color = const Color(0xFF00B0FF); // Light Blue / Cyan Blob
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;
    final mouthPaint = Paint()..color = const Color(0xFF37474F); // Dark grey mouth
    final tonguePaint = Paint()..color = const Color(0xFFFF5252); // Red tongue
    final limbPaint = Paint()..color = const Color(0xFF29B6F6)..strokeWidth = 6.0..strokeCap = StrokeCap.round; // Light blue arm/leg
    final footPaint = Paint()..color = const Color(0xFF000000); // Black tiny feet

    for (int i=0; i<10; i++) {
       double dx = i * 80.0;
       
       if (i == 9) { 
         // SLIDE Frame - Pancake Mode
         canvas.drawOval(Rect.fromLTWH(dx + 5, 50, 70, 20), bodyPaint); // flat pancake
         // Squished Eyes popping out
         canvas.drawOval(Rect.fromLTWH(dx + 25, 45, 16, 20), eyePaint);
         canvas.drawOval(Rect.fromLTWH(dx + 45, 45, 12, 16), eyePaint);
         canvas.drawOval(Rect.fromLTWH(dx + 30, 53, 4, 4), pupilPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 48, 51, 4, 4), pupilPaint);
         // Mouth flattened
         canvas.drawOval(Rect.fromLTWH(dx + 35, 65, 14, 4), mouthPaint);
         // Tiny feet sticking out the back
         canvas.drawOval(Rect.fromLTWH(dx + 5, 60, 8, 8), footPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 5, 55, 8, 8), footPaint);
         // Arms squished
         canvas.drawLine(Offset(dx + 20, 60), Offset(dx + 0, 65), limbPaint);
         canvas.drawLine(Offset(dx + 60, 60), Offset(dx + 80, 65), limbPaint);
         
       } else if (i == 8) {
         // JUMP Frame - Stretched out tall
         canvas.drawRRect(RRect.fromLTRBR(dx + 25, 5, dx + 55, 65, const Radius.circular(20)), bodyPaint);
         
         // Eyes looking down panicked
         canvas.drawOval(Rect.fromLTWH(dx + 30, 10, 10, 14), eyePaint);
         canvas.drawOval(Rect.fromLTWH(dx + 42, 10, 10, 14), eyePaint);
         canvas.drawOval(Rect.fromLTWH(dx + 34, 18, 3, 3), pupilPaint); // looking down
         canvas.drawOval(Rect.fromLTWH(dx + 46, 18, 3, 3), pupilPaint); // looking down
         
         // Mouth screaming 'O'
         canvas.drawOval(Rect.fromLTWH(dx + 36, 28, 12, 16), mouthPaint);
         
         // Arms flailing UP
         canvas.drawLine(Offset(dx + 25, 30), Offset(dx + 10, 10), limbPaint);
         canvas.drawLine(Offset(dx + 55, 30), Offset(dx + 70, 10), limbPaint);
         
         // Legs dangling down
         canvas.drawLine(Offset(dx + 32, 60), Offset(dx + 30, 75), limbPaint);
         canvas.drawLine(Offset(dx + 48, 60), Offset(dx + 50, 75), limbPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 26, 73, 8, 5), footPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 46, 73, 8, 5), footPaint);

       } else {
         // RUN Frames - Noodle arms swinging, bouncing body
         double t = i / 8.0; 
         double bobY = sin(t * pi * 2 * 2) * 8; // Bounces highly!
         double bodyY = 12 + bobY;
         
         // Body (fat circle)
         canvas.drawOval(Rect.fromLTWH(dx + 20, bodyY, 40, 40), bodyPaint);
         
         // Googly eyes
         canvas.drawOval(Rect.fromLTWH(dx + 35, bodyY + 5, 12, 14), eyePaint);
         canvas.drawOval(Rect.fromLTWH(dx + 48, bodyY + 8, 10, 12), eyePaint);
         // Pupils spinning/lác
         double pupilX = cos(t * pi * 2) * 3;
         double pupilY = sin(t * pi * 2) * 3;
         canvas.drawOval(Rect.fromLTWH(dx + 39 + pupilX, bodyY + 11 + pupilY, 4, 4), pupilPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 51 - pupilX, bodyY + 13 - pupilY, 3, 3), pupilPaint);
         
         // Mouth & Tongue
         Path mouth = Path();
         mouth.moveTo(dx + 38, bodyY + 22);
         mouth.quadraticBezierTo(dx + 45, bodyY + 32, dx + 52, bodyY + 22);
         canvas.drawPath(mouth, Paint()..color=const Color(0xFF37474F)..style=PaintingStyle.stroke..strokeWidth=3);
         
         // Tongue sticking out
         canvas.drawArc(Rect.fromLTWH(dx + 42, bodyY + 24, 6, 8), 0, pi, true, tonguePaint);
         
         // Noodle Arms (wildly rotating)
         double armAngle1 = t * pi * 2 * 2;
         double armAngle2 = -t * pi * 2 * 2;
         canvas.drawLine(Offset(dx + 25, bodyY + 20), Offset(dx + 25 + cos(armAngle1)*15, bodyY + 20 + sin(armAngle1)*15), limbPaint);
         canvas.drawLine(Offset(dx + 55, bodyY + 20), Offset(dx + 55 + cos(armAngle2)*15, bodyY + 20 + sin(armAngle2)*15), limbPaint);
         
         // Short pump legs
         double leg1Y = sin(t * pi * 2) * 10;
         double leg2Y = sin(t * pi * 2 + pi) * 10;
         
         canvas.drawLine(Offset(dx + 30, bodyY + 38), Offset(dx + 30, bodyY + 45 + leg1Y.clamp(0, 8)), limbPaint);
         canvas.drawLine(Offset(dx + 50, bodyY + 38), Offset(dx + 50, bodyY + 45 + leg2Y.clamp(0, 8)), limbPaint);
         
         // Feet
         canvas.drawOval(Rect.fromLTWH(dx + 26, bodyY + 45 + leg1Y.clamp(0, 8), 10, 6), footPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 46, bodyY + 45 + leg2Y.clamp(0, 8), 10, 6), footPaint);
       }
    }
    
    final image = await recorder.endRecording().toImage(800, 80);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    File('assets/images/player_spritesheet.png').writeAsBytesSync(byteData!.buffer.asUint8List());
  });
}
