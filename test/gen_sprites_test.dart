import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generate perfect programmatic sprites', () async {
    // Generate Player Spritesheet (6 frames, 60x80 each -> 360 x 80)
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, 360, 80));
    final bodyPaint = Paint()..color = Colors.blue;
    final legPaint = Paint()..color = Colors.black..strokeWidth = 4;
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;
    
    for (int i=0; i<6; i++) {
       double dx = i * 60.0;
       
       if (i == 5) { 
         // slide frame: player is ducking down. Height is 50, so y is 30 to 80.
         canvas.drawRect(Rect.fromLTWH(dx + 10, 30, 40, 50), bodyPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 35, 40, 10, 10), eyePaint);
         canvas.drawOval(Rect.fromLTWH(dx + 40, 43, 4, 4), pupilPaint);
       } else {
         canvas.drawRect(Rect.fromLTWH(dx + 10, 10, 40, 40), bodyPaint);
         canvas.drawOval(Rect.fromLTWH(dx + 35, 20, 10, 10), eyePaint);
         canvas.drawOval(Rect.fromLTWH(dx + 40, 23, 4, 4), pupilPaint);
         // draw legs
         if (i == 0 || i == 2) { // run 1, 3
           canvas.drawLine(Offset(dx + 25, 50), Offset(dx + 25, 80), legPaint);
           canvas.drawLine(Offset(dx + 35, 50), Offset(dx + 35, 80), legPaint);
         } else if (i == 1) { // run 2
           canvas.drawLine(Offset(dx + 25, 50), Offset(dx + 15, 75), legPaint);
           canvas.drawLine(Offset(dx + 35, 50), Offset(dx + 45, 65), legPaint);
         } else if (i == 3) { // run 4
           canvas.drawLine(Offset(dx + 25, 50), Offset(dx + 35, 65), legPaint);
           canvas.drawLine(Offset(dx + 35, 50), Offset(dx + 25, 75), legPaint);
         } else if (i == 4) { // jump
           canvas.drawLine(Offset(dx + 25, 50), Offset(dx + 15, 65), legPaint);
           canvas.drawLine(Offset(dx + 35, 50), Offset(dx + 45, 65), legPaint);
         }
       }
    }
    
    final image = await recorder.endRecording().toImage(360, 80);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    File('assets/images/player_spritesheet.png').writeAsBytesSync(byteData!.buffer.asUint8List());

    // Generate obstacle_ground.png (60x60)
    final rec2 = PictureRecorder();
    final c2 = Canvas(rec2, Rect.fromLTWH(0,0,60,60));
    c2.drawRect(Rect.fromLTWH(10, 30, 40, 30), Paint()..color = Colors.brown);
    c2.drawPath(Path()..moveTo(10, 30)..lineTo(30, 0)..lineTo(50, 30)..close(), Paint()..color = Colors.grey);
    final img2 = await rec2.endRecording().toImage(60,60);
    final bd2 = await img2.toByteData(format: ImageByteFormat.png);
    File('assets/images/obstacle_ground.png').writeAsBytesSync(bd2!.buffer.asUint8List());

    // Generate obstacle_air.png (80x60)
    final rec3 = PictureRecorder();
    final c3 = Canvas(rec3, Rect.fromLTWH(0,0,80,60));
    final bodyPath = Path()..addOval(Rect.fromLTWH(20, 20, 40, 20));
    c3.drawPath(bodyPath, Paint()..color = Colors.red);
    // wings
    c3.drawPath(Path()..moveTo(20,30)..lineTo(0,10)..lineTo(30,20)..close(), Paint()..color = Colors.red);
    c3.drawPath(Path()..moveTo(60,30)..lineTo(80,10)..lineTo(50,20)..close(), Paint()..color = Colors.red);
    c3.drawOval(Rect.fromLTWH(25, 25, 6, 6), Paint()..color = Colors.white); // eye
    final img3 = await rec3.endRecording().toImage(80,60);
    final bd3 = await img3.toByteData(format: ImageByteFormat.png);
    File('assets/images/obstacle_air.png').writeAsBytesSync(bd3!.buffer.asUint8List());
  });
}
