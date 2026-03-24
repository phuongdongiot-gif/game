import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generate smooth robot sprites', () async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, 800, 80));
    
    final bodyPaint = Paint()..color = const Color(0xFF00E676); // Bright green
    final visorPaint = Paint()..color = const Color(0xFFE0F7FA); // Light blue glass
    final eyePaint = Paint()..color = const Color(0xFF001155); // Dark blue eyes
    final legPaint = Paint()..color = const Color(0xFF424242)..strokeWidth=6..strokeCap=StrokeCap.round; // Legs

    for (int i=0; i<10; i++) {
       double dx = i * 80.0;
       
       if (i == 9) { 
         // SLIDE Frame (index 9)
         // Flattened body
         canvas.drawRRect(RRect.fromLTRBR(dx + 10, 40, dx + 70, 70, const Radius.circular(15)), bodyPaint);
         canvas.drawRRect(RRect.fromLTRBR(dx + 45, 45, dx + 65, 60, const Radius.circular(8)), visorPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 55, 50, 4, 4), eyePaint); 
         // Legs folded
         canvas.drawOval(Rect.fromLTWH(dx + 20, 65, 12, 8), legPaint..style=PaintingStyle.fill);
         canvas.drawOval(Rect.fromLTWH(dx + 50, 65, 12, 8), legPaint);
         
       } else if (i == 8) {
         // JUMP Frame (index 8)
         // Stretched vertically
         canvas.drawRRect(RRect.fromLTRBR(dx + 25, 5, dx + 55, 50, const Radius.circular(15)), bodyPaint);
         canvas.drawRRect(RRect.fromLTRBR(dx + 35, 15, dx + 55, 30, const Radius.circular(8)), visorPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 45, 20, 4, 4), eyePaint);
         // Legs dangling
         canvas.drawLine(Offset(dx + 35, 50), Offset(dx + 30, 70), legPaint);
         canvas.drawLine(Offset(dx + 45, 50), Offset(dx + 50, 70), legPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 25, 70, 10, 8), bodyPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 45, 70, 10, 8), bodyPaint);

       } else {
         // RUN Frames (index 0 to 7)
         double t = i / 8.0; 
         double bobY = sin(t * pi * 2 * 2) * 5; 
         double bodyY = 10 + bobY;
         
         // Body
         canvas.drawRRect(RRect.fromLTRBR(dx + 20, bodyY, dx + 60, bodyY + 40, const Radius.circular(20)), bodyPaint);
         // Visor
         canvas.drawRRect(RRect.fromLTRBR(dx + 35, bodyY + 10, dx + 55, bodyY + 25, const Radius.circular(8)), visorPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 45, bodyY + 15, 4, 4), eyePaint);
         
         // Legs swinging
         double leg1Swing = sin(t * pi * 2) * 15;
         double leg2Swing = sin(t * pi * 2 + pi) * 15;
         
         canvas.drawLine(Offset(dx + 40, bodyY + 40), Offset(dx + 40 + leg1Swing, bodyY + 60), legPaint);
         canvas.drawLine(Offset(dx + 40, bodyY + 40), Offset(dx + 40 + leg2Swing, bodyY + 60), legPaint);
         
         // Feet
         canvas.drawOval(Rect.fromLTWH(dx + 40 + leg1Swing - 6, bodyY + 60, 12, 8), bodyPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 40 + leg2Swing - 6, bodyY + 60, 12, 8), bodyPaint);
       }
    }
    
    final image = await recorder.endRecording().toImage(800, 80);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    File('assets/images/player_spritesheet.png').writeAsBytesSync(byteData!.buffer.asUint8List());
  });
}
