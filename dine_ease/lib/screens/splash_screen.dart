import 'package:dine_ease/screens/welcome.dart';
// import 'package:dine_ease/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreen extends StatelessWidget{
  static const routeName = '/';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splash: Image.asset('assets/images/logo.png',
        alignment: Alignment.center,
        scale: 2,
      ),
      nextScreen: const WelcomeScreen(),
      splashTransition: SplashTransition.fadeTransition,

    );
  }
}