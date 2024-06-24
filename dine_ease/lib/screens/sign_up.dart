
import 'package:dine_ease/models/register_restaurant_form.dart';
import 'package:dine_ease/screens/login.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/custom_button.dart';
import 'package:dine_ease/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SignUpScreen extends StatefulWidget{
  static const routeName = '/sign-up-user';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>{
  final RequestUtil requestUtil = RequestUtil();

  final ufirstNameTextController = TextEditingController();
  final ulastNameTextController = TextEditingController();
  final uemailTextController = TextEditingController();
  final uphoneTextController = TextEditingController();
  final upasswordTextController = TextEditingController();
  final uconfirmPasswordTextController = TextEditingController();

  Future<void> createUser() async {
    try{
      Logger().i('${ufirstNameTextController.text}, ${ulastNameTextController.text}, ${uemailTextController.text}, ${uphoneTextController.text}, ${upasswordTextController.text}');
      await requestUtil.postUserCreate(
        ufirstNameTextController.text,
        ulastNameTextController.text,
        uemailTextController.text,
        upasswordTextController.text,
        uphoneTextController.text
      );
    }catch(e){
      Logger().e('Error creating user: $e');
    }

  }

  final rnameTextController = TextEditingController();
  final remailTextController = TextEditingController();
  final rphoneTextController = TextEditingController();
  final rpasswordTextController = TextEditingController();
  final rconfirmPasswordTextController = TextEditingController();
  final rdescription = TextEditingController();
  final raddress = TextEditingController();
  late int rprice = 2;
  final rownerName = TextEditingController();
  final rownerPhoneNum = TextEditingController();
  final rmaxTableCap = TextEditingController();
  final rtaxIdNum = TextEditingController();
  bool isChecked = false;

  bool isRestaurant = false;
  int initialLabelIndex = 0;

  Future<void> createRestaurant() async {
    try{
      Logger().i('${rnameTextController.text}, ${remailTextController.text}, ${rphoneTextController.text}, ${rpasswordTextController.text}, ${rdescription.text}, ${raddress.text}, $rprice, ${rownerName.text}, ${rownerPhoneNum.text}, ${rmaxTableCap.text}, ${rtaxIdNum.text}, $isChecked');
      await requestUtil.postRestaurantCreate(
        RegisterRestaurant(
          name: rnameTextController.text,
          description: rdescription.text,
          address: raddress.text,
          phoneNum: rphoneTextController.text,
          email: remailTextController.text,
          password: rpasswordTextController.text,
          priceId: rprice,
          forEvent: isChecked,
          ownerName: rownerName.text,
          ownerPhoneNum: rownerPhoneNum.text,
          maxTableCapacity: int.parse(rmaxTableCap.text),
          taxIdNum: int.parse(rtaxIdNum.text)
        )
        
      );
    }catch(e){
      Logger().e('Error creating restaurant: $e');
    }
  }

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
                  Image.asset(
                    'assets/images/logo.png',
                    alignment: Alignment.center,
                    width: 100,
                    height: 100
                  ),
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
                  const SizedBox(height: 25),
                  if(!isRestaurant)
                  Column(
                    children: [
                      MyTextField(controller: ufirstNameTextController, hintText: 'First Name', obscureText: false),
                      const SizedBox(height: 10),
                      MyTextField(controller: ulastNameTextController, hintText: 'Last Name', obscureText: false),
                      const SizedBox(height: 10),
                      MyTextField(controller: uemailTextController, hintText: 'Email', obscureText: false),
                      const SizedBox(height: 10),
                      MyTextField(controller: uphoneTextController, hintText: 'Phone', obscureText: false),
                      const SizedBox(height: 10),
                      MyTextField(controller: upasswordTextController, hintText: 'Password', obscureText: true),
                      const SizedBox(height: 10),
                      MyTextField(controller: uconfirmPasswordTextController, hintText: 'Confirm Password', obscureText: true),
                      const SizedBox(height: 10),
                      MyButton(
                        text: 'Sign Up',
                        onTap: (){
                          if(uemailTextController.text.isNotEmpty &&
                          upasswordTextController.text.isNotEmpty &&
                          uconfirmPasswordTextController.text.isNotEmpty &&
                          ufirstNameTextController.text.isNotEmpty &&
                          ulastNameTextController.text.isNotEmpty &&
                          uphoneTextController.text.isNotEmpty){
                            if(upasswordTextController.text != uconfirmPasswordTextController.text){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Passwords do not match'),
                                  backgroundColor: Colors.red,
                                )
                              );
                            }
                            else if(!uemailTextController.text.contains('@') || !uemailTextController.text.contains('.')){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid email'),
                                  backgroundColor: Colors.red,
                                )
                              );
                            }
                            else if(uphoneTextController.text.length < 10 || uphoneTextController.text.length > 12 || uphoneTextController.text.contains(RegExp(r'[a-zA-Z]'))){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid phone number'),
                                  backgroundColor: Colors.red,
                                )
                              );
                            }
                            else if(upasswordTextController.text.length < 6){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password must be at least 6 characters long'),
                                  backgroundColor: Colors.red,
                                )
                              );
                            }
                            else{
                              createUser();
                              Navigator.of(context).pushNamed(LoginScreen.routeName);
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
                        },
                      ),
                    ],
                  ),
                  if(isRestaurant)
                  Column(
                    children: [
                      MyTextField(controller: rnameTextController, hintText: 'Name', obscureText: false),
                      const SizedBox(height: 10),
                      MyTextField(controller: remailTextController, hintText: 'Email', obscureText: false),
                      const SizedBox(height: 10),
                      MyTextField(controller: rphoneTextController, hintText: 'Phone', obscureText: false,),
                      const SizedBox(height: 10),
                      MyTextField(controller: rdescription, hintText: 'Description', obscureText: false),
                      const SizedBox(height: 10),
                      MyTextField(controller: raddress, hintText: 'Address', obscureText: false),
                      
                      const SizedBox(height: 10),
                      MyTextField(controller: rmaxTableCap, hintText: 'Max Table Capacity', obscureText: false),
                      const SizedBox(height: 10),
                      MyTextField(controller: rtaxIdNum, hintText: 'Tax ID Number', obscureText: false),
                      const SizedBox(height: 10),
                      MyTextField(controller: rpasswordTextController, hintText: 'Password', obscureText: true),
                      const SizedBox(height: 10),
                      MyTextField(controller: rconfirmPasswordTextController, hintText: 'Confirm Password', obscureText: true),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Price category', 
                            style: 
                              TextStyle(fontSize: 20, 
                              fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left
                            ),
                            const SizedBox(width: 20),
                            DropdownButton(
                              value: rprice - 1,
                              items: const [
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('Cheap'),

                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('Average'),
                                ),
                                DropdownMenuItem(
                                  value: 3,
                                  child: Text('Expensive'),
                                ),
                              ],
                              onChanged: (int? value){
                                setState(() {
                                  rprice = value! + 1;
                                  value = rprice - 1;
                                });
                              },
                            )
                        ]
                      ),
                      
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Owner information', 
                            style: 
                              TextStyle(fontSize: 20, 
                              fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left
                          )
                        ]
                      ),             
                      const SizedBox(height: 10),                      
                      MyTextField(controller: rownerName, hintText: 'Owner', obscureText: false),
                      const SizedBox(height: 10),
                      MyTextField(controller: rownerPhoneNum, hintText: 'Phone number', obscureText: false),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      MyButton(
                        text: 'Sign Up',
                        onTap: (){
                          if(rnameTextController.text.isNotEmpty &&
                          raddress.text.isNotEmpty &&
                          rphoneTextController.text.isNotEmpty &&
                          remailTextController.text.isNotEmpty &&
                          rpasswordTextController.text.isNotEmpty &&
                          rconfirmPasswordTextController.text.isNotEmpty &&
                          rprice != 0 &&
                          rownerName.text.isNotEmpty &&
                          rownerPhoneNum.text.isNotEmpty &&
                          rmaxTableCap.text.isNotEmpty &&
                          rtaxIdNum.text.isNotEmpty){
                            if(rpasswordTextController.text != rconfirmPasswordTextController.text){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Passwords do not match'),
                                  backgroundColor: Colors.red,
                                )
                              );
                            }
                            else if(!remailTextController.text.contains('@') || !remailTextController.text.contains('.')){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid email'),
                                  backgroundColor: Colors.red,
                                )
                              );
                            }
                            else if(rphoneTextController.text.length < 10 || rphoneTextController.text.length > 12 || rphoneTextController.text.contains(RegExp(r'[a-zA-Z]'))){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid phone number'),
                                  backgroundColor: Colors.red,
                                )
                              );
                            }
                            else if(rmaxTableCap.text.contains(RegExp(r'[a-zA-Z]')) || int.parse(rmaxTableCap.text) < 0){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid max table capacity'),
                                  backgroundColor: Colors.red,
                                )
                              );
                            }
                            else if(rtaxIdNum.text.contains(RegExp(r'[a-zA-Z]'))){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid tax id number'),
                                  backgroundColor: Colors.red,
                                )
                              );
                            }
                            else if(rpasswordTextController.text.length < 6){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password must be at least 6 characters long'),
                                  backgroundColor: Colors.red,
                                )
                              );
                            }
                            else if(rownerPhoneNum.text.length < 10 || rownerPhoneNum.text.length > 12 || rownerPhoneNum.text.contains(RegExp(r'[a-zA-Z]'))){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid owner phone number'),
                                  backgroundColor: Colors.red,
                                )
                              );
                            }
                            else{
                              createRestaurant();
                              Navigator.of(context).pushNamed(LoginScreen.routeName);
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
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
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