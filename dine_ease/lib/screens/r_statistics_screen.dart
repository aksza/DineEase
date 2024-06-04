import 'package:flutter/material.dart';

class RStatisticsScreen extends StatefulWidget {

  static const routeName = '/r_statistics';

  const RStatisticsScreen({super.key});

  @override
  State<RStatisticsScreen> createState() => _RStatisticsScreenState();
}

class _RStatisticsScreenState extends State<RStatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Statistics Screen'),
      ),
    );
  }
}