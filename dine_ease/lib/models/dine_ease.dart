import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/event_post_model.dart';
import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/restaurant_post.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DineEase extends ChangeNotifier{
  final RequestUtil _requestUtil = RequestUtil();
  List<RestaurantPost> _restaurantList;
  List<RestaurantPost> _restaurantForEventList;
  List<RestaurantPost> _userFavorits;
  List<EventPost> _eventList;
  late int userId;
  late String email;
  late String role;
  late SharedPreferences prefs;

  DineEase() : _restaurantList = [], _restaurantForEventList= [], _userFavorits = [], email = '', role = '',userId = 0, _eventList = []{
  initApp();
  Logger().i('initialized, $_userFavorits');
}

void initApp() async {
  await getRestaurants();
  await initSharedPrefs();
  await getFavoritRestaurantsByUserId();
  await getEvents();
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
      if(restaurant.forEvent == false){
        Logger().i("false kene: $restaurant.forEvent");
      _restaurantList.add(RestaurantPost(
        id: restaurant.id,
        name: restaurant.name,
        rating: restaurant.rating,
        // rating: 4.0,
        isFavorite: false,
        imagePath: 'assets/test_images/kfc.jpeg'
      ));
      }
      else{
        Logger().i("true kene: $restaurant.forEvent");
        _restaurantForEventList.add(RestaurantPost(
        id: restaurant.id,
        name: restaurant.name,
        rating: restaurant.rating,
        // rating: 4.0,
        isFavorite: false,
        imagePath: 'assets/test_images/kfc.jpeg'
      ));
      }
      notifyListeners();
    }   
  }

  Future<void> getFavoritRestaurantsByUserId() async{
    //a userId-t a providerből kell lekérni
    List<Restaurant> restaurants = await _requestUtil.getFavoritRestaurantsByUserId(userId);
    // List<RestaurantPost> restaurantList = [];
    for(var restaurant in restaurants){
      _userFavorits.add(RestaurantPost(
        id: restaurant.id,
        name: restaurant.name,
        rating: restaurant.rating,
        // rating: 4.0,
        isFavorite: true,
        imagePath: 'assets/test_images/kfc.jpeg'
      ));
      //az adott id-ju restaurantot megkeresni a restaurantList-ben és az isFavorite értékét true-ra állítani
      for(var rest in _restaurantList){
        if(rest.id == restaurant.id){
          rest.isFavorite = true;
        }
      }
      notifyListeners();
    }   
  }

  Future<void> getEvents() async{
    List<Eventt> events = await _requestUtil.getEvents();
    // List<RestaurantPost> restaurantList = [];
    for(var event in events){
      _eventList.add(EventPost(
        id: event.id,
        eventName: event.eventName,
        restaurantId: event.restaurantId,
        restaurantName: event.restaurantName,
        description: event.description,
        startingDate: event.startingDate,
        endingDate: event.endingDate
        // rating: 4.0,
        // imagePath: 'assets/test_images/kfc.jpeg'
      ));
      notifyListeners();
    }   
  }
  
  //get restaurant by id
  RestaurantPost getRestaurantById(int id){
    return _restaurantList.firstWhere((element) => element.id == id);
  }

  //get restaurant list
  List<RestaurantPost> get restaurants => _restaurantList;

  //get user favorit list
  List<RestaurantPost> get userFavorits => _userFavorits;

  //get event list
  List<EventPost> get events => _eventList;

  //get restaurant for event list
  List<RestaurantPost> get restaurantForEventList => _restaurantForEventList;
  
  //add to favorit
  void addToFavorits(RestaurantPost restaurant) async{
    // add by using the request util
    Logger().i("userid"+userId.toString()+email+role);
    await _requestUtil.postAddFavoritRestaurant(userId, restaurant.id);
    _userFavorits.add(restaurant);
    //az adott id-ju restaurantot megkeresni a restaurantList-ben és az isFavorite értékét true-ra állítani
    for(var rest in _restaurantList){
      if(rest.id == restaurant.id){
        rest.isFavorite = true;
      }
    }
    notifyListeners();
  }

  //remove from favorit
  void removeFromFavorits(RestaurantPost restaurant) async{
    // remove by using the request util
    _userFavorits.remove(restaurant);
    //az adott id-ju restaurantot megkeresni a restaurantList-ben és az isFavorite értékét false-ra állítani
    for(var rest in _restaurantList){
      if(rest.id == restaurant.id){
        rest.isFavorite = false;
      }
    }
    await _requestUtil.deleteRemoveFavoritRestaurant(userId, restaurant.id);
    notifyListeners();
  }

  bool isFavorite(RestaurantPost restaurant){
    return _userFavorits.contains(restaurant);
  }

}