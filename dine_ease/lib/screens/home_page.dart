import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/screens/event_page.dart';
import 'package:dine_ease/screens/for_you_page.dart';
import 'package:dine_ease/screens/restaurant_for_event_page.dart';
import 'package:dine_ease/screens/restaurant_page.dart';
import 'package:dine_ease/screens/search_page.dart';
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
  int _selectedIndex = 0;
  String query = '';

  @override
  void initState() {
    super.initState();
    navigateToScreens(0, query);
  }

  void navigateToScreens(int index, String? q) {
    setState(() {
      _selectedIndex = index;
      if (q != null) {
        query = q;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        (index, q) {
          navigateToScreens(index, q);
        },
      ),
      body: _selectedIndex == 4 ? buildSearchPage() : _buildPage(_selectedIndex),
    );
  }

  Widget _buildPage(int index) {
    final List<Widget> _pages = [
      ForYouPage(),
      RestaurantPage(),
      EventPage(),
      RestaurantForEventPage(),
    ];

    return _pages[index];
  }

  Widget buildSearchPage() {
    return KeyedSubtree(
      key: UniqueKey(), 
      child: SearchPage(query: query),
    );
  }
}
