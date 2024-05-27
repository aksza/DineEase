import 'package:dine_ease/auth/auth_service.dart';
import 'package:dine_ease/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user';
  // final String token;

  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {

  late String email = '';
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email')!;
    setState(() {
      email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: 
      SafeArea(
        child: 
          Column(
            //
            children: [
              //user icon
              Center(child: const Icon(Icons.person, size: 100)),
              //user name
              Text(email),
              //space between
              const SizedBox(height: 10),
              const Divider(),

              //informations about user
              GestureDetector(
                onTap: (){
                  //navigate to edit profile
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfileScreen()));
                },
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Edit Profile'),
                      
                    ],
                  ),
              ),
              const Divider(),
              //favorits
              GestureDetector(
                //navigate to favorits
                onTap: () => Navigator.of(context).pushNamed('/favorits') ,
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Favorits'),
                      
                    ],
                  ),
              ),
              const Divider(),
              //reservations
              GestureDetector(
                onTap: (){},
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Reservations'),
                      
                    ],
                  ),
              ),
              const Divider(),
              //waitinglist
              GestureDetector(
                onTap: (){},
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Waitinglist'),
                      
                    ],
                  ),
              ),
              const Divider(),
              //meetings
              GestureDetector(
                onTap: (){},
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Meetings'),
                      
                    ],
                  ),
              ),
              const Divider(),
              //reviews
              GestureDetector(
                onTap: (){},
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Reviews'),
                      
                    ],
                  ),
              ),
              const Divider(),
              //ratings
              GestureDetector(
                onTap: (){},
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ratings'),
                      
                    ],
                  ),
              ),
              const Divider(),
              //logout
              GestureDetector(
                onTap: (){AuthService().logout(context);},
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Logout'),
                      
                    ],
                  ),
              ),
              const Divider(),
            ],
            
          )
      ),
    );

  }
}