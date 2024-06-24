import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/widgets/restaurant_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantForEventPage extends StatefulWidget {
  const RestaurantForEventPage({super.key});

  @override
  State<RestaurantForEventPage> createState() => _RestaurantForEventPageState();
}

class _RestaurantForEventPageState extends State<RestaurantForEventPage> {

  void toggleFavorite(Restaurant restaurant) {
    setState(() {
      if (restaurant.isFavorite!) {
        Provider.of<DineEase>(context, listen: false).removeFromFavorits(restaurant);
        restaurant.isFavorite = false;
      } else {
        Provider.of<DineEase>(context, listen: false).addToFavorits(restaurant);
        restaurant.isFavorite = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DineEase>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: value.restaurantForEventList.length,
                  itemBuilder: (context,index){
                  Restaurant restaurant = value.restaurantForEventList[index];

                  return RestaurantView(
                    restaurant: restaurant,
                    onPressed: () => toggleFavorite(restaurant)
                    );
                  }
                )
              )
            ],
          ),
        )
      )
    );
  }
}
