import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game/runner_game.dart';
import 'ui/main_menu.dart';
import 'ui/game_over.dart';
import 'ui/hud.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const EndlessRunnerApp());
}

class EndlessRunnerApp extends StatelessWidget {
  const EndlessRunnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Endless Runner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<RunnerGame>(
        game: RunnerGame(),
        overlayBuilderMap: {
          'MainMenu': (context, game) => MainMenu(game: game),
          'GameOver': (context, game) => GameOver(game: game),
          'HUD': (context, game) => HUD(game: game),
        },
        initialActiveOverlays: const ['MainMenu'],
      ),
    );
  }
}
