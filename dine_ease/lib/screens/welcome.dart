
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
                //logo
                Image.asset(
                  'assets/images/logo.png',
                  alignment: Alignment.center,
                  width: 100,
                  height: 100
                ),
                //space between
                const SizedBox(height: 50),
                //welcome message
                Text(
                  "Welcome to DineEase!",
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                //space between
                const SizedBox(height: 25),
                //login button
                MyButton(
                  text: 'Login',
                  onTap: () {
                    //megjeleniti a login screen-t
                    Navigator.of(context).pushNamed(LoginScreen.routeName);
                  },
                ),
                //space between
                const SizedBox(height: 10),
                //register button
                MyButton(
                  text: 'Sign Up',
                  onTap: () {
                    //eloszor a user sign up-ra iranyit
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
