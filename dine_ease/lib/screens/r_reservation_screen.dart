import 'package:flutter/material.dart';

class RReservationScreen extends StatefulWidget {

  static const routeName = '/r_reservation';

  const RReservationScreen({super.key});

  @override
  State<RReservationScreen> createState() => _RReservationScreenState();
}

class _RReservationScreenState extends State<RReservationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Reservation Screen'),
      ),
    );
  }
}