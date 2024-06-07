import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/cuisine_model.dart';
import 'package:dine_ease/models/cuisines_restaurant_model.dart';
import 'package:dine_ease/models/opening_model.dart';
import 'package:dine_ease/models/price_model.dart';
import 'package:dine_ease/models/r_category.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/review_models.dart';
import 'package:dine_ease/models/seating_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:dine_ease/widgets/custom_text_field.dart';

class RProfileScreen extends StatefulWidget {
  static const routeName = '/r_profile';

  const RProfileScreen({super.key});

  @override
  State<RProfileScreen> createState() => _RProfileScreenState();
}

class _RProfileScreenState extends State<RProfileScreen> {
  final RequestUtil _requestUtil = RequestUtil();
  late Restaurant restaurant;
  bool isLoading = true;

  //textcontroller for the form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _maxTableCapacityController = TextEditingController();
  
  List<Cuisine> allCuisine = [];
  List<RCategory> allCategories = [];
  List<Seating> allSeatings = [];
  List<Price> allPrices = [];
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    fetchRestaurant();
    super.initState();
  }

  //fetch restaurant data
  void fetchRestaurant() async {
    var resid = await DataBaseProvider().getUserId();

    try {
      Restaurant response = await _requestUtil.getRestaurantById(resid);
      //fetch category, cuisine, opening, seating, reviews 
      List<RCategory>? categories = await _requestUtil.getRCategoriesByRestaurantId(resid);
      List<Cuisine>? cuisines = await _requestUtil.getCuisinesByRestaurantId(resid);
      List<Opening>? openings = await _requestUtil.getOpeningsByRestaurantId(resid);
      List<Seating>? seatings = await _requestUtil.getSeatingsByRestaurantId(resid);
      List<Review>? reviews = await _requestUtil.getReviewsByRestaurantId(resid);

      response.categories = categories;
      response.cuisines = cuisines;
      response.openings = openings;
      response.seatings = seatings;
      response.reviews = reviews;

      allCuisine = await _requestUtil.getCuisines();
      allCategories = await _requestUtil.getRcategories();
      allSeatings = await _requestUtil.getSeatings();
      allPrices = await _requestUtil.getPrices();

      setState(() {
        restaurant = response;
        allCuisine = allCuisine;
        allCategories = allCategories;
        allSeatings = allSeatings;
        allPrices = allPrices;
        isLoading = false;
      });
    } catch (error) {
      rethrow;
    }
  }

  //update restaurant
  void updateRestaurant(Restaurant restaurant) async {
    try {
      await _requestUtil.putUpdateRestaurant(restaurant);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Restaurant updated successfully'),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to update restaurant'),
      ));
    }
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (!RegExp(r'^[0-9]{9,12}$').hasMatch(value)) {
      return 'Phone number must be between 9 and 12 digits';
    }
    return null;
  }

  String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Only numbers are allowed';
    }
    return null;
  }

  //addcuisinerestaurant
  void addCuisineToRestaurant(List<Cuisine> cuisines) async {
    try {
      List<CuisineRestaurant> cuisineRestaurants = [];
      for (var cuisine in cuisines) {
        cuisineRestaurants.add(CuisineRestaurant(
          cuisineId: cuisine.id,
          restaurantId: restaurant.id,
        ));
      }
        
      await _requestUtil.postAddCuisinesRestaurant(cuisineRestaurants);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cuisine added to restaurant successfully'),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to add cuisine to restaurant'),
      ));
    }
  }

  void _showCuisineSelectionDialog() {
  showDialog(
    context: context,
    builder: (context) {
      List<Cuisine> selectedCuisines = List.from(restaurant.cuisines ?? []);
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Select Cuisines'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: allCuisine.length,
                itemBuilder: (context, index) {
                  final cuisine = allCuisine[index];
                  final isSelected = selectedCuisines.any((selectedCuisine) => selectedCuisine.id == cuisine.id);
                  return CheckboxListTile(
                    title: Text(cuisine.cuisineName),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (!selectedCuisines.any((selectedCuisine) => selectedCuisine.id == cuisine.id)) {
                            selectedCuisines.add(cuisine);
                          }
                        } else {
                          selectedCuisines.removeWhere((selectedCuisine) => selectedCuisine.id == cuisine.id);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    restaurant.cuisines = selectedCuisines;
                  });
                  addCuisineToRestaurant(selectedCuisines);
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    },
  );
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //text - edit restaurant profile
                      const Text(
                        'Edit Restaurant Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyTextField(
                          controller: _nameController..text = restaurant.name,
                          hintText: 'Name',
                          obscureText: false,
                        ),
                      ),
                      // address
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyTextField(
                          controller: _addressController..text = restaurant.address,
                          hintText: 'Address',
                          obscureText: false,
                        ),
                      ),
                      // phone number
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyTextField(
                          controller: _phoneNumController..text = restaurant.phoneNum,
                          hintText: 'Phone Number',
                          obscureText: false,
                          validator: validatePhoneNumber,
                        ),
                      ),
                      // email
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyTextField(
                          controller: _emailController..text = restaurant.email,
                          hintText: 'Email',
                          obscureText: false,
                        ),
                      ),
                      // description
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyTextField(
                          controller: _descriptionController..text = restaurant.description ?? '',
                          hintText: 'Description',
                          obscureText: false,
                        ),
                      ),
                      // max table capacity
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyTextField(
                          controller: _maxTableCapacityController..text = restaurant.maxTableCapacity.toString(),
                          hintText: 'Max Table Capacity',
                          obscureText: false,
                          validator: validateNumber,
                        ),
                      ),
                      //text "Cuisines"
                      const Text(
                        'Cuisines',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Cuisines
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8.0,
                          children: restaurant.cuisines?.map((cuisine) {
                            return Chip(
                              label: Text(cuisine.cuisineName),
                            );
                          }).toList() ?? [],
                        ),
                      ),
                      TextButton(
                        onPressed: _showCuisineSelectionDialog,
                        child: Text('+ Add Cuisine'),
                      ),
                      // submit button
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // update restaurant
                            Restaurant updatedRestaurant = Restaurant(
                              id: restaurant.id,
                              name: _nameController.text,
                              address: _addressController.text,
                              phoneNum: _phoneNumController.text,
                              email: _emailController.text,
                              description: _descriptionController.text,
                              priceId: restaurant.priceId,
                              price: restaurant.price,
                              ownerId: restaurant.ownerId,
                              maxTableCapacity: int.parse(_maxTableCapacityController.text),
                              forEvent: restaurant.forEvent,
                              categories: restaurant.categories,
                              cuisines: restaurant.cuisines,
                              openings: restaurant.openings,
                              seatings: restaurant.seatings,
                              reviews: restaurant.reviews,
                            );
                            updateRestaurant(updatedRestaurant);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Please fix the errors in the form'),
                            ));
                          }
                        },
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
