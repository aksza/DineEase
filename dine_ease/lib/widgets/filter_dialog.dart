import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dine_ease/models/cuisine_model.dart';
import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/models/price_model.dart';
import 'package:dine_ease/models/r_category.dart';
import 'package:dine_ease/models/seating_model.dart';

class FilterDialog extends StatefulWidget {
  final List<Cuisine> selectedCuisines;
  final List<RCategory> selectedCategories;
  final List<Price> selectedPrices;
  final List<Seating> selectedSeatings;

  const FilterDialog({super.key, 
    required this.selectedCuisines,
    required this.selectedCategories,
    required this.selectedPrices,
    required this.selectedSeatings,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late List<Cuisine> _selectedCuisines;
  late List<RCategory> _selectedCategories;
  late List<Price> _selectedPrices;
  late List<Seating> _selectedSeatings;

  @override
  void initState() {
    super.initState();
    _selectedCuisines = List.from(widget.selectedCuisines);
    _selectedCategories = List.from(widget.selectedCategories);
    _selectedPrices = List.from(widget.selectedPrices);
    _selectedSeatings = List.from(widget.selectedSeatings);
  }

  @override
  Widget build(BuildContext context) {
    final dineEase = Provider.of<DineEase>(context);

    return AlertDialog(
      title: const Text('Filter Restaurants'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Cuisines',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              )
              ),
            ...dineEase.allCuisines.map((cuisine) {
              return CheckboxListTile(
                title: Text(cuisine.cuisineName),
                value: _selectedCuisines.contains(cuisine),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedCuisines.add(cuisine);
                    } else {
                      _selectedCuisines.remove(cuisine);
                    }
                  });
                },
              );
            }).toList(),
            const Text(
              'Categories',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              )
              ),
            ...dineEase.allRCategories.map((category) {
              return CheckboxListTile(
                title: Text(category.rCategoryName),
                value: _selectedCategories.contains(category),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedCategories.add(category);
                    } else {
                      _selectedCategories.remove(category);
                    }
                  });
                },
              );
            }).toList(),
            const Text(
              'Prices',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              )
            ),
            ...dineEase.allPrices.map((price) {
              return CheckboxListTile(
                title: Text(price.priceName),
                value: _selectedPrices.contains(price),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedPrices.add(price);
                    } else {
                      _selectedPrices.remove(price);
                    }
                  });
                },
              );
            }).toList(),
            const Text(
              'Seatings',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,)
              ),
            ...dineEase.allSeatings.map((seating) {
              return CheckboxListTile(
                title: Text(seating.seatingName),
                value: _selectedSeatings.contains(seating),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedSeatings.add(seating);
                    } else {
                      _selectedSeatings.remove(seating);
                    }
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, {
              'cuisines': _selectedCuisines,
              'categories': _selectedCategories,
              'prices': _selectedPrices,
              'seatings': _selectedSeatings,
            });
          },
          child: const Text('Search'),
        ),
      ],
    );
  }
}
