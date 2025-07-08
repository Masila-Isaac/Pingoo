import 'package:flutter/material.dart';
import 'package:pingoo/screen/game_screen.dart';
import 'package:pingoo/screen/onboarding_screen.dart';
import 'package:pingoo/screen/psss.dart';

void main() {
  runApp(const FlyGameApp());
}

class FlyGameApp extends StatelessWidget {
  const FlyGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}
