import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/e_category.dart';
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

  late List<EventPost> eventFy = [];
  late List<RestaurantPost> restaurantsWithMostReservations = [];
  late List<RestaurantPost> restaurantsMostRated = [];
  late List<RestaurantPost> restaurantsLastReservations = [];

  bool isLoading = true;

  DineEase() : _restaurantList = [], _restaurantForEventList= [], _userFavorits = [], email = '', role = '',userId = 0, _eventList = []{
  initApp();
  Logger().i('initialized, $_userFavorits');
}

void initApp() async {
  loadData();
}

  void loadData() async{
    await initSharedPrefs();
    await getRestaurants();
    await getRestaurantsMostRated();
    await getRestaurantsWithMostReservations();
    await getRestaurantsLastReservations();
    await getFavoritRestaurantsByUserId();
    await getEvents();
    await getEventsByFavoritRestaurant();
    isLoading = false;
    notifyListeners();
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

  //get restaurants with most reservations
  Future<void> getRestaurantsWithMostReservations() async {
    List<Restaurant> restaurants = await _requestUtil.getRestaurantsWithMostReservations();
    // setState(() {
    for(var restaurant in restaurants){
      Logger().i("false kene: $restaurant.forEvent");
      restaurantsWithMostReservations.add(RestaurantPost(
        id: restaurant.id,
        name: restaurant.name,
        rating: restaurant.rating,
        // rating: 4.0,
        isFavorite: false,
        imagePath: 'assets/test_images/kfc.jpeg'
      ));
      
      notifyListeners();
    }  
    // });
  }

  //get restaurants most rated
  Future<void> getRestaurantsMostRated() async {
    List<Restaurant> restaurants = await _requestUtil.getMostRatedRestaurants();
     for(var restaurant in restaurants){
      Logger().i("false kene: $restaurant.forEvent");
      restaurantsMostRated.add(RestaurantPost(
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

  //get restaurants last reservations
  Future<void> getRestaurantsLastReservations() async {
    int userId = await DataBaseProvider().getUserId();
    List<Restaurant> restaurants = await _requestUtil.getRestaurantsByLastFiveReservations(userId);
     for(var restaurant in restaurants){
      Logger().i("false kene: $restaurant.forEvent");
      restaurantsLastReservations.add(RestaurantPost(
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

  //getEventsByFavoritRestaurant
  Future<void> getEventsByFavoritRestaurant() async {
    var userId = await DataBaseProvider().getUserId();
    List<Eventt> event = await _requestUtil.getEventsByFavoritRestaurant(userId);
    for(var e in event){
      List<ECategory> categories = await _requestUtil.getECategoriesByEvent(e.id);
      eventFy.add(EventPost(
        id: e.id,
        eventName: e.eventName,
        restaurantId: e.restaurantId,
        restaurantName: e.restaurantName,
        description: e.description,
        startingDate: e.startingDate,
        endingDate: e.endingDate,
        eCategories: categories
        // rating: 4.0,
        // imagePath: 'assets/test_images/kfc.jpeg'
      ));
      notifyListeners();
    }   
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

      for(var rest in restaurantsWithMostReservations){
        if(rest.id == restaurant.id){
          rest.isFavorite = true;
        }
      }

      for(var rest in restaurantsMostRated){
        if(rest.id == restaurant.id){
          rest.isFavorite = true;
        }
      }

      for(var rest in restaurantsLastReservations){
        if(rest.id == restaurant.id){
          rest.isFavorite = true;
        }
      }

      for(var rest in _restaurantForEventList){
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
      List<ECategory> categories = await _requestUtil.getECategoriesByEvent(event.id);
      _eventList.add(EventPost(
        id: event.id,
        eventName: event.eventName,
        restaurantId: event.restaurantId,
        restaurantName: event.restaurantName,
        description: event.description,
        startingDate: event.startingDate,
        endingDate: event.endingDate,
        eCategories: categories
        // rating: 4.0,
        // imagePath: 'assets/test_images/kfc.jpeg'
      ));
      notifyListeners();
    }   
  }
  
  //get restaurant by id
  RestaurantPost? getRestaurantById(int id){
    //ha a restaurantlistben nem talalja meg az adott idju restaurantot akkor a restaurantforeventlistben keresi
    for(var restaurant in _restaurantList){
      if(restaurant.id == id){
        return restaurant;
      }
    }
    for(var restaurant in _restaurantForEventList){
      if(restaurant.id == id){
        return restaurant;
      }
    }
    return null;
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
    for(var rest in restaurantsWithMostReservations){
      if(rest.id == restaurant.id){
        rest.isFavorite = true;
      }
    }
    for(var rest in restaurantsMostRated){
      if(rest.id == restaurant.id){
        rest.isFavorite = true;
      }
    }
    for(var rest in restaurantsLastReservations){
      if(rest.id == restaurant.id){
        rest.isFavorite = true;
      }
    }
    
    for(var rest in _restaurantForEventList){
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
    for(var rest in restaurantsWithMostReservations){
      if(rest.id == restaurant.id){
        rest.isFavorite = false;
      }
    }
    for(var rest in restaurantsMostRated){
      if(rest.id == restaurant.id){
        rest.isFavorite = false;
      }
    }
    for(var rest in restaurantsLastReservations){
      if(rest.id == restaurant.id){
        rest.isFavorite = false;
      }
    }
    for(var rest in _restaurantForEventList){
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