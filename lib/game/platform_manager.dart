import 'dart:math';
import 'package:flame/components.dart';
import 'runner_game.dart';
import 'platform.dart';

class PlatformManager extends Component with HasGameRef<RunnerGame> {
  double currentX = 0;
  double lastY = 0;
  final Random random = Random();

  void reset() {
    gameRef.children.whereType<GamePlatform>().forEach((p) => p.removeFromParent());
    lastY = gameRef.size.y - 120; // Default elevated ground
    currentX = -100; // Start slightly offscreen left
    _spawnPlatform(gameRef.size.x + 800, lastY); 
  }

  void _spawnPlatform(double width, double y) {
    gameRef.add(
      GamePlatform(
        position: Vector2(currentX, y), 
        size: Vector2(width, gameRef.size.y - y + 200)
      )
    );
    currentX += width;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.gameState != GameState.playing) return;

    currentX -= gameRef.gameSpeed * dt;

    if (currentX < gameRef.size.x + 600) {
      // 15% chance for a pit
      if (random.nextDouble() < 0.15) {
        double gap = random.nextDouble() * 80 + 90; // 90-170px gap
        currentX += gap;
      }

      // Height variation for stairs (less aggressive)
      double yChange = (random.nextDouble() - 0.5) * 100; 
      lastY += yChange;
      
      // Clamp Y to safe screen values
      double minY = gameRef.size.y - 300;
      double maxY = gameRef.size.y - 80;
      if (lastY < minY) lastY = minY;
      if (lastY > maxY) lastY = maxY;

      double width = random.nextDouble() * 400 + 300; // 300-700px width
      _spawnPlatform(width, lastY);
    }
  }
}
