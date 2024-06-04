import 'package:flutter/material.dart';

class RWaitingListScreen extends StatefulWidget {

  static const routeName = '/r_waitinglist';

  const RWaitingListScreen({super.key});

  @override
  State<RWaitingListScreen> createState() => _RWaitingListScreenState();
}

class _RWaitingListScreenState extends State<RWaitingListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Waiting List Screen'),
      ),
    );
  }
}