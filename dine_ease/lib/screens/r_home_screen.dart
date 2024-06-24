import 'package:dine_ease/auth/auth_service.dart';
import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/screens/r_events_screen.dart';
import 'package:dine_ease/screens/r_meeting_screen.dart';
import 'package:dine_ease/screens/r_menu_screen.dart';
import 'package:dine_ease/screens/r_profile_screen.dart';
import 'package:dine_ease/screens/r_reservation_screen.dart';
import 'package:dine_ease/screens/r_statistics_screen.dart';
import 'package:dine_ease/screens/r_waitinglist_screen.dart';
import 'package:dine_ease/utils/request_util.dart';
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
  late Restaurant restaurant;
  bool isLoading = true;

  @override
  void initState() {
    fetchRestaurant();
    super.initState();
  }

  void fetchRestaurant() async {
    DataBaseProvider dataBaseProvider = DataBaseProvider();
    RequestUtil requestUtil = RequestUtil();

    int resid = await dataBaseProvider.getUserId();
    Restaurant res = await requestUtil.getRestaurantById(resid);

    setState(() {
      restaurant = res;
      isLoading = false;
    });
  }

  final List<Widget> _pages = [
    const RReservationScreen(),
    const RWaitingListScreen(),
    const REventsScreen(),
    const RMenuScreen(),
    const RProfileScreen(),
    const RStatisticsScreen(),
  ];

  final List<Widget> _pagesE = [
    const RMeetingScreen(),
    const RWaitingListScreen(),
    const REventsScreen(),
    const RMenuScreen(),
    const RProfileScreen(),
    const RStatisticsScreen(),
  ];

  final List<String> _titles = [
    'Reservations',
    'Waitinglist',
    'Your Events',
    'Your Menu',
    'Restaurant',
    'Statistics',
  ];

  final List<String> _titlesE = [
    'Meetings',
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
        title: isLoading
            ? const Text('Loading...')
            : restaurant.forEvent
                ? Text(_titlesE[_selectedIndex])
                : Text(_titles[_selectedIndex]),
      ),
      drawer: isLoading
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.orange[700],
                    ),
                    child: const Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: restaurant.forEvent
                        ? const Text('Meeting')
                        : const Text('Reservation'),
                    onTap: () {
                      _onItemTapped(0);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.hourglass_empty),
                    title: const Text('Waitinglist'),
                    onTap: () {
                      _onItemTapped(1);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.event),
                    title: const Text('Your Events'),
                    onTap: () {
                      _onItemTapped(2);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.menu_book_outlined),
                    title: const Text('Your Menu'),
                    onTap: () {
                      _onItemTapped(3);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.restaurant),
                    title: const Text('Restaurant'),
                    onTap: () {
                      _onItemTapped(4);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.bar_chart),
                    title: const Text('Statistics'),
                    onTap: () {
                      _onItemTapped(5);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      AuthService().logout(context);
                    },
                  ),
                ],
              ),
            ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : restaurant.forEvent
              ? _pagesE[_selectedIndex]
              : _pages[_selectedIndex],
    );
  }
}
