import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/restaurant_post.dart';
import 'package:dine_ease/widgets/restaurant_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritsPage extends StatefulWidget {
  static const routeName = '/favorits';
  const FavoritsPage({super.key});

  @override
  State<FavoritsPage> createState() => _FavoritsPageState();
}

class _FavoritsPageState extends State<FavoritsPage> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Your favorits'),
      ),
      body: Consumer<DineEase>(builder: (context,value,child) =>
      SafeArea(child: 
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: value.userFavorits.length,
                  itemBuilder: (context,index){
                  Restaurant restaurant = value.userFavorits[index];

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
    )
    );
  }
}
