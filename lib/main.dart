import 'package:flutter/material.dart';
import 'package:pinngo/screens/game_screen.dart';
import 'package:pinngo/screens/login.dart';
import 'package:pinngo/screens/signup.dart';

void main() {
  runApp(const FlyGameApp());
}

class FlyGameApp extends StatelessWidget {
  const FlyGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SignupScreen());
  }
}
