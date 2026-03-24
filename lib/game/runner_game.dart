import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import '../main.dart'; // for prefs
import 'player.dart';
import 'background.dart';
import 'obstacle_manager.dart';
import 'platform_manager.dart';
import 'package:flame/particles.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flame_audio/flame_audio.dart';

enum GameState { menu, playing, gameOver }

class RunnerGame extends FlameGame with HasCollisionDetection, TapDetector, VerticalDragDetector {
  late Player player;
  late GameBackground background;
  late ObstacleManager obstacleManager;
  late PlatformManager platformManager;
  
  GameState gameState = GameState.menu;
  double currentScore = 0;
  ValueNotifier<int> scoreNotifier = ValueNotifier(0);
  double gameSpeed = 300.0;
  final double baseSpeed = 300.0;
  int highScore = 0;

  @override
  Future<void> onLoad() async {
    highScore = prefs.getInt('highScore') ?? 0;

    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(['jump.wav', 'hit.wav', 'score.wav', 'bgm.wav', 'death_music.wav']);

    background = GameBackground();
    add(background);

    platformManager = PlatformManager();
    add(platformManager);

    player = Player();
    add(player);

    obstacleManager = ObstacleManager();
    add(obstacleManager);
  }

  void startGame() {
    gameState = GameState.playing;
    currentScore = 0;
    scoreNotifier.value = 0;
    gameSpeed = baseSpeed;
    
    FlameAudio.bgm.play('bgm.wav', volume: 0.25);
    
    platformManager.reset();
    player.reset();
    obstacleManager.reset();
    overlays.remove('MainMenu');
    overlays.remove('GameOver');
    overlays.add('HUD');
  }

  void gameOver() {
    if (gameState == GameState.gameOver) return;
    gameState = GameState.gameOver;
    FlameAudio.play('death_music.wav');
    FlameAudio.bgm.stop();
    
    // Nổ ánh sao 
    final random = Random();
    add(ParticleSystemComponent(
      particle: Particle.generate(
        count: 30, // 30 ngôi sao
        lifespan: 1.2,
        generator: (i) {
          final speed = random.nextDouble() * 300 + 100;
          final angle = random.nextDouble() * 2 * pi;
          final velocity = Vector2(cos(angle), sin(angle)) * speed;
          
          return AcceleratedParticle(
            position: player.position.clone() + player.size / 2, // Xuất phát từ giữa nhân vật
            speed: velocity,
            child: ComputedParticle(
              renderer: (canvas, particle) {
                final opacity = 1.0 - particle.progress;
                final paint = Paint()..color = Colors.amberAccent.withOpacity(opacity);
                final r = 6.0 * opacity + 2.0; 
                
                // Vẽ path ngôi sao 5 cánh
                Path starPath = Path();
                double outer = r * 2;
                double inner = r;
                for (int j = 0; j < 5; j++) {
                  double a1 = (-pi/2) + j * (2*pi/5);
                  double a2 = (-pi/2) + j * (2*pi/5) + (pi/5);
                  if (j == 0) {
                    starPath.moveTo(cos(a1) * outer, sin(a1) * outer);
                  } else {
                    starPath.lineTo(cos(a1) * outer, sin(a1) * outer);
                  }
                  starPath.lineTo(cos(a2) * inner, sin(a2) * inner);
                }
                starPath.close();
                canvas.drawPath(starPath, paint);
              }
            ),
          );
        },
      ),
    ));

    // Giấu nhân vật đi
    player.die();

    if (currentScore.toInt() > highScore) {
      highScore = currentScore.toInt();
      prefs.setInt('highScore', highScore);
    }
    overlays.remove('HUD');
    overlays.add('GameOver');
  }

  void resetToMenu() {
    gameState = GameState.menu;
    FlameAudio.bgm.stop();
    platformManager.reset();
    player.reset();
    obstacleManager.reset();
    overlays.remove('GameOver');
    overlays.add('MainMenu');
  }

  @override
  void update(double dt) {
    if (gameState == GameState.playing) {
      int prevScore = scoreNotifier.value;
      currentScore += dt * 10;
      int newScore = currentScore.toInt();
      scoreNotifier.value = newScore;
      gameSpeed += dt * 2; // Difficulty scaling

      if (newScore > prevScore && newScore % 100 == 0 && newScore > 0) {
        FlameAudio.play('score.wav');
      }
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (gameState == GameState.playing) {
      player.jump();
    }
  }

  @override
  void onVerticalDragUpdate(DragUpdateInfo info) {
    if (gameState == GameState.playing && info.delta.global.y > 5) {
      player.slide();
    }
  }
}
