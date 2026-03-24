# Upgrade Graphics and Audio

This plan covers upgrading the visual quality from simple colored shapes to proper 2D game sprites, and adding sound effects for player actions and game events.

## Proposed Changes

### Assets Generation
- Use AI image generation to create a seamless background, a player sprite, and obstacle sprites.
- Use a Python script to synthesize simple `jump.wav`, `hit.wav`, and `score.wav` sound effects.

### Configuration
#### [MODIFY] pubspec.yaml
Add `assets/images/` and `assets/audio/` to the flutter assets section.

### Game Components
#### [MODIFY] lib/game/background.dart
Change [GameBackground](file:///c:/Users/catmu/Downloads/flam/lib/game/background.dart#5-20) to use Flame's `ParallaxComponent` for a scrolling background effect.

#### [MODIFY] lib/game/player.dart
Change [Player](file:///c:/Users/catmu/Downloads/flam/lib/game/player.dart#7-108) from `RectangleComponent` to `SpriteComponent` (or `SpriteAnimationComponent` if we decide to do basic manual animation by scaling/rotating). Since we'll generate simple sprites, we can just use `SpriteComponent`.
Add slide state visual changes.

#### [MODIFY] lib/game/obstacle.dart
Change [Obstacle](file:///c:/Users/catmu/Downloads/flam/lib/game/obstacle.dart#8-47) from `RectangleComponent` to `SpriteComponent`. Assign different sprites based on `ObstacleType`.

#### [MODIFY] lib/game/runner_game.dart
Initialize audio caching via `flame_audio`. Add method calls to play jump, score, and game over sounds.

## Verification Plan
### Manual Verification
- Run the Flutter app (`flutter run -d windows`) to ensure sprites load, background scrolls, and sounds play without crashes.
