
import 'package:dine_ease/auth/auth_service.dart';
import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/screens/home_page.dart';
import 'package:dine_ease/screens/r_home_screen.dart';
import 'package:dine_ease/screens/r_reservation_screen.dart';
import 'package:dine_ease/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:dine_ease/widgets/custom_button.dart';
import 'package:dine_ease/widgets/custom_text_field.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget{
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  //text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  // late SharedPreferences prefs;
  // late String token='';

  @override
  void initState(){
    super.initState();
    // SharedPreferences.getInstance().then((value){
    //   prefs = value;
    //   token = prefs.getString('token')!;
    // });
  }

  @override
  Widget build(BuildContext context){
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

                //welcome back message
                Text(
                  "Welcome back to DineEase!",
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),

                //space between
                const SizedBox(height: 25),
                //email textfield
                MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false
                ),

                //space between
                const SizedBox(height: 10),

                //password textfield
                MyTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: true //you cant see the characters
                ),

                //space between
                const SizedBox(height: 10),

                //sign in button
                Consumer<AuthService>(
                  builder: (context, authService, child){
                    return MyButton(
                      text: 'Log In',
                      onTap: () async{
                        if(emailTextController.text.isNotEmpty && passwordTextController.text.isNotEmpty){
                          bool loginSuccessfull = await authService.login(
                            emailTextController.text,
                            passwordTextController.text
                          );
                          if(loginSuccessfull){
                            //from the token, we can get the user details, like role
                            String role = await DataBaseProvider().getRole();
                            // Logger().i(token);
                            if(role == 'User'){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                            }

                            if(role == 'Restaurant'){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RHomeScreen()),
                            );
                            }
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid email or password'),
                                backgroundColor: Colors.red,
                              )
                            );
                          }
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All fields are required'),
                              backgroundColor: Colors.red,
                            )
                          );
                        }
                      }
                    );
                  }
                ),

                const SizedBox(height: 25),

                //go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.grey[700]
                      ),
                    ),
                    const SizedBox(width: 4),

                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){
                          //go to sign up page
                          Navigator.of(context).pushNamed(SignUpScreen.routeName);
                        },
                    
                        child: Text(
                          "Register now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[900]
                          ),
                          
                        ),
                      )
                    ),
                ],
                )
              ],
            )
          )
        )
      )
    );
  }
}