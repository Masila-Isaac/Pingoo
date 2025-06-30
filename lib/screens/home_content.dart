import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pinngo/screens/eliminated_screen.dart';
import 'package:pinngo/screens/prize_screen.dart';

class GameScreen extends StatefulWidget {
  final int initialPoints;

  const GameScreen({super.key, this.initialPoints = 0});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late int totalPoints;
  double distance = 0;
  double speed = 100;
  late Stopwatch stopwatch;

  late AnimationController flyController;
  late AnimationController bobbingController;

  double birdX = 0;
  double birdY = 0;
  Timer? movementTimer;
  bool isFlying = false;

  @override
  void initState() {
    super.initState();
    totalPoints = widget.initialPoints; // Initialize from passed-in points

    stopwatch = Stopwatch();

    flyController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    bobbingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  void startFlying() {
    setState(() {
      birdX = 0;
      birdY = 0;
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final maxX = screenWidth - 80;

    distance = 0;
    speed = 100 + Random().nextInt(100).toDouble(); // Between 100-200 m/s
    stopwatch.reset();
    stopwatch.start();
    isFlying = true;

    movementTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (birdX < maxX) {
          birdX += 5;
        } else {
          birdX = maxX;
        }
        birdY -= 3;
        birdY = birdY.clamp(-100.0, 0.0);
      });
    });
  }

  void stopFlying() {
    stopwatch.stop();
    isFlying = false;
    movementTimer?.cancel();

    double seconds = stopwatch.elapsedMilliseconds / 1000.0;
    distance = speed * seconds;

    int earnedPoints = 0;
    if (distance >= 950 && distance <= 999) {
      earnedPoints = 35;
    } else if (distance == 1000) {
      earnedPoints = 100;
    } else if (distance >= 1001 && distance <= 1050) {
      earnedPoints = 25;
    } else if (distance >= 900 && distance < 950) {
      earnedPoints = 25;
    } else if (distance >= 800 && distance < 900) {
      earnedPoints = 12;
    } else if (distance >= 700 && distance < 800) {
      earnedPoints = 5;
    }

    setState(() {
      totalPoints += earnedPoints;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FailedScreen(
          distanceCovered: distance.toInt(),
          points: totalPoints, // Pass updated points
        ),
      ),
    );
  }

  void toggleFly() {
    if (!isFlying) {
      startFlying();
    } else {
      stopFlying();
    }
  }

  @override
  void dispose() {
    flyController.dispose();
    bobbingController.dispose();
    movementTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bobbing = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(bobbingController);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pinngo"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrizeScreen()),
              );
            },
            child: const Text(
              "Prize Shop",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "pingo ksh 40.000",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add redemption logic if needed
                },
                child: const Text("Redeem"),
              ),
              const SizedBox(height: 20),
              const Text(
                "OM",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Bird animation
              AnimatedBuilder(
                animation: bobbing,
                builder: (_, __) {
                  return Transform.translate(
                    offset: Offset(
                      birdX,
                      birdY + (isFlying ? bobbing.value : 0),
                    ),
                    child: Image.asset(
                      'assets/bird.png',
                      width: 80,
                      height: 80,
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
              const Text(
                "Press Fly to start",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFlying ? Colors.grey : Colors.red,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                onPressed: toggleFly,
                child: Text(
                  isFlying ? "Flying..." : "Fly",
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              const Spacer(),
              Container(
                height: 70,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                color: Colors.blue[100],
                child: const Center(child: Text("enjoy your stay here!")),
              ),
            ],
          ),
          // Points display
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: Text(
                'Points: $totalPoints',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
