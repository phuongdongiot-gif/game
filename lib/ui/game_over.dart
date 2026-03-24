import 'package:flutter/material.dart';
import '../game/runner_game.dart';

class GameOver extends StatelessWidget {
  final RunnerGame game;

  const GameOver({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.redAccent, width: 8),
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
            const Text(
              'ỐI! TIÊU RỒI',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Colors.redAccent,
                letterSpacing: 2,
                shadows: [
                  Shadow(color: Colors.black12, offset: Offset(3, 3), blurRadius: 2)
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueAccent, width: 3),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sports_score, color: Colors.blueAccent, size: 32),
                      const SizedBox(width: 10),
                      Text(
                        'Điểm: ${game.currentScore.toInt()}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        'Kỷ lục: ${game.highScore}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: game.startGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    backgroundColor: Colors.green,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    side: const BorderSide(color: Colors.lightGreen, width: 4),
                  ),
                  child: Row(
                    children: const [
                      Text('CHƠI LẠI', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                      SizedBox(width: 8),
                      Icon(Icons.refresh, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: game.resetToMenu,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    backgroundColor: Colors.orange,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    side: const BorderSide(color: Colors.deepOrange, width: 4),
                  ),
                  child: Row(
                    children: const [
                      Text('MENU', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                      SizedBox(width: 8),
                      Icon(Icons.home, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
