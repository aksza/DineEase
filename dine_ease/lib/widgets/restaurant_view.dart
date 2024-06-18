import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/screens/restaurant_details_screen.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';

class RestaurantView extends StatefulWidget {
  final Restaurant restaurant;
  void Function()? onPressed;

  RestaurantView({super.key, required this.restaurant, required this.onPressed});

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {

  late Restaurant selectedRestaurant;
  final RequestUtil _requestUtil = RequestUtil();

  @override
  void initState() {
    super.initState();
    getRestaurantByIdNew(widget.restaurant.id);
  }

  Future<Restaurant> getRestaurantById(int id) async{
    var srestaurant = await _requestUtil.getRestaurantById(id);
    return srestaurant;
  }

  Future<void> getRestaurantByIdNew(int id) async{
    var srestaurant = await getRestaurantById(id);
    setState(() {
      selectedRestaurant = srestaurant;
    });
  }


  @override
  Widget build(BuildContext context) {
    final bool isPhone = MediaQuery.of(context).size.shortestSide < 600;

    return 
    GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RestaurantDetails(selectedRestaurant: selectedRestaurant,)),
        );
      },
      child:
      Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: ListTile(
          title: Text(widget.restaurant.name),
          subtitle: Text((widget.restaurant.rating != null ? widget.restaurant.rating.toString() : '0') + ' ⭐'),
          leading: Image.asset(widget.restaurant.imagePath!, width: isPhone ? 50 : 100, height: isPhone ? 50 : 100, fit: BoxFit.cover,),
          trailing: IconButton(
            icon: Icon(widget.restaurant.isFavorite! ? Icons.favorite : Icons.favorite_border, color: Colors.orange[700]),
            onPressed: (){
              widget.onPressed!();
              setState(() {
                widget.restaurant.isFavorite = !widget.restaurant.isFavorite!;
              });
            },
          )
        ),
      )
    );
  }
}