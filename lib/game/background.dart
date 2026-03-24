import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'runner_game.dart';

class GameBackground extends ParallaxComponent<RunnerGame> {
  @override
  Future<void> onLoad() async {
    parallax = await game.loadParallax(
      [ParallaxImageData('background.png')],
      baseVelocity: Vector2(50, 0),
      velocityMultiplierDelta: Vector2(1.0, 1.0),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.gameState == GameState.playing) {
      parallax?.baseVelocity = Vector2(game.gameSpeed * 0.5, 0);
    } else {
      parallax?.baseVelocity = Vector2.zero();
    }
  }
}
