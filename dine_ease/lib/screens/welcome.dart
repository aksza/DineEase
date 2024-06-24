
import 'package:dine_ease/screens/login.dart';
import 'package:dine_ease/screens/sign_up.dart';
import 'package:dine_ease/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  bool showUserAndRestaurantButtons = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  alignment: Alignment.center,
                  width: 100,
                  height: 100
                ),
                const SizedBox(height: 50),
                Text(
                  "Welcome to DineEase!",
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: 'Login',
                  onTap: () {
                    Navigator.of(context).pushNamed(LoginScreen.routeName);
                  },
                ),
                const SizedBox(height: 10),
                MyButton(
                  text: 'Sign Up',
                  onTap: () {
                    Navigator.of(context).pushNamed(SignUpScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
