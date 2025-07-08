import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pingoo/screen/eliminated_screen.dart';
import 'package:pingoo/screen/prize_screen.dart';
import 'package:pingoo/screen/rewards_screen.dart';
import 'package:pingoo/screen/board_screen.dart';
import 'package:pingoo/screen/profile_screen.dart';

class GameScreenorg extends StatefulWidget {
  final int initialPoints;

  const GameScreenorg({super.key, this.initialPoints = 0});

  @override
  State<GameScreenorg> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreenorg>
    with TickerProviderStateMixin {
  final int _currentIndex = 0;

  final List<Widget> _screens = [
    const GameScreenorg(),
    const BoardScreen(),
    const Prize_screne(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _screens[index]),
      );
    }
  }

  late int totalPoints;
  double distance = 0;
  double speed = 100;
  late Stopwatch stopwatch;

  late AnimationController bobbingController;

  double birdX = 0;
  double birdY = 0;
  Timer? movementTimer;
  bool isFlying = false;

  @override
  void initState() {
    super.initState();
    totalPoints = widget.initialPoints;
    stopwatch = Stopwatch();

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

        // as bird moves forward (right), it gradually flies upward
        final progress = birdX / maxX;
        birdY = -150 * progress; // max height change: 150 pixels upward
      });
    });
  }

  void stopFlying() {
    if (!isFlying) return;

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
          points: totalPoints,
        ),
      ),
    );
  }

  @override
  void dispose() {
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

    final screenHeight = MediaQuery.of(context).size.height;

    // The base Y position of the bird before flying upward
    final birdBaseTop = screenHeight * 0.45;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pinngo"),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      body: Column(
        children: [
          // 🧼 Top Info Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Points",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Points: $totalPoints',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Ksh 40.00",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Add redeem logic here
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text("Redeem"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "OM",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // 🕊️ Bird Flying Section
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/ground.jpg', fit: BoxFit.cover),
                AnimatedBuilder(
                  animation: bobbing,
                  builder: (_, __) {
                    return Positioned(
                      left: birdX,
                      top: birdBaseTop + birdY + (isFlying ? bobbing.value : 0),
                      child: Image.asset(
                        'assets/bird.png',
                        width: 60,
                        height: 60,
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 30,
                  left: MediaQuery.of(context).size.width / 2 - 40,
                  child: GestureDetector(
                    onTapDown: (_) => startFlying(),
                    onTapUp: (_) => stopFlying(),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isFlying ? Colors.grey : Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "Fly",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🧾 Offers Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade300, width: 1),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              child: const Center(
                child: Text(
                  "🚀 Check out our latest offers! 🎁",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        iconSize: 20,
        elevation: 2,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined),
            activeIcon: Icon(Icons.leaderboard),
            label: 'Board',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Rewards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
