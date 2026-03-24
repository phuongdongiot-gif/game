import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'runner_game.dart';
import 'obstacle.dart';
import 'projectile.dart';
import 'platform.dart';

enum PlayerState { run, jump, slide }

class Player extends SpriteAnimationGroupComponent<PlayerState> with CollisionCallbacks, HasGameRef<RunnerGame> {
  static const double playerWidth = 80.0;
  static const double playerHeight = 80.0;
  static const double slideHeight = 50.0;

  double velocityY = 0.0;
  final double gravity = 1800.0;
  final double jumpPower = -700.0;
  bool isJumping = false;
  bool isOnGround = false;
  
  double slideTimer = 0.0;
  bool isSliding = false;

  late RectangleHitbox hitbox;

  Player() : super(size: Vector2(playerWidth, playerHeight));

  @override
  Future<void> onLoad() async {
    final image = await gameRef.images.load('player_spritesheet.png');
    final frameWidth = 80.0;
    final frameHeight = 80.0;
    final textureSize = Vector2(frameWidth, frameHeight);

    final runAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.06,
        textureSize: textureSize,
      ),
    );

    final jumpAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1.0,
        textureSize: textureSize,
        texturePosition: Vector2(frameWidth * 8, 0),
      ),
    );

    final slideAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1.0,
        textureSize: Vector2(frameWidth, 50),
        texturePosition: Vector2(frameWidth * 9, 30),
      ),
    );

    animations = {
      PlayerState.run: runAnimation,
      PlayerState.jump: jumpAnimation,
      PlayerState.slide: slideAnimation,
    };
    current = PlayerState.run;
    
    hitbox = RectangleHitbox(
      position: Vector2(25, 15),
      size: Vector2(30, 65),
    );
    add(hitbox);
    reset();
  }

  void reset() {
    position = Vector2(100, gameRef.size.y - 300);
    size = Vector2(playerWidth, playerHeight);
    velocityY = 0;
    isJumping = false;
    isOnGround = false;
    isSliding = false;
    slideTimer = 0;
    current = PlayerState.run;
    hitbox.position = Vector2(25, 15);
    hitbox.size = Vector2(30, 65);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameRef.gameState != GameState.playing) return;

    if (!isOnGround) {
      velocityY += gravity * dt;
    } else {
      velocityY = 0; // Don't build up gravity while supported
    }
    position.y += velocityY * dt;

    isOnGround = false; // Reset for this frame collision checks

    if (position.y > gameRef.size.y + 50) {
      gameRef.gameOver();
    }

    // Sliding logic
    if (isSliding) {
      slideTimer -= dt;
      if (slideTimer <= 0) {
        // End slide
        isSliding = false;
        size = Vector2(playerWidth, playerHeight);
        position.y -= (playerHeight - slideHeight); // adjust back up
        hitbox.position = Vector2(25, 15);
        hitbox.size = Vector2(30, 65);
        if (!isJumping) current = PlayerState.run;
      }
    }
  }

  void jump() {
    if (isOnGround && !isJumping) {
      FlameAudio.play('jump.wav');
      velocityY = jumpPower;
      isJumping = true;
      isOnGround = false; // Add this line to prevent velocity reset
      current = PlayerState.jump;
      if (isSliding) {
        isSliding = false;
        slideTimer = 0;
        size = Vector2(playerWidth, playerHeight);
        position.y -= (playerHeight - slideHeight); // adjust back up
        hitbox.position = Vector2(25, 15);
        hitbox.size = Vector2(30, 65);
      }
    }
  }

  void slide() {
    if (!isJumping && !isSliding) {
      isSliding = true;
      slideTimer = 0.8; 
      size = Vector2(playerWidth, slideHeight);
      position.y += (playerHeight - slideHeight);
      hitbox.position = Vector2(10, 10); 
      hitbox.size = Vector2(60, 30);
      current = PlayerState.slide;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Obstacle || other is Projectile) {
      gameRef.gameOver();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    
    if (other is GamePlatform) {
      if (velocityY >= 0) {
        double platformTop = other.position.y;
        
        // Allows the player to embed slightly so onCollision keeps firing next frame
        if (position.y + size.y - 40 <= platformTop) {
           position.y = platformTop - size.y + 1; // 1 pixel overlap
           velocityY = 0;
           isOnGround = true;
           if (isJumping) {
             isJumping = false;
             if (!isSliding) current = PlayerState.run;
           }
        }
      }
    }
  }
}
