import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/models/restaurant_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantView extends StatefulWidget {
  final RestaurantPost restaurant;
  void Function()? onPressed;

  RestaurantView({super.key, required this.restaurant, required this.onPressed});

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {

  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.shortestSide < 600;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child: ListTile(
        title: Text(widget.restaurant.name),
        subtitle: Text((widget.restaurant.rating != null ? widget.restaurant.rating.toString() : '0') + ' ⭐'),
        leading: Image.asset(widget.restaurant.imagePath, width: isPhone ? 50 : 100, height: isPhone ? 50 : 100, fit: BoxFit.cover,),
        trailing: IconButton(
          icon: Icon(widget.restaurant.isFavorite ? Icons.favorite : Icons.favorite_border),
          onPressed: (){
            widget.onPressed!();
            setState(() {
              widget.restaurant.isFavorite = !widget.restaurant.isFavorite;
            });
          },
        )
      ),
    );
  }
}