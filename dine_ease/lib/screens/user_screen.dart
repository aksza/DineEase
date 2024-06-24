import 'package:dine_ease/auth/auth_service.dart';
import 'package:dine_ease/screens/edit_profile_screen.dart';
import 'package:dine_ease/screens/favorits_page.dart';
import 'package:dine_ease/screens/user_meeting_screen.dart';
import 'package:dine_ease/screens/user_rating_screen.dart';
import 'package:dine_ease/screens/user_reservation_screen.dart';
import 'package:dine_ease/screens/user_review_screen.dart';
import 'package:flutter/material.dart';
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
      body: 
      SafeArea(
        child: 
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Center(child: Icon(Icons.person, size: 100)),
                  Center(child: Text(email)),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    Text('Edit Profile'),
                  ],
                ),
              ),
              const Divider(),

              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FavoritsPage())),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.favorite),
                    SizedBox(width: 10),
                    Text('Favorites'),
                  ],
                ),
              ),
              const Divider(),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserReservationScreen(isreservation: true)));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.book),
                    SizedBox(width: 10),
                    Text('Reservations'),
                  ],
                ),
              ),
              const Divider(),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserReservationScreen(isreservation: false)));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.list),
                    SizedBox(width: 10),
                    Text('Waiting list'),
                  ],
                ),
              ),
              const Divider(),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserMeetingScreen()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.group),
                    SizedBox(width: 10),
                    Text('Meetings'),
                  ],
                ),
              ),
              const Divider(),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserReviewScreen()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.rate_review),
                    SizedBox(width: 10),
                    Text('Reviews'),
                  ],
                ),
              ),
              const Divider(),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserRatingScreen()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.star),
                    SizedBox(width: 10),
                    Text('Ratings'),
                  ],
                ),
              ),
              const Divider(),

              GestureDetector(
                onTap: () {
                  AuthService().logout(context);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text('Logout'),
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