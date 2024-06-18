import 'package:dine_ease/models/cuisine_model.dart';
import 'package:dine_ease/models/price_model.dart';
import 'package:dine_ease/models/r_category.dart';
import 'package:dine_ease/models/seating_model.dart';
import 'package:dine_ease/widgets/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/widgets/restaurant_view.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  List<Restaurant> _filteredRestaurants = [];
  List<Cuisine> _filterByCuisine = [];
  List<RCategory> _filterByCategory = [];
  List<Price> _filterByPrice = [];
  List<Seating> _filterBySeating = [];

  @override
  void initState() {
    super.initState();
    _filteredRestaurants = Provider.of<DineEase>(context, listen: false).restaurants;
  }

  void _showFilterDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return FilterDialog(
          selectedCuisines: _filterByCuisine,
          selectedCategories: _filterByCategory,
          selectedPrices: _filterByPrice,
          selectedSeatings: _filterBySeating,
        );
      },
    );

    if (result != null) {
      setState(() {
        _filterByCuisine = result['cuisines'];
        _filterByCategory = result['categories'];
        _filterByPrice = result['prices'];
        _filterBySeating = result['seatings'];
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
  final dineEase = Provider.of<DineEase>(context, listen: false);
  setState(() {
    _filteredRestaurants = dineEase.restaurants.where((restaurant) {
      final cuisineMatch = _filterByCuisine.isEmpty ||
          (restaurant.cuisines != null &&
              restaurant.cuisines!.any((cuisine) => _filterByCuisine.any((filterCuisine) => filterCuisine.id == cuisine.id)));
      final categoryMatch = _filterByCategory.isEmpty ||
          (restaurant.categories != null &&
              restaurant.categories!.any((category) => _filterByCategory.any((filterCategory) => filterCategory.id == category.id)));
      final priceMatch = _filterByPrice.isEmpty ||
          _filterByPrice.any((price) => price.priceName == restaurant.price);
      final seatingMatch = _filterBySeating.isEmpty ||
          (restaurant.seatings != null &&
              restaurant.seatings!.any((seating) => _filterBySeating.any((filterSeating) => filterSeating.id == seating.id)));
      return cuisineMatch && categoryMatch && priceMatch && seatingMatch;
    }).toList();
  });
}



  void toggleFavorite(Restaurant restaurant) {
    if (Provider.of<DineEase>(context, listen: false).isFavorite(restaurant)) {
      removeFromFavorits(restaurant);
    } else {
      addToFavorits(restaurant);
    }
  }

  void addToFavorits(Restaurant restaurant) {
    Provider.of<DineEase>(context, listen: false).addToFavorits(restaurant);
  }

  void removeFromFavorits(Restaurant restaurant) {
    Provider.of<DineEase>(context, listen: false).removeFromFavorits(restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DineEase>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0,8,25,25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.filter_alt_sharp),
                    onPressed: _showFilterDialog,
                  ),
                ],
              ),
              // List of restaurants
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredRestaurants.length,
                  itemBuilder: (context, index) {
                    // Get restaurant
                    Restaurant restaurant = _filteredRestaurants[index];

                    // Return the tile for this restaurant
                    return RestaurantView(
                      restaurant: restaurant,
                      onPressed: () => toggleFavorite(restaurant),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
