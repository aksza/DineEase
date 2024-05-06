import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/restaurant_post.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DineEase extends ChangeNotifier{
  final RequestUtil _requestUtil = RequestUtil();
  List<RestaurantPost> _restaurantList;
  //   //restaurant 1
  //   RestaurantPost(
  //     id: 1,
  //     name: 'KFC',
  //     rating: 4,
  //     isFavorite: false,
  //     imagePath: 'assets/test_images/kfc.jpeg'
  //   ),
  //   //restaurant 2
  //   RestaurantPost(
  //     id: 2,
  //     name: 'McDonalds',
  //     rating: 4,
  //     isFavorite: false,
  //     imagePath: 'assets/test_images/mcdonalds.jpg'
  //   ),
  //   //restaurant 3
  //   RestaurantPost(
  //     id: 3,
  //     name: 'Pizza Hut',
  //     rating: 4,
  //     isFavorite: false,
  //     imagePath: 'assets/test_images/pizzahut.jpg'
  //   ),
  //   //restaurant 4
  //   RestaurantPost(
  //     id: 4,
  //     name: 'Subway',
  //     rating: 4,
  //     isFavorite: false,
  //     imagePath: 'assets/test_images/subway.png'
  //   ),
  // ];

  DineEase() : _restaurantList = [] {
    getRestaurants();
  }


  void getRestaurants() async{
    List<Restaurant> restaurants = await _requestUtil.getRestaurants();
    // List<RestaurantPost> restaurantList = [];
    for(var restaurant in restaurants){
      _restaurantList.add(RestaurantPost(
        id: restaurant.id,
        name: restaurant.name,
        rating: restaurant.rating,
        // rating: 4.0,
        isFavorite: false,
        imagePath: 'assets/test_images/kfc.jpeg'
      ));
      notifyListeners();
    }
    // return restaurantList;
   
  }

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