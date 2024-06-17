import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/review_models.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/restaurant_review.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class StatisticsForEventScreen extends StatefulWidget {

  static const routeName = '/statistics-forevent';

  const StatisticsForEventScreen({super.key});

  @override
  State<StatisticsForEventScreen> createState() => _StatisticsForEventScreenState();
}

class _StatisticsForEventScreenState extends State<StatisticsForEventScreen> {
  late Restaurant _restaurant;
  List<int> eventNumber = [];
  List<int> dailyMeetings = [];
  List<int> lastMonthMeetings = [];
  List<int> hourlyMeetings = [];
  final RequestUtil _requestUtil = RequestUtil();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

   //get event number by restaurant id
  Future<void> getEventNumber(int restaurantId) async {
    List<int> eventNumber = await _requestUtil.getEventNumberByRestaurantId(restaurantId);
    Logger().i('Event number: $eventNumber');
    setState(() {
      this.eventNumber = eventNumber;
    });
  }

  //get daily meetings by restaurant id
  Future<void> getDailyMeetings(int restaurantId) async {
    List<int> dailyMeetings = await _requestUtil.getDailyMeetingsByRestaurantId(restaurantId);
    Logger().i('Daily meetings: $dailyMeetings');
    setState(() {
      this.dailyMeetings = dailyMeetings;
    });
  }

  //get last month meetings by restaurant id
  Future<void> getLastMonthMeetings(int restaurantId) async {
    List<int> lastMonthMeetings = await _requestUtil.getMonthlyMeetingsByRestaurantId(restaurantId);
    Logger().i('Last month meetings: $lastMonthMeetings');
    setState(() {
      this.lastMonthMeetings = lastMonthMeetings;
    });
  }

  //get hourly meetings by restaurant id
  Future<void> getHourlyMeetings(int restaurantId) async {
    List<int> hourlyMeetings = await _requestUtil.getHourlyMeetingsByRestaurantId(restaurantId);
    Logger().i('Hourly meetings: $hourlyMeetings');
    setState(() {
      this.hourlyMeetings = hourlyMeetings;
    });
  }

  void _loadData() async {
    int restaurantId = await DataBaseProvider().getUserId();
    //get reviews by restaurant id
    List<Review>? reviews = await _requestUtil.getReviewsByRestaurantId(restaurantId);

    //getrestaurantbyid
    Restaurant res = await _requestUtil.getRestaurantById(restaurantId);
    await getEventNumber(res.id);
    await getDailyMeetings(res.id);
    await getLastMonthMeetings(res.id);
    await getHourlyMeetings(res.id);
    setState(() {
      _restaurant = res;
      _restaurant.reviews = reviews;
      _isLoading = false;
    });
  }


  //delete review
  Future<void> deleteReview(int reviewId) async {
    try {

      await _requestUtil.deleteRemoveReview(reviewId);
      // setState(() {
      //   _restaurant.reviews!.removeWhere((review) => review.id == reviewId);
      // });
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
            title: Text('Reviews'),
            content: Text('No reviews yet'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
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
                //in a box list tile
                return RestaurantReview(review: review![index],
                           onDelete: () async{
                            await deleteReview(review[index].id!);
                            setState(() {
                              review.removeAt(index);
                            });
                            //frissitjuk a dialogot
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
              child: Text('Close'),
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
        
        body: _isLoading ? Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
            child: 
          Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text('Rating', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Text( _restaurant.rating == null ? '0⭐' : _restaurant.rating.toString() + '⭐', style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    _showReviews(_restaurant.reviews);
                    print('ok');
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text('Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        Text(_restaurant.reviews == null ? 'No reviews yet' : _restaurant.reviews!.length.toString() + ' reviews', style: TextStyle(fontSize: 20),),
                      ],
                    ),
                  ),
                )
              ],
            ),
            
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDailyChart('Average Daily Meetings', dailyMeetings),
                ],
              ),
            ),
             SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMonthlyChart('Last Month Meetings', lastMonthMeetings),
                ],
              ),
            ),
             SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildHourlyChart('Average Hourly Meetings', hourlyMeetings),
                ],
              ),
            ),
            SizedBox(height: 20.0),
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
      ),
    );
  }

  
  Widget _buildColumnChart(String title, List<int> data) {
 return Expanded(
    child: Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
      padding: EdgeInsets.all(16.0),
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

}
