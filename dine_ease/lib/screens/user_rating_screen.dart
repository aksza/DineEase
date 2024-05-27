import 'package:dine_ease/widgets/rating_view.dart';
import 'package:flutter/material.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/models/rating_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRatingScreen extends StatefulWidget {
  static const routeName = '/user-rating-screen';
  const UserRatingScreen({super.key});
  
  @override
  State<UserRatingScreen> createState() => _UserRatingScreenState();
}

class _UserRatingScreenState extends State<UserRatingScreen> {
  final RequestUtil requestUtil = RequestUtil();
  bool isLoading = true;
  List<Rating> ratings = [];
  late int userId;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId')!;
    fetchRatings();
  }

  Future<void> fetchRatings() async {
    try {
      var ratingData = await requestUtil.getRatingsByUserId(userId);
      setState(() {
        ratings = ratingData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching ratings: $e');
    }
  }

  void _handleDelete(int ratingId) {
    setState(() {
      ratings.removeWhere((rating) => rating.id == ratingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Reviews'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ratings.isEmpty
              ? const Center(
                  child: Text('No ratings found'),
                )
              : ListView.builder(
                  itemCount: ratings.length,
                  itemBuilder: (context, index) {
                    return RatingView(
                      rating: ratings[index],
                      onDelete: () => _handleDelete(ratings[index].id!),
                    );
                  },
                ),
    );
  }
}
