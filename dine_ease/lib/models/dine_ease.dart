import 'package:dine_ease/models/restaurant_post.dart';
import 'package:flutter/material.dart';

class DineEase extends ChangeNotifier{
  //favorit list
  final List<RestaurantPost> _restaurantList = [
    //restaurant 1
    RestaurantPost(
      name: 'KFC',
      rating: 4,
      isFavorite: false,
      imagePath: 'assets/test_images/kfc.jpeg'
    ),
    //restaurant 2
    RestaurantPost(
      name: 'McDonalds',
      rating: 4,
      isFavorite: false,
      imagePath: 'assets/test_images/mcdonalds.jpg'
    ),
    //restaurant 3
    RestaurantPost(
      name: 'Pizza Hut',
      rating: 4,
      isFavorite: false,
      imagePath: 'assets/test_images/pizzahut.jpg'
    ),
    //restaurant 4
    RestaurantPost(
      name: 'Subway',
      rating: 4,
      isFavorite: false,
      imagePath: 'assets/test_images/subway.png'
    ),
  ];

  //user favorit list
  List<RestaurantPost> _userFavorits = [];

  //get restaurant list
  List<RestaurantPost> get restaurants => _restaurantList;

  //get user favorit list
  List<RestaurantPost> get userFavorits => _userFavorits;

  //add to favorit
  void addToFavorits(RestaurantPost restaurant){
    _userFavorits.add(restaurant);
    notifyListeners();
  }

  //remove from favorit
  void removeFromFavorits(RestaurantPost restaurant){
    _userFavorits.remove(restaurant);
    notifyListeners();
  }

  bool isFavorite(RestaurantPost restaurant){
    return _userFavorits.contains(restaurant);
  }

}