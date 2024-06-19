import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/cuisine_model.dart';
import 'package:dine_ease/models/e_category.dart';
import 'package:dine_ease/models/event_post_model.dart';
import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/models/price_model.dart';
import 'package:dine_ease/models/r_category.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/restaurant_post.dart';
import 'package:dine_ease/models/seating_model.dart';
import 'package:dine_ease/models/upload_restaurant_image.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DineEase extends ChangeNotifier{
  final RequestUtil _requestUtil = RequestUtil();
  List<Restaurant> _restaurantList;
  List<Restaurant> _restaurantForEventList;
  List<Restaurant> _userFavorits;
  List<EventPost> _eventList;
  late int userId;
  late String email;
  late String role;
  late SharedPreferences prefs;

  late List<EventPost> eventFy = [];
  late List<Restaurant> restaurantsWithMostReservations = [];
  late List<Restaurant> restaurantsMostRated = [];
  late List<Restaurant> restaurantsLastReservations = [];

  
  List<Cuisine> _allCuisine = [];
  List<RCategory> _allCategories = [];
  List<Seating> _allSeatings = [];
  List<Price> _allPrices = [];

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

    _allCuisine = await _requestUtil.getCuisines();
    _allCategories = await _requestUtil.getRcategories();
    _allSeatings = await _requestUtil.getSeatings();
    _allPrices = await _requestUtil.getPrices();

    isLoading = false;
    notifyListeners();
  }

  Future<void> initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userId = await DataBaseProvider().getUserId();
    email = await DataBaseProvider().getEmail();
    role = await DataBaseProvider().getRole();
    notifyListeners();
    Logger().i('Shared prefs initialized: $userId, $email, $role');
  }

  //get restaurants with most reservations
  Future<void> getRestaurantsWithMostReservations() async {
    List<Restaurant> restaurants = await _requestUtil.getRestaurantsWithMostReservations();
    for(var restaurant in restaurants){
      Logger().i("false kene: $restaurant.forEvent");
    
      restaurant.isFavorite = false;
      List<UploadImages>? imagePaths = await _requestUtil.getPhotosByRestaurantId(restaurant.id);
      restaurant.imagePath = imagePaths;
      restaurantsWithMostReservations.add(restaurant);
      
      notifyListeners();
    }  
    // });
  }

  //get restaurants most rated
  Future<void> getRestaurantsMostRated() async {
    List<Restaurant> restaurants = await _requestUtil.getMostRatedRestaurants();
     for(var restaurant in restaurants){
      Logger().i("false kene: $restaurant.forEvent");

      restaurant.isFavorite = false;
      List<UploadImages>? imagePaths = await _requestUtil.getPhotosByRestaurantId(restaurant.id);
      restaurant.imagePath = imagePaths;
      restaurantsMostRated.add(restaurant);

      notifyListeners();
    }  
  }

  //get restaurants last reservations
  Future<void> getRestaurantsLastReservations() async {
    int userId = await DataBaseProvider().getUserId();
    List<Restaurant> restaurants = await _requestUtil.getRestaurantsByLastFiveReservations(userId);
     for(var restaurant in restaurants){
      Logger().i("false kene: $restaurant.forEvent");

      restaurant.isFavorite = false;
      List<UploadImages>? imagePaths = await _requestUtil.getPhotosByRestaurantId(restaurant.id);
      restaurant.imagePath = imagePaths;
      restaurantsLastReservations.add(restaurant);

      
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
        var categories = await _requestUtil.getRCategoriesByRestaurantId(restaurant.id);
        var cuisines = await _requestUtil.getCuisinesByRestaurantId(restaurant.id);
        var seatings = await _requestUtil.getSeatingsByRestaurantId(restaurant.id);
        restaurant.isFavorite = false;
        List<UploadImages>? imagePaths = await _requestUtil.getPhotosByRestaurantId(restaurant.id);
      restaurant.imagePath = imagePaths;
        restaurant.categories = categories;
        restaurant.cuisines = cuisines;
        restaurant.seatings = seatings;
        Logger().i("cuisines: $cuisines");
        _restaurantList.add(restaurant);

      }
      else{
        Logger().i("true kene: $restaurant.forEvent");

        var categories = await _requestUtil.getRCategoriesByRestaurantId(restaurant.id);
        var cuisines = await _requestUtil.getCuisinesByRestaurantId(restaurant.id);
        var seatings = await _requestUtil.getSeatingsByRestaurantId(restaurant.id);
        restaurant.isFavorite = false;
        List<UploadImages>? imagePaths = await _requestUtil.getPhotosByRestaurantId(restaurant.id);
      restaurant.imagePath = imagePaths;
        restaurant.categories = categories;
        restaurant.cuisines = cuisines;
        restaurant.seatings = seatings;
        _restaurantForEventList.add(restaurant);
      }
      notifyListeners();
    }   
  }

  Future<void> getFavoritRestaurantsByUserId() async{
    //a userId-t a providerből kell lekérni
    List<Restaurant> restaurants = await _requestUtil.getFavoritRestaurantsByUserId(userId);
    // List<RestaurantPost> restaurantList = [];

    for(var restaurant in restaurants){

      Set<int> addedRestaurantIds = _userFavorits.map((restaurant) => restaurant.id).toSet();

      restaurant.isFavorite = true;
      List<UploadImages>? imagePaths = await _requestUtil.getPhotosByRestaurantId(restaurant.id);
      restaurant.imagePath = imagePaths;

      if(!addedRestaurantIds.contains(restaurant.id)){
        _userFavorits.add(restaurant);
      }
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
      ));
      notifyListeners();
    }   
  }
  
  //get restaurant by id
  Restaurant? getRestaurantById(int id){
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
  List<Restaurant> get restaurants => _restaurantList;

  //get user favorit list
  List<Restaurant> get userFavorits => _userFavorits;

  //get event list
  List<EventPost> get events => _eventList;

  //get restaurant for event list
  List<Restaurant> get restaurantForEventList => _restaurantForEventList;

  //get all cuisine
  List<Cuisine> get allCuisines => _allCuisine;

  //get all categories
  List<RCategory> get allRCategories => _allCategories;

  //get all seatings
  List<Seating> get allSeatings => _allSeatings;

  //get all prices
  List<Price> get allPrices => _allPrices;
  
  //add to favorit
  void addToFavorits(Restaurant restaurant) async{
    // add by using the request util
    Logger().i("userid"+userId.toString()+email+role);
    await _requestUtil.postAddFavoritRestaurant(userId, restaurant.id);
    //added restaurant to userFavorits
    var addedRestaurantIds = _userFavorits.map((restaurant) => restaurant.id).toSet();
    if(!addedRestaurantIds.contains(restaurant.id)) {
      restaurant.isFavorite = true;
      _userFavorits.add(restaurant);
    }
  
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
  void removeFromFavorits(Restaurant restaurant) async{
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

  bool isFavorite(Restaurant restaurant){
    return _userFavorits.contains(restaurant);
  }

}