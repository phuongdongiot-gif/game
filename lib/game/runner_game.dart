import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import '../main.dart'; // for prefs
import 'player.dart';
import 'background.dart';
import 'obstacle_manager.dart';
import 'package:flame_audio/flame_audio.dart';
import 'platform_manager.dart';

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

    await FlameAudio.audioCache.loadAll(['jump.wav', 'hit.wav', 'score.wav']);

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
    FlameAudio.play('hit.wav');
    if (currentScore.toInt() > highScore) {
      highScore = currentScore.toInt();
      prefs.setInt('highScore', highScore);
    }
    overlays.remove('HUD');
    overlays.add('GameOver');
  }

  void resetToMenu() {
    gameState = GameState.menu;
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
