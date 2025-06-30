import 'package:flutter/material.dart';
import 'package:pinngo/screens/onboarding_screen.dart';

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
