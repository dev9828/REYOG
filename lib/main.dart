import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme.dart';
import 'view_models/gold_view_model.dart';
import 'views/splash/splash_screen.dart';
import 'views/login/login_page.dart';
import 'views/login/signup_page.dart';
import 'views/login/registration_page.dart';
import 'views/login/create_password_page.dart';
import 'views/login/forgot_password_page.dart';
import 'views/login/otp_verification_page.dart';
import 'views/home/home_page.dart';
import 'views/home/spin_wheel_page.dart'; // new hub + spinner
import 'views/home/identify_things_page.dart';
import 'views/home/quiz_game_page.dart';
import 'views/home/why_reyogo_page.dart';
import 'core/navigation_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GoldViewModel())],
      child: const ReyogoApp(),
    ),
  );
}

class ReyogoApp extends StatelessWidget {
  const ReyogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Reyogo',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),
        '/register': (_) => const RegistrationPage(),
        '/create_password': (_) => const CreatePasswordPage(),
        '/forgot': (_) => const ForgotPasswordPage(),
        '/otp': (_) => const OtpVerificationPage(),
        '/home': (_) => const HomePage(),
        // new game routes
        '/games': (_) => const SpinWheelPage(),
        '/identify_things': (_) => const IdentifyThingsPage(),
        '/quiz_game': (_) => const QuizGamePage(),
        '/why_reyogo': (_) => const WhyReyogoPage(),
      },
    );
  }
}
