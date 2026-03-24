import 'package:flutter/material.dart';
import '../game/runner_game.dart';

class HUD extends StatelessWidget {
  final RunnerGame game;

  const HUD({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 40,
      child: ValueListenableBuilder<int>(
        valueListenable: game.scoreNotifier,
        builder: (context, score, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.yellowAccent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.orange, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(2, 4),
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 32),
                const SizedBox(width: 10),
                Text(
                  '$score',
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
