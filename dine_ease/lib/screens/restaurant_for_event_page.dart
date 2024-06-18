import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/restaurant_post.dart';
import 'package:dine_ease/widgets/restaurant_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantForEventPage extends StatefulWidget {
  const RestaurantForEventPage({super.key});

  @override
  State<RestaurantForEventPage> createState() => _RestaurantForEventPageState();
}

class _RestaurantForEventPageState extends State<RestaurantForEventPage> {

  //a function that checks whether a restaurant is in the favorites list and depending on that it adds or removes it
  void toggleFavorite(Restaurant restaurant){
    if(Provider.of<DineEase>(context, listen: false).isFavorite(restaurant)){
      removeFromFavorits(restaurant);
    }else{
      addToFavorits(restaurant);
    }
  }
  //add to favorites
  void addToFavorits(Restaurant restaurant){
    Provider.of<DineEase>(context, listen: false).addToFavorits(restaurant);
    // showDialog(context: context, builder: 
    //   (context) => AlertDialog(title: Text('Added to favorites')
    //   ));
  }
  //remove from favorites
  void removeFromFavorits(Restaurant restaurant){
    Provider.of<DineEase>(context, listen: false).removeFromFavorits(restaurant);
    // showDialog(context: context, builder: 
    //   (context) => AlertDialog(title: Text('Removed from favorites')
    //   ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DineEase>(builder: (context,value,child) =>
      SafeArea(child: 
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              //list of restaurants
              Expanded(
                child: ListView.builder(
                  itemCount: value.restaurantForEventList.length,
                  itemBuilder: (context,index){
                  //get restaurant
                  Restaurant restaurant = value.restaurantForEventList[index];

                  //return the tile for this restaurant
                  return RestaurantView(
                    restaurant: restaurant,
                    onPressed: () => toggleFavorite(restaurant)
                    );

                }),
              )
            ],
          ),
        )
      )
    );
  }
}