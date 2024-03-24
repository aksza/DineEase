import 'package:flutter/material.dart';
import 'package:dine_ease/screens/login.dart';
// import 'package:dine_ease/screens/sign_up_user.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initially show the login page
  bool showLoginPage = true;

  //toggle between logina nd register page
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    // if (showLoginPage){
    //   return LoginScreen(onTap: togglePages);
    // }
    // }else{
    //   return RegisterScreen(onTap: togglePages);
    // }
    return LoginScreen(onTap: togglePages);
  }
}