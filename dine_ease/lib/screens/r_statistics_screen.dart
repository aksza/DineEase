import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/review_models.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/restaurant_review.dart';
import 'package:dine_ease/widgets/review_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class RStatisticsScreen extends StatefulWidget {

  static const routeName = '/r_statistics';

  const RStatisticsScreen({super.key});

  @override
  State<RStatisticsScreen> createState() => _RStatisticsScreenState();
}

class _RStatisticsScreenState extends State<RStatisticsScreen> {
  late Restaurant _restaurant;
  RequestUtil _requestUtil = RequestUtil();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    int restaurantId = await DataBaseProvider().getUserId();
    //get reviews by restaurant id
    List<Review>? reviews = await _requestUtil.getReviewsByRestaurantId(restaurantId);

    //getrestaurantbyid
    Restaurant res = await _requestUtil.getRestaurantById(restaurantId);
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
          title: Text('Reviews'),
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
          : Column(
          children: [
            //in a box rating

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
                      Text(_restaurant.rating.toString() + '⭐', style: TextStyle(fontSize: 20),),
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

          ],
        ),
      ),


    
    );
  }
}