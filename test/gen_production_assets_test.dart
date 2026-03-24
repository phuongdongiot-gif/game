import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generate production assets', () async {
    // 1. App Icon (1024x1024)
    final recorderIcon = PictureRecorder();
    final canvasIcon = Canvas(recorderIcon, Rect.fromLTWH(0, 0, 1024, 1024));
    
    // Background gradient (Cyan to Blue)
    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.cyanAccent.shade700, Colors.blue.shade900],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, 1024, 1024));
    canvasIcon.drawRect(Rect.fromLTWH(0, 0, 1024, 1024), bgPaint);
    
    // Big Goofy Blob Face
    final bodyPaint = Paint()..color = const Color(0xFF00B0FF); // Light Blue
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;
    final tonguePaint = Paint()..color = const Color(0xFFFF5252);
    
    canvasIcon.drawOval(Rect.fromLTWH(150, 180, 724, 724), bodyPaint); // Face
    // Shadow under eyes
    canvasIcon.drawOval(Rect.fromLTWH(340, 390, 170, 200), Paint()..color = Colors.black26);
    canvasIcon.drawOval(Rect.fromLTWH(540, 340, 200, 240), Paint()..color = Colors.black26);
    
    // Eyes
    canvasIcon.drawOval(Rect.fromLTWH(350, 400, 150, 180), eyePaint);
    canvasIcon.drawOval(Rect.fromLTWH(550, 350, 180, 220), eyePaint);
    // Pupils
    canvasIcon.drawOval(Rect.fromLTWH(420, 480, 50, 50), pupilPaint);
    canvasIcon.drawOval(Rect.fromLTWH(620, 460, 40, 40), pupilPaint);
    
    // Mouth
    Path mouth = Path();
    mouth.moveTo(380, 680);
    mouth.quadraticBezierTo(512, 850, 644, 680);
    canvasIcon.drawPath(mouth, Paint()..color=const Color(0xFF37474F)..style=PaintingStyle.stroke..strokeWidth=30..strokeCap = StrokeCap.round);
    canvasIcon.drawArc(Rect.fromLTWH(460, 700, 100, 120), 0, 3.14159, true, tonguePaint);
    
    final imageIcon = await recorderIcon.endRecording().toImage(1024, 1024);
    final byteDataIcon = await imageIcon.toByteData(format: ImageByteFormat.png);
    File('assets/images/app_icon.png').writeAsBytesSync(byteDataIcon!.buffer.asUint8List());

    // 2. Splash Logo (Transparant 512x512)
    final recorderSplash = PictureRecorder();
    final canvasSplash = Canvas(recorderSplash, Rect.fromLTWH(0, 0, 512, 512));
    
    canvasSplash.translate(0, -30); // Move face up
    canvasSplash.scale(0.5); // Shrink to fit 512
    
    canvasSplash.drawOval(Rect.fromLTWH(150, 180, 724, 724), bodyPaint); // Face
    canvasSplash.drawOval(Rect.fromLTWH(350, 400, 150, 180), eyePaint);
    canvasSplash.drawOval(Rect.fromLTWH(550, 350, 180, 220), eyePaint);
    canvasSplash.drawOval(Rect.fromLTWH(420, 480, 50, 50), pupilPaint);
    canvasSplash.drawOval(Rect.fromLTWH(620, 460, 40, 40), pupilPaint);
    canvasSplash.drawPath(mouth, Paint()..color=const Color(0xFF37474F)..style=PaintingStyle.stroke..strokeWidth=30..strokeCap = StrokeCap.round);
    canvasSplash.drawArc(Rect.fromLTWH(460, 700, 100, 120), 0, 3.14159, true, tonguePaint);
    
    final imageSplash = await recorderSplash.endRecording().toImage(512, 512);
    final byteDataSplash = await imageSplash.toByteData(format: ImageByteFormat.png);
    File('assets/images/splash_logo.png').writeAsBytesSync(byteDataSplash!.buffer.asUint8List());
  });
}
