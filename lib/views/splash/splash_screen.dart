import 'dart:async';
import 'package:flutter/material.dart';
import '../home/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _controller.drive(Tween(begin: 0.4, end: 1.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.monetization_on, size: 96, color: Colors.white),
              SizedBox(height: 18),
              Text('REYOGO', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 18),
              Text('Hey Devendra!', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text('Let\'s start savings', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
