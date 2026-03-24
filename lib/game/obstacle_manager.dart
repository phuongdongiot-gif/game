import 'dart:math';
import 'package:flame/components.dart';
import 'runner_game.dart';
import 'obstacle.dart';
import 'projectile.dart';
import 'platform.dart';

class ObstacleManager extends Component with HasGameRef<RunnerGame> {
  double spawnTimer = 0.0;
  final Random random = Random();

  void reset() {
    spawnTimer = 0;
    // Remove all existing obstacles
    gameRef.children.whereType<Obstacle>().forEach((obstacle) {
      obstacle.removeFromParent();
    });
    // Remove projectiles
    gameRef.children.whereType<Projectile>().forEach((projectile) {
      projectile.removeFromParent();
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.gameState != GameState.playing) return;

    spawnTimer -= dt;

    if (spawnTimer <= 0) {
      // Find the platform currently at the right edge
      GamePlatform? targetPlatform;
      for (final p in gameRef.children.whereType<GamePlatform>()) {
         if (p.position.x <= gameRef.size.x && p.position.x + p.size.x >= gameRef.size.x) {
            targetPlatform = p;
            break;
         }
      }

      if (targetPlatform != null) {
        final groundY = targetPlatform.position.y;
        final isAir = random.nextDouble() < 0.3; // 30% chance for air obstacle
        final obstacle = Obstacle(isAir ? ObstacleType.air : ObstacleType.ground, groundY);
        gameRef.add(obstacle);
      }
      // If targetPlatform is null, it's a pit. We skip spawning to avoid floating ground obstacles.
      
      // Calculate next spawn time based on game speed
      final minSpawnTime = 1.0;
      final maxSpawnTime = 2.5;
      final speedFactor = 300.0 / gameRef.gameSpeed;
      spawnTimer = (random.nextDouble() * (maxSpawnTime - minSpawnTime) + minSpawnTime) * speedFactor;
    }
  }
}
