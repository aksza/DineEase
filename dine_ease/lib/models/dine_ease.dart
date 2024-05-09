import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/restaurant_post.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DineEase extends ChangeNotifier{
  final RequestUtil _requestUtil = RequestUtil();
  List<RestaurantPost> _restaurantList;
  //user favorit list
  List<RestaurantPost> _userFavorits;
  late int userId;
  late String email;
  late String role;
  late SharedPreferences prefs;

  DineEase() : _restaurantList = [], _userFavorits = [], email = '', role = '',userId = 0{
  initApp();
  Logger().i('initialized, $_userFavorits');
}

void initApp() async {
  await getRestaurants();
  await initSharedPrefs();
  await getFavoritRestaurantsByUserId();
}

  Future<void> initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    // userId = prefs.getInt('userId') ?? 0;    
    // email = prefs.getString('email') ?? '';
    // role = prefs.getString('role') ?? '';
    userId = await DataBaseProvider().getUserId();
    email = await DataBaseProvider().getEmail();
    role = await DataBaseProvider().getRole();
    notifyListeners();
    Logger().i('Shared prefs initialized: $userId, $email, $role');
  }

  Future<void> getRestaurants() async{
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
  }

  Future<void> getFavoritRestaurantsByUserId() async{
    //a userId-t a providerből kell lekérni
    List<Restaurant> restaurants = await _requestUtil.getFavoritRestaurantsByUserId(userId);
    Logger().i('userid: $userId');
    // List<RestaurantPost> restaurantList = [];
    for(var restaurant in restaurants){
      _userFavorits.add(RestaurantPost(
        id: restaurant.id,
        name: restaurant.name,
        rating: restaurant.rating,
        // rating: 4.0,
        isFavorite: false,
        imagePath: 'assets/test_images/kfc.jpeg'
      ));
      notifyListeners();
    }   
  }

  

  //get restaurant list
  List<RestaurantPost> get restaurants => _restaurantList;

  //get user favorit list
  List<RestaurantPost> get userFavorits => _userFavorits;

  
  //add to favorit
  void addToFavorits(RestaurantPost restaurant) async{
    // add by using the request util
    Logger().i("userid"+userId.toString()+email+role);
    await _requestUtil.postAddFavoritRestaurant(userId, restaurant.id);
    _userFavorits.add(restaurant);
    notifyListeners();
  }

  //remove from favorit
  void removeFromFavorits(RestaurantPost restaurant) async{
    // remove by using the request util
    _userFavorits.remove(restaurant);
    await _requestUtil.deleteRemoveFavoritRestaurant(userId, restaurant.id);
    notifyListeners();
  }

  bool isFavorite(RestaurantPost restaurant){
    return _userFavorits.contains(restaurant);
  }

}