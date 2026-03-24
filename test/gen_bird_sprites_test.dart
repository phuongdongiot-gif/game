import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generate goofy flapping bird sprites', () async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, 320, 60));
    
    final bodyPaint = Paint()..color = const Color(0xFFFFC107); // Amber 500
    final bellyPaint = Paint()..color = const Color(0xFFFFE082); // Amber 200
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;
    final beakPaint = Paint()..color = const Color(0xFFFF5722); // Deep Orange
    final wingPaint = Paint()..color = const Color(0xFFFF9800); // Orange
    
    for (int i=0; i<4; i++) {
       double dx = i * 80.0;
       
       // Thân hình béo ú
       canvas.drawOval(Rect.fromLTWH(dx + 25, 20, 36, 32), bodyPaint);
       // Bụng bự
       canvas.drawOval(Rect.fromLTWH(dx + 30, 35, 26, 15), bellyPaint);
       
       // Đuôi lưa thưa
       Path tail = Path();
       tail.moveTo(dx + 25, 30);
       tail.lineTo(dx + 15, 20);
       tail.lineTo(dx + 20, 32);
       tail.lineTo(dx + 10, 35);
       tail.lineTo(dx + 22, 40);
       tail.close();
       canvas.drawPath(tail, wingPaint);
       
       // Lông mào trên đầu tếu táo
       Path crest = Path();
       crest.moveTo(dx + 40, 20);
       crest.lineTo(dx + 35, 8);
       crest.lineTo(dx + 43, 18);
       crest.lineTo(dx + 45, 5);
       crest.lineTo(dx + 48, 18);
       crest.lineTo(dx + 55, 10);
       crest.lineTo(dx + 50, 22);
       canvas.drawPath(crest, bodyPaint);
       
       // Hai mắt lồi lác (Googly eyes)
       canvas.drawOval(Rect.fromLTWH(dx + 48, 12, 14, 14), eyePaint); // Mắt phải to hơn
       canvas.drawOval(Rect.fromLTWH(dx + 40, 16, 12, 12), eyePaint); // Mắt trái
       
       // Tròng mắt lác
       canvas.drawOval(Rect.fromLTWH(dx + 52, 18, 4, 4), pupilPaint); // Nhìn xuống
       canvas.drawOval(Rect.fromLTWH(dx + 42, 19, 3, 3), pupilPaint); // Nhìn lên
       
       // Cái mỏ vẩu ngoác ra
       Path beak = Path();
       beak.moveTo(dx + 55, 25);
       beak.lineTo(dx + 75, 28);
       beak.lineTo(dx + 65, 38);
       beak.lineTo(dx + 50, 30);
       beak.close();
       canvas.drawPath(beak, beakPaint);
       
       // Cánh vẫy luống cuống
       double wingAngle = 0;
       if (i == 0) wingAngle = 0.8; // đập xuống
       if (i == 1) wingAngle = 0.0; // giữa
       if (i == 2) wingAngle = -0.8; // hất lên
       if (i == 3) wingAngle = 0.0; // giữa
       
       canvas.save();
       canvas.translate(dx + 38, 30);
       canvas.rotate(wingAngle);
       canvas.drawOval(Rect.fromLTWH(-12, -8, 24, 16), wingPaint);
       canvas.restore();
    }
    
    final image = await recorder.endRecording().toImage(320, 60);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    File('assets/images/bird_spritesheet.png').writeAsBytesSync(byteData!.buffer.asUint8List());
  });
}
