import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/screens/restaurant_details_screen.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';

class RestaurantView extends StatefulWidget {
  final Restaurant restaurant;
  final void Function()? onPressed;

  RestaurantView({super.key, required this.restaurant, required this.onPressed});

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  final RequestUtil _requestUtil = RequestUtil();

  @override
  void initState() {
    super.initState();
    getRestaurantByIdNew(widget.restaurant.id);
  }

  Future<void> getRestaurantByIdNew(int id) async {
    var srestaurant = await _requestUtil.getRestaurantById(id);
    
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetails(selectedRestaurant: widget.restaurant),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //photo
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: _buildRestaurantImage(),
            ),
            //information
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //restaurant name and rating
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.restaurant.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        (widget.restaurant.rating != null ? widget.restaurant.rating.toString() : '0') + ' ⭐',
                      ),
                    ],
                  ),
                  //favorite icon button
                  if(widget.restaurant.isFavorite != null)
                  IconButton(
                    icon: Icon(
                      widget.restaurant.isFavorite! ? Icons.favorite : Icons.favorite_border,
                      color: Colors.orange[700],
                    ),
                    onPressed: () {
                      widget.onPressed!();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantImage() {
    if (widget.restaurant.imagePath != null && widget.restaurant.imagePath!.isNotEmpty) {
      return Image.network(
        widget.restaurant.imagePath![0].image!,
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/test_images/restaurant.png',
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
      );
    }
  }
}
