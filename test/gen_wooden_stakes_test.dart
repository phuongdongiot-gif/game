import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generate wooden stakes obstacle', () async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, 60, 60));
    
    final woodPaint = Paint()..color = const Color(0xFF6D4C41); // Brown 600
    final streakPaint = Paint()..color = const Color(0xFF4E342E)..strokeWidth = 1.0; // Dark wood grain
    final ropePaint = Paint()..color = const Color(0xFFBCAAA4)..strokeWidth = 2.0; // Light rope
    
    // Draw 3 stakes
    // Left
    Path p1 = Path();
    p1.moveTo(5, 60); p1.lineTo(20, 60); p1.lineTo(20, 25); p1.lineTo(12.5, 10); p1.lineTo(5, 25); p1.close();
    canvas.drawPath(p1, woodPaint);
    canvas.drawLine(Offset(9, 25), Offset(9, 60), streakPaint);
    canvas.drawLine(Offset(16, 30), Offset(16, 55), streakPaint);

    // Right
    Path p3 = Path();
    p3.moveTo(35, 60); p3.lineTo(50, 60); p3.lineTo(50, 30); p3.lineTo(42.5, 15); p3.lineTo(35, 30); p3.close();
    canvas.drawPath(p3, woodPaint);
    canvas.drawLine(Offset(39, 30), Offset(39, 60), streakPaint);
    canvas.drawLine(Offset(46, 35), Offset(46, 55), streakPaint);
    
    // Middle (tallest, slightly overlapping)
    Path p2 = Path();
    p2.moveTo(18, 60); p2.lineTo(37, 60); p2.lineTo(37, 15); p2.lineTo(27.5, 0); p2.lineTo(18, 15); p2.close();
    canvas.drawPath(p2, woodPaint);
    canvas.drawLine(Offset(22, 15), Offset(22, 60), streakPaint);
    canvas.drawLine(Offset(28, 25), Offset(28, 60), streakPaint);
    canvas.drawLine(Offset(33, 15), Offset(33, 60), streakPaint);

    // Ropes tying them tightly
    canvas.drawLine(Offset(2, 40), Offset(55, 43), ropePaint);
    canvas.drawLine(Offset(2, 45), Offset(55, 48), ropePaint);
    canvas.drawLine(Offset(2, 50), Offset(55, 53), ropePaint);
    
    final image = await recorder.endRecording().toImage(60, 60);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    File('assets/images/obstacle_ground.png').writeAsBytesSync(byteData!.buffer.asUint8List());
  });
}
