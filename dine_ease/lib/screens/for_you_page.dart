import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/models/event_post_model.dart';
import 'package:dine_ease/models/restaurant_model.dart';
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
  @override
  void initState() {
    super.initState();
  }

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
      builder: (context, dineEase, child) {
        if (dineEase.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
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
                          itemCount: dineEase.restaurantsWithMostReservations.length <= 3 ? dineEase.restaurantsWithMostReservations.length : 3,
                          itemBuilder: (context, index) {
                            Restaurant restaurant = dineEase.restaurantsWithMostReservations[index];
                            return RestaurantView(
                              restaurant: restaurant,
                              onPressed: () => toggleFavorite(restaurant),
                            );
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
                          itemCount: dineEase.restaurantsMostRated.length <= 3 ? dineEase.restaurantsMostRated.length : 3,
                          itemBuilder: (context, index) {
                            Restaurant restaurant = dineEase.restaurantsMostRated[index];
                            return RestaurantView(
                              restaurant: restaurant,
                              onPressed: () => toggleFavorite(restaurant),
                            );
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
                          'Recommended events',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: dineEase.events.length <= 2 ? dineEase.events.length : 2,
                          itemBuilder: (context, index) {
                            EventPost event = dineEase.events[index];
                            return EventView(event: event);
                          },
                        ),
                      ],
                    ),
                  ),
                  if (dineEase.restaurantsLastReservations.isNotEmpty)
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
                            itemCount: dineEase.restaurantsLastReservations.length <= 3 ? dineEase.restaurantsLastReservations.length : 3,
                            itemBuilder: (context, index) {
                              Restaurant restaurant = dineEase.restaurantsLastReservations[index];
                              return RestaurantView(
                                restaurant: restaurant,
                                onPressed: () => toggleFavorite(restaurant),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
