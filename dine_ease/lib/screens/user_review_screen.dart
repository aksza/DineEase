import 'dart:math';

import 'package:dine_ease/models/review_models.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/review_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserReviewScreen extends StatefulWidget {
  static const routename = '/user-review';

  const UserReviewScreen({super.key});

  @override
  State<UserReviewScreen> createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  final RequestUtil requestUtil = RequestUtil();

  late int userId;
  late String email;
  late SharedPreferences prefs;
  bool isLoading = true;
  List<Review> reviews = [];

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId')!;
    email = prefs.getString('email')!;
    fetchReviews();
  }

  //fetching reviews by user id
  Future<void> fetchReviews() async {
    try {
      var reviewData = await requestUtil.getReviewsByUserId(userId);
      setState(() {
        reviews = reviewData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  Future<void> deleteReview(Review review) async{
    // Törlési logika, pl. HTTP kérés vagy lokális adatbázis művelet
    try{
      // Törlés a szerverről
      await requestUtil.deleteRemoveReview(review.id);
      setState(() {
        reviews.remove(review);
        //pop a navigatorbol
        Navigator.pop(context);
      });
      print('Review deleted: ${review.content}');
    }
    catch(e){
      print('Error deleting review: $e');
    }
  }

  Future<void> updateReview(Review review,String updatedContent) async {
    // Frissítési logika, pl. HTTP kérés vagy lokális adatbázis művelet
    try{
      // Frissítés a szerveren
      review.content = updatedContent;
      await requestUtil.updateReview(review.id,review);
      print('Review updated: ${review.content}');
    }
    catch(e){
      print('Error updating review: $e');
    }
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
          : reviews.isEmpty
              ? const Center(
                  child: Text('No reviews found'),
                )
              : ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    return ReviewView(
                      review: reviews[index],
                      email: email,
                      onDelete: () async => await deleteReview(reviews[index]),
                      onUpdate: (content) async => await updateReview(reviews[index], content),
                    );
                  },
                ),
    );
  }
}
