import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/models/event_post_model.dart';
import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/restaurant_post.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/event_view.dart';
import 'package:dine_ease/widgets/restaurant_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({super.key});

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {

  late List<Eventt> events;
  late List<Restaurant> restaurantsWithMostReservations;
  late List<Restaurant> restaurantsMostRated;
  late List<Restaurant> restaurantsLastReservations;
  final RequestUtil _requestUtil = RequestUtil();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  //get restaurants with most reservations
  Future<void> getRestaurantsWithMostReservations() async {
    List<Restaurant> restaurants = await _requestUtil.getRestaurantsWithMostReservations();
    setState(() {
      restaurantsWithMostReservations = restaurants;
    });
  }

  //get restaurants most rated
  Future<void> getRestaurantsMostRated() async {
    List<Restaurant> restaurants = await _requestUtil.getMostRatedRestaurants();
    setState(() {
      restaurantsMostRated = restaurants;
    });
  }

  //get restaurants last reservations
  Future<void> getRestaurantsLastReservations() async {
    int userId = await DataBaseProvider().getUserId();
    List<Restaurant> restaurants = await _requestUtil.getRestaurantsByLastFiveReservations(userId);
    setState(() {
      restaurantsLastReservations = restaurants;
    });
  }

  //getEventsByFavoritRestaurant
  Future<void> getEventsByFavoritRestaurant() async {
    var userId = await DataBaseProvider().getUserId();
    List<Eventt> event = await _requestUtil.getEventsByFavoritRestaurant(userId);
    setState(() {
      events = event;
    });
  }

  void loadData() async{
    await getEventsByFavoritRestaurant();
    await getRestaurantsWithMostReservations();
    await getRestaurantsMostRated();
    await getRestaurantsLastReservations();
    setState(() {
      isLoading = false;
    });
  }

  //a function that checks whether a restaurant is in the favorites list and depending on that it adds or removes it
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
    return isLoading ? const Center(child: CircularProgressIndicator(),) :
    SafeArea(child: 
    Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Available for today
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trending',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: restaurantsWithMostReservations.length <= 3 ? restaurantsWithMostReservations.length : 3,
                    itemBuilder: (context, index) {
                      RestaurantPost restaurant = RestaurantPost(id: restaurantsWithMostReservations[index].id, name: restaurantsWithMostReservations[index].name, isFavorite: false, imagePath: "assets/test_images/kfc.jpeg");
                      return RestaurantView(restaurant: restaurant,onPressed: () => toggleFavorite(restaurant),);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'You may also like',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: restaurantsMostRated.length <= 3 ? restaurantsMostRated.length : 3,
                    itemBuilder: (context, index) {
                      RestaurantPost restaurant = RestaurantPost(id: restaurantsMostRated[index].id, name: restaurantsMostRated[index].name, isFavorite: false, imagePath: "assets/test_images/kfc.jpeg");
                      return RestaurantView(restaurant: restaurant,onPressed: () => toggleFavorite(restaurant),);
                    },
                  ),
                ],
              ),
            ),
            // Upcoming events, sorted by favorit restaurants
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recommended events',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListView.builder(
                    
                    shrinkWrap: true,
                    itemCount: events.length <= 2 ? events.length : 2,
                    itemBuilder: (context, index) {
                      EventPost event = EventPost(id: events[index].id, eventName: events[index].eventName, restaurantId: events[index].restaurantId, restaurantName: events[index].restaurantName, startingDate: events[index].startingDate, endingDate: events[index].endingDate);
                      return EventView(event: event
                      );
                    },
                  ),
                ],
              ),
            ),

            if(restaurantsLastReservations.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Did you like?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: restaurantsLastReservations.length <= 3 ? restaurantsLastReservations.length : 3,
                    itemBuilder: (context, index) {
                      RestaurantPost restaurant = RestaurantPost(id: restaurantsLastReservations[index].id, name: restaurantsLastReservations[index].name, isFavorite: false, imagePath: "assets/test_images/kfc.jpeg");
                      return RestaurantView(restaurant: restaurant,onPressed: () => toggleFavorite(restaurant),);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
    );
  }
}