import 'package:flutter/material.dart';

class REventsScreen extends StatefulWidget {

  static const routeName = '/r_events';

  const REventsScreen({super.key});

  @override
  State<REventsScreen> createState() => _REventsScreenState();
}

class _REventsScreenState extends State<REventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Events Screen'),
      ),
    );
  }
}