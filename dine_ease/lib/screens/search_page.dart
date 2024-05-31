import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/models/event_post_model.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/restaurant_post.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/event_view.dart';
import 'package:dine_ease/widgets/restaurant_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SearchPage extends StatefulWidget {
  static const routeName = '/search';

  final String? query;

  SearchPage({Key? key, this.query}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SharedPreferences prefs;
  late int userId;
  final RequestUtil _requestUtil = RequestUtil();
  bool isLoading = true;
  late List<RestaurantPost> restaurants;
  late List<EventPost> events;

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId')!;
    });
    searchRestaurants();
    searchEvents();
  }

  void searchRestaurants() async {
    var resp = await _requestUtil.searchRestaurants(widget.query!);
    if (resp != null) {
      setState(() {
        restaurants = resp.map((restaurant) => RestaurantPost(
          id: restaurant.id,
          name: restaurant.name,
          isFavorite: false,
          imagePath: 'assets/test_images/kfc.jpeg',
        )).toList();
      });
      getFavoriteRestaurantsByUserId();
    }
  }  

  void searchEvents() async {
    var resp = await _requestUtil.searchEvents(widget.query!);
    if (resp != null) {
      setState(() {
        events = resp.map((event) => EventPost(
          id: event.id,
          eventName: event.eventName,
          restaurantId: event.restaurantId,
          restaurantName: event.restaurantName,
          startingDate: event.startingDate,
          endingDate: event.endingDate,
        )).toList();
      });
    }
  }

  void getFavoriteRestaurantsByUserId() async {
    var resp = await _requestUtil.getFavoritRestaurantsByUserId(userId);
    for (var restaurant in resp) {
      for (var fav in restaurants) {
        if (fav.id == restaurant.id) {
          setState(() {
            fav.isFavorite = true;
          });
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }
  
  void toggleFavorite(RestaurantPost restaurant){
    if(Provider.of<DineEase>(context, listen: false).isFavorite(restaurant)){
      removeFromFavorits(restaurant);
    }else{
      addToFavorits(restaurant);
    }
  }
  //add to favorites
  void addToFavorits(RestaurantPost restaurant){
    Provider.of<DineEase>(context, listen: false).addToFavorits(restaurant);
    
  }
  //remove from favorites
  void removeFromFavorits(RestaurantPost restaurant){
    Provider.of<DineEase>(context, listen: false).removeFromFavorits(restaurant);
    
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Searching for: "${widget.query}"',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Restaurants',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              restaurants.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Restaurant not found'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      return RestaurantView(
                        restaurant: restaurants[index],
                        onPressed: () => toggleFavorite(restaurants[index])
                      );
                    },
                  ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Events',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              events.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Event not found'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return EventView(event: events[index]);
                    },
                  ),
            ],
          ),
        ),
    );
  }
}
