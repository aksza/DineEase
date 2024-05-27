import 'package:dine_ease/models/dine_ease.dart';
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
    // showDialog(context: context, builder: (context)
    //   => AlertDialog(title: Text('Added to favorites')
    // ));
  }

  //remove from favorites
  void removeFromFavorits(RestaurantPost restaurant){
    Provider.of<DineEase>(context, listen: false).removeFromFavorits(restaurant);
    // showDialog(context: context, builder: (context)
    //   => AlertDialog(title: Text('Removed from favorites')
    // ));
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
                  //get restaurant
                  RestaurantPost restaurant = value.userFavorits[index];

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
    )
    );
  }
}
