import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/review_models.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/restaurant_review.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class StatisticsScreen extends StatefulWidget {

  static const routeName = '/statistics';

  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Restaurant _restaurant;
  List<int> dailyReservations = [];
  List<int> lastMonthReservations = [];
  List<int> hourlyReservations = [];
  List<int> ordersPerReservations = [];
  List<int> eventNumber = [];
  final RequestUtil _requestUtil = RequestUtil();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> getEventNumber(int restaurantId) async {
    List<int> eventNumber = await _requestUtil.getEventNumberByRestaurantId(restaurantId);
    Logger().i('Event number: $eventNumber');
    setState(() {
      this.eventNumber = eventNumber;
    });
  }

  Future<void> getDailyReservations(int restaurantId) async {
    List<int> dailyReservations = await _requestUtil.getDailyReservationsByRestaurantId(restaurantId);
    Logger().i('Daily reservations: $dailyReservations');
    setState(() {
      this.dailyReservations = dailyReservations;
    });
  } 

  Future<void> getLastMonthReservations(int restaurantId) async {
    List<int> lastMonthReservations = await _requestUtil.getMonthlyReservationsByRestaurantId(restaurantId);
    Logger().i('Last month reservations: $lastMonthReservations');
    setState(() {
      this.lastMonthReservations = lastMonthReservations;
    });
  }

  Future<void> getHourlyReservations(int restaurantId) async {
    List<int> hourlyReservations = await _requestUtil.getHourlyReservationsByRestaurantId(restaurantId);
    Logger().i('Hourly reservations: $hourlyReservations');
    setState(() {
      this.hourlyReservations = hourlyReservations;
    });
  }

  Future<void> getOrdersPerReservation(int restaurantId) async {
    List<int> ordersPerReservations = await _requestUtil.getOrdersPerReservationsByRestaurantId(restaurantId);
    Logger().i('Orders per reservation: $ordersPerReservations');
    setState(() {
      this.ordersPerReservations = ordersPerReservations;
    });
  }

  void _loadData() async {
    int restaurantId = await DataBaseProvider().getUserId();
    List<Review>? reviews = await _requestUtil.getReviewsByRestaurantId(restaurantId);
    
    Restaurant res = await _requestUtil.getRestaurantById(restaurantId);
    await getDailyReservations(res.id);
    await getLastMonthReservations(res.id);
    await getHourlyReservations(res.id);
    await getOrdersPerReservation(res.id);
    await getEventNumber(res.id);

    setState(() {
      _restaurant = res;
      _restaurant.reviews = reviews;
      _isLoading = false;
    });
  }


  Future<void> deleteReview(int reviewId) async {
    try {

      await _requestUtil.deleteRemoveReview(reviewId);
    } catch (e) {
      Logger().e('Error deleting review: $e');
    }
  }

  void _showReviews(List<Review>? review) {
    if(review == null || review.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reviews'),
            content: const Text('No reviews yet'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              )
            ],
          );
        },
      );
    } else {
      showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reviews'),
          content: Container(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: review.length,
              itemBuilder: (context, index) {
                return RestaurantReview(review: review![index],
                           onDelete: () async{
                            await deleteReview(review[index].id!);
                            setState(() {
                              review.removeAt(index);
                            });
                            Navigator.pop(context);
                            _showReviews(review);
                           }
                          );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            )
          ],
        );
      },
    );
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: _isLoading ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
            child:
          Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text('Rating', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text( _restaurant.rating == null ? '0⭐' : _restaurant.rating.toString() + '⭐', style: const TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    _showReviews(_restaurant.reviews);
                    print('ok');
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text('Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        Text(_restaurant.reviews == null ? 'No reviews yet' : _restaurant.reviews!.length.toString() + ' reviews', style: const TextStyle(fontSize: 20),),
                      ],
                    ),
                  ),
                )
              ],
            ),
            
            const SizedBox(height: 20.0),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDailyChart('Average Daily Reservations', dailyReservations),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMonthlyChart('Last Month Reservations', lastMonthReservations),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildHourlyChart('Average Hourly Reservations', hourlyReservations),
                ],
              ),
            ),

            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPieChart('Orders per Reservation', ordersPerReservations),
                ],
              ),
            ),

            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildColumnChart('Events in last five weeks', eventNumber),
                ],
              ),
            ),
            ],
          ),
        ),
      )
    );
  }
  
  Widget _buildColumnChart(String title, List<int> data) {
 return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          AspectRatio(
            aspectRatio: 1.5, 
            child: BarChart(
              BarChartData(
                titlesData: const FlTitlesData(
                  rightTitles: AxisTitles(sideTitles: 
                  SideTitles(showTitles: false)
                  ),

                  topTitles: AxisTitles(sideTitles: 
                  SideTitles(showTitles: false)
                  ),
                ),
                barGroups: List.generate(
                  data.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data[index].toDouble(),
                        color: Colors.orange[700], 
                        width: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildHourlyChart(String title, List<int> data) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style:const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: (data.reduce((a, b) => a > b ? a : b)) / 3,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (data.reduce((a, b) => a > b ? a : b)) / 3,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toStringAsFixed(1));
                      },
                      reservedSize: 32,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    top: BorderSide.none,
                    right: BorderSide.none,
                    bottom: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                    }).toList(),
                    isCurved: true,
                    barWidth: 2.0,
                    dotData: const FlDotData(
                      show: false,
                    ),
                    color: Colors.orange[700],
                  ),
                ],
                minX: 0,
                maxX: 23,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildMonthlyChart(String title, List<int> data) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: (data.reduce((a, b) => a > b ? a : b)) / 2,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false
                  )),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (data.reduce((a, b) => a > b ? a : b)) / 2,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toStringAsFixed(1));
                      },
                      reservedSize: 32,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    top: BorderSide.none,
                    right: BorderSide.none,
                    bottom: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((entry) {
                      return FlSpot((entry.key + 1).toDouble(), entry.value.toDouble());
                    }).toList(),
                    isCurved: true,
                    barWidth: 2.0,
                    dotData: const FlDotData(show: false),
                    color: Colors.orange[700],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}



  Widget _buildDailyChart(String title, List<int> data) {
  final List<String> daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style:const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: (data.reduce((a, b) => a > b ? a : b)) / 2,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < daysOfWeek.length) {
                          return Text(daysOfWeek[index]);
                        }
                        return const Text('');
                      },
                      reservedSize: 32,
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (data.reduce((a, b) => a > b ? a : b)) / 2,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                      reservedSize: 32,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    top: BorderSide.none,
                    right: BorderSide.none,
                    bottom: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                    }).toList(),
                    isCurved: true,
                    barWidth: 2.0,
                    color: Colors.orange[700],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildPieChart(String title, List<int> data) {
  List<String> sectionTitles = ["No Order", "Order"];

  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          AspectRatio(
            aspectRatio: 1.0,
            child: PieChart(
              PieChartData(
                sections: List.generate(data.length, (index) {
                  return PieChartSectionData(
                    value: data[index].toDouble(),
                    color: index == 0 ? Colors.orange[700] : Colors.blue[600],
                    title: '${sectionTitles[index]} (${data[index]})',
                    radius: 50.0,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
