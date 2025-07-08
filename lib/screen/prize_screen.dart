import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'board_screen.dart';
import 'profile_screen.dart';

class Prize_screne extends StatefulWidget {
  const Prize_screne({super.key});

  @override
  State<Prize_screne> createState() => _Prize_screneState();
}

class _Prize_screneState extends State<Prize_screne> {
  final int _currentIndex = 2;

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

  final List<Prize> prizes = [
    Prize(name: 'Prize 1', pointsNeeded: 100),
    Prize(name: 'Prize 2', pointsNeeded: 200),
    Prize(name: 'Prize 3', pointsNeeded: 300),
    Prize(name: 'Prize 4', pointsNeeded: 400),
    Prize(name: 'Prize 5', pointsNeeded: 500),
    Prize(name: 'Prize 6', pointsNeeded: 600),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prizes List')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: prizes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            final prize = prizes[index];
            return Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      prize.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Points Needed: ${prize.pointsNeeded}'),
                  ],
                ),
              ),
            );
          },
        ),
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

class Prize {
  final String name;
  final int pointsNeeded;

  Prize({required this.name, required this.pointsNeeded});
}
