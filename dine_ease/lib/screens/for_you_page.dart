import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/models/event_post_model.dart';
import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/models/restaurant_post.dart';
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
    // showDialog(context: context, builder: 
    //   (context) => AlertDialog(title: Text('Added to favorites')
    //   ));
  }
  //remove from favorites
  void removeFromFavorits(RestaurantPost restaurant){
    Provider.of<DineEase>(context, listen: false).removeFromFavorits(restaurant);
    // showDialog(context: context, builder: 
    //   (context) => AlertDialog(title: Text('Removed from favorites')
    //   ));
  }

  @override
  Widget build(BuildContext context) {
    //egy scrollview, amiben van 3 sor, amiben az elsoben Upcoming events, a masodikban a Favorit restaurants, harmadikban Available for today
    return Consumer<DineEase>(builder: (context, value, child) =>
    SafeArea(child: 
    Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Upcoming events
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming events',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // ListView.builder, amiben az eventek vannak
                  ListView.builder(
                    
                    shrinkWrap: true,
                    itemCount: value.events.length <= 2 ? value.events.length : 2,
                    itemBuilder: (context, index) {
                      // return ListTile(
                      //   title: Text('Event $index'),
                      // );\
                      EventPost event = value.events[index];
                      return EventView(event: event
                  
                      // EventPost(
                      //   id: index,
                      //   eventName: 'Event $index',
                      //   restaurantId: index,
                      //   restaurantName: 'Restaurant $index',
                      //   description: 'Description $index',
                      //   startingDate: DateTime.now(),
                      //   endingDate: DateTime.now(),
                      // )

                      );
                    },
                  ),
                  SizedBox(height: 10,),
                  //text see more in orange
                  Text('See more', style: TextStyle(color: const Color.fromARGB(255, 255, 136, 0)),),
                ],
                             
              ),
            ),
            // Favorit restaurants
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Favorit restaurants',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // ListView.builder, amiben a restaurantek vannak
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: value.userFavorits.length <= 2 ? value.userFavorits.length : 2,
                    itemBuilder: (context, index) {
                      RestaurantPost favorit = value.userFavorits[index];
                      return RestaurantView(restaurant: favorit,onPressed: () => toggleFavorite(favorit),);
                    },
                  ),
                  SizedBox(height: 10,),
                  //text see more in orange
                  Text('See more', style: TextStyle(color: const Color.fromARGB(255, 255, 136, 0)),),
             
                ],
              ),
            ),
            // Available for today
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available for today',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // ListView.builder, amiben a restaurantek vannak
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: value.restaurants.length <= 3 ? value.restaurants.length : 3,
                    itemBuilder: (context, index) {
                      RestaurantPost restaurant = value.restaurants[index];
                      return RestaurantView(restaurant: restaurant,onPressed: () => toggleFavorite(restaurant),);
                    },
                  ),
                  SizedBox(height: 10,),
                  //text see more in orange
                  Text('See more', style: TextStyle(color: const Color.fromARGB(255, 255, 136, 0)),),
             
                ],
              ),
            ),
          ],
        ),
      ),
    )
    )
    );
  }
}