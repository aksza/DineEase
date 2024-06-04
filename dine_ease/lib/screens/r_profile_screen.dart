import 'package:flutter/material.dart';

class RProfileScreen extends StatefulWidget {

  static const routeName = '/r_profile';

  const RProfileScreen({super.key});

  @override
  State<RProfileScreen> createState() => _RProfileScreenState();
}

class _RProfileScreenState extends State<RProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}