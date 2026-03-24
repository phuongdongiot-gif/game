import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'runner_game.dart';

class GamePlatform extends PositionComponent with HasGameRef<RunnerGame> {
  GamePlatform({required Vector2 position, required Vector2 size}) 
    : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  final Paint grassPaint = Paint()..color = const Color(0xFF64DD17); // Lush Green
  final Paint dirtTopPaint = Paint()..color = const Color(0xFF795548); // Brown
  final Paint dirtMidPaint = Paint()..color = const Color(0xFF5D4037); // Darker Brown
  final Paint dirtBottomPaint = Paint()..color = const Color(0xFF4E342E); // Deep Brown
  final Paint rockPaint = Paint()..color = const Color(0xFF3E2723); // Almost black rocks

  @override
  void render(Canvas canvas) {
    // Dirt Strata (Layers)
    canvas.drawRect(Rect.fromLTWH(0, 15, size.x, 30), dirtTopPaint);
    canvas.drawRect(Rect.fromLTWH(0, 45, size.x, 40), dirtMidPaint);
    canvas.drawRect(Rect.fromLTWH(0, 85, size.x, size.y - 85), dirtBottomPaint);

    // Grass Top Base
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, 15), grassPaint);
    
    // Grass Frills (zig zag overlapping dirt)
    Path grassFringe = Path();
    grassFringe.moveTo(0, 15);
    for (double i = 0; i < size.x; i += 15) {
       grassFringe.lineTo(i + 7.5, 25); // Point down
       grassFringe.lineTo(i + 15, 15);  // Point back up
    }
    grassFringe.lineTo(size.x, 0);
    grassFringe.lineTo(0, 0);
    grassFringe.close();
    canvas.drawPath(grassFringe, grassPaint);

    // Embedded Rocks (Procedurally placed based on constant size)
    for (double dx = 10; dx < size.x; dx += 60) {
      canvas.drawOval(Rect.fromLTWH(dx, 35, 10, 8), rockPaint); // Top dirt rocks
      canvas.drawOval(Rect.fromLTWH(dx + 30, 65, 8, 6), rockPaint); // Mid dirt rocks
      canvas.drawOval(Rect.fromLTWH(dx + 15, 100, 14, 10), rockPaint); // Deep dirt bigger rocks
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.gameState == GameState.playing) {
      position.x -= gameRef.gameSpeed * dt;
      if (position.x + size.x < 0) {
        removeFromParent();
      }
    }
  }
}
