import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/screens/statistics_forevent_screen.dart';
import 'package:dine_ease/screens/statistics_screen.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';

class RStatisticsScreen extends StatefulWidget {

  static const routeName = '/r_statistics';

  const RStatisticsScreen({super.key});

  @override
  State<RStatisticsScreen> createState() => _RStatisticsScreenState();
}

class _RStatisticsScreenState extends State<RStatisticsScreen> {
  late Restaurant _restaurant;
  final RequestUtil _requestUtil = RequestUtil();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    int restaurantId = await DataBaseProvider().getUserId();

    Restaurant res = await _requestUtil.getRestaurantById(restaurantId);
    setState(() {
      _restaurant = res;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _restaurant.forEvent ? 
          StatisticsForEventScreen() :
          StatisticsScreen();    
  }
}
