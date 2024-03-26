
import 'package:dine_ease/screens/login.dart';
import 'package:dine_ease/screens/sign_up_user.dart';
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
                    setState(() {
                      showUserAndRestaurantButtons = true;
                    });
                  },
                  //megjelenit ket kisebb gombot, egyikkel user, masikkal restaurant regisztralhat
                  //ezt a ket buttont egy rowba rakom 
                ),
                const SizedBox(height: 20,),

                if (showUserAndRestaurantButtons)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        
                        Navigator.of(context).pushNamed(SignUpUserScreen.routeName);
                      },
                     
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[600], // Narancssárga szín
                        padding: EdgeInsets.fromLTRB(40,0,40,0)
                      ),
                      child: const Text('User',
                        style: TextStyle(
                          color: Colors.white,
                        )
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Implement restaurant signup functionality here
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[600], // Narancssárga szín
                        padding: EdgeInsets.fromLTRB(20,0,20,0)
                      ),
                      child: const Text('Restaurant',
                        style: TextStyle(
                          color: Colors.white,
                        )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
