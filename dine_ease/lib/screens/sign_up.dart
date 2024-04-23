
import 'package:dine_ease/screens/login.dart';
import 'package:dine_ease/widgets/custom_button.dart';
import 'package:dine_ease/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SignUpScreen extends StatefulWidget{
  static const routeName = '/sign-up-user';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>{

  final ufirstNameTextController = TextEditingController();
  final ulastNameTextController = TextEditingController();
  final uemailTextController = TextEditingController();
  final uphoneTextController = TextEditingController();
  final upasswordTextController = TextEditingController();
  final uconfirmPasswordTextController = TextEditingController();

  final rnameTextController = TextEditingController();
  final remailTextController = TextEditingController();
  final rphoneTextController = TextEditingController();
  final rpasswordTextController = TextEditingController();
  final rconfirmPasswordTextController = TextEditingController();
  final rdescription = TextEditingController();
  final raddress = TextEditingController();
  final rprice = TextEditingController(); //TODO:ehelyett lehetne egy dropdown menu is
  final rowner = TextEditingController();
  final rmaxTableCap = TextEditingController();
  final rtaxIdNum = TextEditingController();
  bool isChecked = false;

  bool isRestaurant = false;
  int initialLabelIndex = 0;


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

                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: ToggleSwitch( 
                      minWidth: 120.0, 
                      cornerRadius: 20.0, 
                      inactiveFgColor: Colors.white, 
                      activeBgColor:  const [ Color.fromRGBO(230, 81, 0, 1)],                    
                      initialLabelIndex: initialLabelIndex, 
                      doubleTapDisable: false, 
                      totalSwitches: 2, 
                      labels: const ['User', 'Restaurant'], 
                      onToggle: (index) => {
                        setState(() {
                          isRestaurant = index == 1;
                          initialLabelIndex = index!;
                        })
                      },
                    )
                  ),
                  //space between
                  const SizedBox(height: 25),
                  if(!isRestaurant)
                  Column(
                    children: [
                      //firstname input
                      MyTextField(controller: ufirstNameTextController, hintText: 'First Name', obscureText: false),
                      //space between
                      const SizedBox(height: 10),
                      //lastname input
                      MyTextField(controller: ulastNameTextController, hintText: 'Last Name', obscureText: false),
                      //space between
                      const SizedBox(height: 10),
                      //email input
                      MyTextField(controller: uemailTextController, hintText: 'Email', obscureText: false),
                      //space between
                      const SizedBox(height: 10),
                      //phone input
                      MyTextField(controller: uphoneTextController, hintText: 'Phone', obscureText: false),
                      //space between
                      const SizedBox(height: 10),
                      //password input
                      MyTextField(controller: upasswordTextController, hintText: 'Password', obscureText: true),
                      //space between
                      const SizedBox(height: 10),
                      //confirm password input
                      MyTextField(controller: uconfirmPasswordTextController, hintText: 'Confirm Password', obscureText: true),
                      //space between
                      const SizedBox(height: 10),
                      //sign up button
                      MyButton(
                        text: 'Sign Up',
                        onTap: (){},
                      ),
                    ],
                  ),
                  if(isRestaurant)
                  //az r-el kezdodo valtozok a restaurant sign up-hoz tartoznak
                  Column(
                    children: [
                      //name input
                      MyTextField(controller: rnameTextController, hintText: 'Name', obscureText: false),
                      //space between
                      const SizedBox(height: 10),
                      //email input
                      MyTextField(controller: remailTextController, hintText: 'Email', obscureText: false),
                      //space between
                      const SizedBox(height: 10),
                      //phone input
                      MyTextField(controller: rphoneTextController, hintText: 'Phone', obscureText: false),
                      //space between
                      const SizedBox(height: 10),
                      //description input
                      MyTextField(controller: rdescription, hintText: 'Description', obscureText: false),
                      //space between
                      const SizedBox(height: 10),
                      //address input
                      MyTextField(controller: raddress, hintText: 'Address', obscureText: false),
                      //space between
                      const SizedBox(height: 10),
                      //price input
                      MyTextField(controller: rprice, hintText: 'Price', obscureText: false),
                      //space between
                      const SizedBox(height: 10),
                      //owner input
                      MyTextField(controller: rowner, hintText: 'Owner', obscureText: false),
                      //space between
                      const SizedBox(height: 10),
                      //max table capacity input
                      MyTextField(controller: rmaxTableCap, hintText: 'Max Table Capacity', obscureText: false),
                      //space between
                      const SizedBox(height: 10),
                      //tax id number input
                      MyTextField(controller: rtaxIdNum, hintText: 'Tax ID Number', obscureText: false),
                      //space between
                      const SizedBox(height: 10),
                      //password input
                      MyTextField(controller: rpasswordTextController, hintText: 'Password', obscureText: true),
                      //space between
                      const SizedBox(height: 10),
                      //confirm password input
                      MyTextField(controller: rconfirmPasswordTextController, hintText: 'Confirm Password', obscureText: true),
                       //space between
                      const SizedBox(height: 10),
                      //checkbox 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: isChecked,
                            activeColor: Colors.orange[900],
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          const Text('Is this Restaurant for events?')
                        ]
                      ),
                      //space between
                      const SizedBox(height: 10),
                      //sign up button
                      MyButton(
                        text: 'Sign Up',
                        onTap: (){},
                      ),
                    ],
                  ),
                  //space between
                  const SizedBox(height: 25),

                //go to login page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Do you have an account?",
                      style: TextStyle(
                        color: Colors.grey[700]
                      ),
                    ),
                    const SizedBox(width: 4),

                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){
                          //go to log in page
                          Navigator.of(context).pushNamed(LoginScreen.routeName);
                        },
                    
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[900]
                          ),
                          
                        ),
                      )
                    ),
                  ],
                )
                ]
              )
            )
          )
        )
      )
    );
  }
}