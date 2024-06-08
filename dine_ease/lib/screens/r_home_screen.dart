import 'package:dine_ease/auth/auth_service.dart';
import 'package:dine_ease/screens/r_events_screen.dart';
import 'package:dine_ease/screens/r_menu_screen.dart';
import 'package:dine_ease/screens/r_profile_screen.dart';
import 'package:dine_ease/screens/r_reservation_screen.dart';
import 'package:dine_ease/screens/r_statistics_screen.dart';
import 'package:dine_ease/screens/r_waitinglist_screen.dart';
import 'package:flutter/material.dart';

class RHomeScreen extends StatefulWidget {
  static const routeName = '/r_home';

  const RHomeScreen({super.key});

  @override
  State<RHomeScreen> createState() => _RHomeScreenState();
}

class _RHomeScreenState extends State<RHomeScreen> {
  int _selectedIndex = 0;
  String _selectedTitle = '';

  final List<Widget> _pages = [
    RReservationScreen(),
    RWaitingListScreen(),
    REventsScreen(),
    RMenuScreen(),
    RProfileScreen(),
    RStatisticsScreen(),
  ];

  final List<String> _titles = [
    'Reservations',
    'Waitinglist',
    'Your Events',
    'Your Menu',
    'Restaurant',
    'Statistics',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]) ,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.orange[700],
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Reservations'),
              onTap: () {
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.hourglass_empty),
              title: Text('Waitinglist'),
              onTap: () {
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Your Events'),
              onTap: () {
                _onItemTapped(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.menu_book_outlined),
              title: Text('Your Menu'),
              onTap: () {
                _onItemTapped(3);
              },
            ),
            ListTile(
              leading: Icon(Icons.restaurant),
              title: Text('Restaurant'),
              onTap: () {
                _onItemTapped(4);
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Statistics'),
              onTap: () {
                _onItemTapped(5);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle the logout action
                // Navigator.of(context).pop();
                AuthService().logout(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}