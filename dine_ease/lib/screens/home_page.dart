import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/screens/event_page.dart';
import 'package:dine_ease/screens/for_you_page.dart';
import 'package:dine_ease/screens/restaurant_for_event_page.dart';
import 'package:dine_ease/screens/restaurant_page.dart';
import 'package:dine_ease/widgets/custom_appbar.dart';
import 'package:dine_ease/widgets/restaurant_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  // final String token;

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  // late String email = '';
  // late SharedPreferences prefs;

  // @override
  // void initState(){
  //   super.initState();
  //   initSharedPrefs();
  // }

  // void initSharedPrefs() async{
  //   prefs = await SharedPreferences.getInstance();
  //   email = prefs.getString('email')!;
  //   setState(() {
  //     email = email;
  //   });
  // }
  int _selectedIndex = 0;

  void navigateToScreens(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    ForYouPage(),
    RestaurantPage(),
    EventPage(),
    RestaurantForEventPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        (index) => navigateToScreens(index),
      ),
      body: _pages[_selectedIndex],
    );
  }
}