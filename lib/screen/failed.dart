import 'package:flutter/material.dart';
import 'package:pingoo/screen/game_screen.dart';
import 'package:pingoo/screen/home_screen.dart';

class FailedScreen extends StatelessWidget {
  final int distanceCovered;
  final int points;

  const FailedScreen({
    super.key,
    required this.distanceCovered,
    required this.points,
  }) : assert(distanceCovered >= 0, 'Distance covered must be non-negative'),
       assert(points >= 0, 'Points must be non-negative');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Oops!"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bird image
              Image.asset('assets/bird.png', width: 150, height: 150),
              const SizedBox(height: 20),

              // Main message
              const Text(
                "Oops! That is a wrong Stop.",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              // Distance covered
              Text(
                'You covered $distanceCovered meters.',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),

              // Total points
              const SizedBox(height: 10),
              Text(
                'Total Points: $points',
                style: const TextStyle(fontSize: 16, color: Colors.green),
                textAlign: TextAlign.center,
              ),

              // Encourage retry if distance was too short
              if (distanceCovered < 1000) ...[
                const SizedBox(height: 10),
                const Text(
                  'You need to reach at least 1000 meters.',
                  style: TextStyle(fontSize: 16, color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Keep trying! You can do it.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 30),

              // Retry button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        initialPoints: points,
                      ), // ✅ Pass points back
                    ),
                  );
                },
                child: const Text(
                  "Let's TRY again",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final int initialPoints;

  const HomeScreen({super.key, this.initialPoints = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Welcome! Points: $initialPoints',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
