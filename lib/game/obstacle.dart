import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'runner_game.dart';
import 'projectile.dart';

enum ObstacleType { ground, air }

class Obstacle extends SpriteAnimationComponent with HasGameRef<RunnerGame> {
  final ObstacleType type;
  final double groundY;
  double time = 0.0;
  double shootTimer = 0.0;
  double nextShootDelay = 1.5;
  double baseY = 0.0;
  final Random random = Random();

  Obstacle(this.type, this.groundY) : super();

  @override
  Future<void> onLoad() async {
    if (type == ObstacleType.ground) {
      final image = await gameRef.images.load('obstacle_ground.png');
      animation = SpriteAnimation.spriteList([Sprite(image)], stepTime: 1);
      size = Vector2(60, 60);
      add(RectangleHitbox(
        position: Vector2(15, 30),
        size: Vector2(30, 30),
      ));
    } else {
      final image = await gameRef.images.load('bird_spritesheet.png');
      animation = SpriteAnimation.fromFrameData(
        image, 
        SpriteAnimationData.sequenced(amount: 4, stepTime: 0.1, textureSize: Vector2(80, 60))
      );
      size = Vector2(80, 60);
      add(RectangleHitbox(
        position: Vector2(25, 20),
        size: Vector2(30, 30),
      ));
    }
    
    if (type == ObstacleType.ground) {
      position = Vector2(gameRef.size.x, groundY - size.y);
      baseY = position.y;
    } else {
      // Air obstacle flies higher up, randomized between 80 to 200 units above ground
      double yOffset = 80 + random.nextDouble() * 120;
      position = Vector2(gameRef.size.x, groundY - size.y - yOffset); 
      baseY = position.y;
      
      // Randomize initial shoot delay so they don't sync
      shootTimer = random.nextDouble() * 1.5;
      nextShootDelay = 1.0 + random.nextDouble() * 1.5;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.gameState == GameState.playing) {
      position.x -= gameRef.gameSpeed * dt;
      
      if (type == ObstacleType.air) {
        time += dt;
        // Bobbing up and down
        position.y = baseY + sin(time * 5) * 20; 
        
        // Shooting logic with random frequency
        shootTimer += dt;
        if (shootTimer >= nextShootDelay) {
          shootTimer = 0;
          nextShootDelay = 1.0 + random.nextDouble() * 1.5; // Next shot in 1.0 to 2.5s
          gameRef.add(Projectile(
            position: Vector2(position.x, position.y + size.y / 2),
            speedX: 200.0,
          ));
        }
      }

      if (position.x + size.x < 0) {
        removeFromParent();
      }
    }
  }
}
