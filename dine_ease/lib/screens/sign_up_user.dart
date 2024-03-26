
import 'package:dine_ease/widgets/custom_button.dart';
import 'package:dine_ease/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignUpUserScreen extends StatefulWidget{
  static const routeName = '/sign-up-user';

  const SignUpUserScreen({super.key});

  @override
  State<SignUpUserScreen> createState() => _SignUpUserScreenState();
}

class _SignUpUserScreenState extends State<SignUpUserScreen>{

  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 25.0),
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
                    "Sign Up as a User",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  //space between
                  const SizedBox(height: 25),
                  //firstname input
                  MyTextField(controller: firstNameTextController, hintText: 'First Name', obscureText: false),
                  //space between
                  const SizedBox(height: 10),
                  //lastname input
                  MyTextField(controller: lastNameTextController, hintText: 'Last Name', obscureText: false),
                  //space between
                  const SizedBox(height: 10),
                  //email input
                  MyTextField(controller: emailTextController, hintText: 'Email', obscureText: false),
                  //space between
                  const SizedBox(height: 10),
                  //phone input
                  MyTextField(controller: phoneTextController, hintText: 'Phone', obscureText: false),
                  //space between
                  const SizedBox(height: 10),
                  //password input
                  MyTextField(controller: passwordTextController, hintText: 'Password', obscureText: true),
                  //space between
                  const SizedBox(height: 10),
                  //confirm password input
                  MyTextField(controller: confirmPasswordTextController, hintText: 'Confirm Password', obscureText: true),
                  //space between
                  const SizedBox(height: 10),
                  //sign up button
                  MyButton(
                    text: 'Sign Up',
                    onTap: (){},
                  ),
                ]
              )
            )
          )
        )
      )
    );
  }
}