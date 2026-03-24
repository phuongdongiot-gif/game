import 'package:flutter/material.dart';
import '../game/runner_game.dart';

class MainMenu extends StatelessWidget {
  final RunnerGame game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.orangeAccent, width: 8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, 10),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.directions_run, color: Colors.blueAccent, size: 48),
                const SizedBox(width: 10),
                const Text(
                  'ENDLESS\nRUNNER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.blueAccent,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: Colors.black12,
                        offset: Offset(3, 3),
                        blurRadius: 2,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.videogame_asset, color: Colors.blueAccent, size: 48),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange, width: 3),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.deepOrange, size: 28),
                  const SizedBox(width: 5),
                  Text(
                    'High Score: ${game.highScore}',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: game.startGame,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                side: const BorderSide(color: Colors.lightGreen, width: 4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'PLAY!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Bấm để Nhảy\nVuốt xuống để Trượt',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54, 
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
