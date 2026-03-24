# Implementation Plan: Flutter Endless Runner Game

This document outlines the implementation strategy for an endless runner game built with Flutter and Flame.

## Proposed Changes

### Project Initialization
- Create a new Flutter project in the current directory (`flutter create .`).
- Update `pubspec.yaml` to include `flame` and `shared_preferences` dependencies.

---

### Core Game Engine
#### [NEW] lib/main.dart
- Entry point of the app.
- Initializes `WidgetsFlutterBinding` and handles `SharedPreferences` injection.
- Runs `GameWidget` with overlay configurations for `MainMenu`, `GameOver`, and `HUD`.

#### [NEW] lib/game/runner_game.dart
- The core `FlameGame` extending `HasCollisionDetection` and `TapCallbacks`/`DragCallbacks`.
- **Properties**: `currentScore`, `highScore`, `gameSpeed`, `GameState` (menu, playing, game over).
- **Methods**: `startGame`, `gameOver`, `reset`, `update` (for increasing difficulty).
- **Children**: Background, Player, Obstacle Spawner.

---

### Game Components
#### [NEW] lib/game/player.dart
- Extends `PositionComponent` with `CollisionCallbacks` (we will use simple primitive shapes instead of sprites to keep it minimal but will implement logic so sprite animations can be swapped in).
- **Properties**: `velocity` (Y-axis), `gravity`, `jumpSpeed`.
- **States**: Running, Jumping, Sliding. Sliding temporarily adjusts the hitbox height.
- **Controls**: `jump()` (triggered by tap), `slide()` (triggered by swipe down).

#### [NEW] lib/game/obstacle.dart
- Extends `PositionComponent`.
- Moves leftward each frame (`x -= speed * dt`).
- Two variants:
  - **Ground**: Needs jumping over.
  - **Air**: Needs sliding under.
- Once off-screen, it removes itself.

#### [NEW] lib/game/obstacle_manager.dart
- A component managing the randomized spawning of obstacles over time.
- Decreases spawn interval as game speed increases.

#### [NEW] lib/game/background.dart
- Uses `ParallaxComponent` to render scrolling geometric layers simulating a landscape.

---

### User Interface (Overlays)
#### [NEW] lib/ui/main_menu.dart
- Flutter `StatelessWidget`.
- Shows Title, Highest Score (from SharedPreferences), and a Start Button.

#### [NEW] lib/ui/game_over.dart
- Flutter `StatelessWidget`.
- Shows "Game Over", Final Score, High Score, and Restart/Menu Button.

#### [NEW] lib/ui/hud.dart
- Real-time score overlay pinned to the top.

---

## Verification Plan

### Automated Tests
*Skipping complex unit tests as UI/Flame physics heavily rely on manual interaction and visual accuracy.*

### Manual Verification
1. Open the project in a supported IDE or terminal.
2. Ensure you have a device connected (Chrome, Windows Desktop, or Mobile Simulator).
3. Run `flutter run` or `flutter run -d chrome`.
4. **Test Menu**: Verify the Game Menu shows properly with a default High Score of 0.
5. **Test Gameplay**: 
   - Tap "Start". The player should automatically run and score should increase.
   - Tap to jump over ground obstacles.
   - Swipe down (or hold) to slide under air obstacles.
   - Observe the speed gradually increasing over time.
6. **Test Game Over**: Collide with an obstacle. The collision should trigger the Game Over screen.
7. **Test High Score Persistence**: If the final score is > High Score, it should update. Restarting the game completely should retain this high score.
