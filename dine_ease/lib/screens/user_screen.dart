import 'package:dine_ease/auth/auth_service.dart';
import 'package:dine_ease/screens/edit_profile_screen.dart';
import 'package:dine_ease/screens/favorits_page.dart';
import 'package:dine_ease/screens/user_meeting_screen.dart';
import 'package:dine_ease/screens/user_rating_screen.dart';
import 'package:dine_ease/screens/user_reservation_screen.dart';
import 'package:dine_ease/screens/user_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user';

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
      // backgroundColor: Colors.grey[300],
      body: 
      SafeArea(
        child: 
          Column(
            //
            children: [
              //user icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Center(child: const Icon(Icons.person, size: 100)),
                  //user name
                  Center(child: Text(email)),
                ],
              ),
              // Space between
              const SizedBox(height: 10),
              const Divider(),

              // Information about user
              GestureDetector(
                onTap: () {
                  // Navigate to edit profile
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfileScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    const Text('Edit Profile'),
                  ],
                ),
              ),
              const Divider(),

              // Favorites
              GestureDetector(
                // Navigate to favorites
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavoritsPage())),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.favorite),
                    SizedBox(width: 10),
                    const Text('Favorites'),
                  ],
                ),
              ),
              const Divider(),

              // Reservations
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserReservationScreen(isreservation: true)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.book),
                    SizedBox(width: 10),
                    const Text('Reservations'),
                  ],
                ),
              ),
              const Divider(),

              // Waiting list
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserReservationScreen(isreservation: false)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.list),
                    SizedBox(width: 10),
                    const Text('Waiting list'),
                  ],
                ),
              ),
              const Divider(),

              // Meetings
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserMeetingScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.group),
                    SizedBox(width: 10),
                    const Text('Meetings'),
                  ],
                ),
              ),
              const Divider(),

              // Reviews
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserReviewScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.rate_review),
                    SizedBox(width: 10),
                    const Text('Reviews'),
                  ],
                ),
              ),
              const Divider(),

              // Ratings
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserRatingScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.star),
                    SizedBox(width: 10),
                    const Text('Ratings'),
                  ],
                ),
              ),
              const Divider(),

              // Logout
              GestureDetector(
                onTap: () {
                  AuthService().logout(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    const Text('Logout'),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      );
  
  }
}