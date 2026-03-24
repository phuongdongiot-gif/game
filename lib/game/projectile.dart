import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'runner_game.dart';

class Projectile extends CircleComponent with HasGameRef<RunnerGame> {
  final double speedX;

  Projectile({required Vector2 position, required this.speedX}) 
    : super(radius: 8, position: position) {
    paint = Paint()..color = Colors.orangeAccent;
  }

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.gameState == GameState.playing) {
      position.x -= (gameRef.gameSpeed + speedX) * dt;

      if (position.x + size.x < 0) {
        removeFromParent();
      }
    }
  }
}
