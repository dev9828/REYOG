import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'view_models/gold_view_model.dart';
import 'views/splash/splash_screen.dart';
import 'views/login/login_page.dart';
import 'views/login/signup_page.dart';
import 'views/home/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoldViewModel()),
      ],
      child: const ReyogoApp(),
    ),
  );
}

class ReyogoApp extends StatelessWidget {
  const ReyogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reyogo Gold',
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),
        '/splash': (_) => const SplashScreen(),
        '/home': (_) => const HomePage(),
      },
    );
  }
}
