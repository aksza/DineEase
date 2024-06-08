import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/categories_restaurant_model.dart';
import 'package:dine_ease/models/cuisine_model.dart';
import 'package:dine_ease/models/cuisines_restaurant_model.dart';
import 'package:dine_ease/models/opening_model.dart';
import 'package:dine_ease/models/price_model.dart';
import 'package:dine_ease/models/r_category.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/review_models.dart';
import 'package:dine_ease/models/seating_model.dart';
import 'package:dine_ease/models/seatings_restaurant_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:dine_ease/widgets/custom_text_field.dart';
import 'package:logger/logger.dart';

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
      
      if(cuisineRestaurants.isNotEmpty){
        await _requestUtil.postAddCuisinesRestaurant(cuisineRestaurants);
        setState(() {
          restaurant.cuisines = [];
          restaurant.cuisines?.addAll(cuisines);
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to add cuisine to restaurant'),
      ));
    }
  }

  //removecuisinerestaurant
  void removeCuisineFromRestaurant(List<Cuisine> cuisines) async {
    try {
      List<CuisineRestaurant> cuisineRestaurants = [];
      for (var cuisine in cuisines) {
        cuisineRestaurants.add(CuisineRestaurant(
          cuisineId: cuisine.id,
          restaurantId: restaurant.id,
        ));
      }
      
      if (cuisineRestaurants.isNotEmpty)
      {
        await _requestUtil.deleteRemoveCuisineRestaurant(cuisineRestaurants);
        setState(() {
          restaurant.cuisines?.removeWhere((cuisine) => cuisines.contains(cuisine));
        });
      }
      
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to remove cuisine from restaurant'),
      ));
    }
  }

  //addseatingrestaurant
  void addSeatingToRestaurant(List<Seating> seatings) async {
    try {
      List<SeatingRestaurant> seatingRestaurants = [];
      for (var seating in seatings) {
        seatingRestaurants.add(SeatingRestaurant(
          seatingId: seating.id,
          restaurantId: restaurant.id,
        ));
      }
      
      if(seatingRestaurants.isNotEmpty){
        await _requestUtil.postAddSeatingRestaurant(seatingRestaurants);
        setState(() {
          restaurant.seatings = [];
          restaurant.seatings?.addAll(seatings);
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to add seating to restaurant'),
      ));
    }
  }

  //removeseatingrestaurant
  void removeSeatingFromRestaurant(List<Seating> seatings) async {
    try {
      List<SeatingRestaurant> seatingRestaurants = [];
      for (var seating in seatings) {
        seatingRestaurants.add(SeatingRestaurant(
          seatingId: seating.id,
          restaurantId: restaurant.id,
        ));
      }
      
      if (seatingRestaurants.isNotEmpty)
      {
        await _requestUtil.deleteRemoveSeatingRestaurant(seatingRestaurants);
        setState(() {
          restaurant.seatings?.removeWhere((seating) => seatings.contains(seating));
        });
      }
      
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to remove seating from restaurant'),
      ));
    }
  }

  //addcategoryrestaurant
  void addCategoryToRestaurant(List<RCategory> categories) async {
    try {
      List<CategoriesRestaurant> categoryRestaurants = [];
      for (var category in categories) {
        categoryRestaurants.add(CategoriesRestaurant(
          rCategoryId: category.id,
          restaurantId: restaurant.id,
        ));
      }
      
      if(categoryRestaurants.isNotEmpty){
        await _requestUtil.postAddCategoriesRestaurant(categoryRestaurants);
        setState(() {
          restaurant.categories = [];
          restaurant.categories?.addAll(categories);
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to add category to restaurant'),
      ));
    }
  }

  //removecategoryrestaurant
  void removeCategoryFromRestaurant(List<RCategory> categories) async {
    try {
      List<CategoriesRestaurant> categoryRestaurants = [];
      for (var category in categories) {
        categoryRestaurants.add(CategoriesRestaurant(
          rCategoryId: category.id,
          restaurantId: restaurant.id,
        ));
      }
      
      if (categoryRestaurants.isNotEmpty)
      {
        await _requestUtil.deleteRemoveCategoriesRestaurant(categoryRestaurants);
        setState(() {
          restaurant.categories?.removeWhere((category) => categories.contains(category));
        });
      }
      
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to remove category from restaurant'),
      ));
    }
  }

  void _showSelectionDialog<T>({
  required String title,
  required List<T> allItems,
  required List<T> selectedItems,
  required Function(List<T>) onAdd,
  required Function(List<T>) onRemove,
  required String Function(T) itemLabel,
  required bool Function(T, T) itemEquality, // Equality function for items
  }) {
    showDialog(
      context: context,
      builder: (context) {
        List<T> currentSelectedItems = List.from(selectedItems);
        List<T> unselectedItems = [];
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: Container(
                width: double.maxFinite,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6, // Ensure it is scrollable
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allItems.length,
                  itemBuilder: (context, index) {
                    final item = allItems[index];
                    final isSelected = currentSelectedItems.any((selectedItem) => itemEquality(selectedItem, item));
                    return CheckboxListTile(
                      title: Text(itemLabel(item)),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (!currentSelectedItems.any((selectedItem) => itemEquality(selectedItem, item))) {
                              currentSelectedItems.add(item);
                              unselectedItems.removeWhere((unselectedItem) => itemEquality(unselectedItem, item));
                            }
                          } else {
                            currentSelectedItems.removeWhere((selectedItem) => itemEquality(selectedItem, item));
                            unselectedItems.add(item);
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
                    onAdd(currentSelectedItems);
                    onRemove(unselectedItems);
                    setState(() {
                      selectedItems = currentSelectedItems;
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Items updated successfully'),
                    ));
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

  void _showCuisineSelectionDialog() {
    _showSelectionDialog<Cuisine>(
      title: 'Select Cuisines',
      allItems: allCuisine,
      selectedItems: restaurant.cuisines ?? [],
      onAdd: (selectedCuisines) => addCuisineToRestaurant(selectedCuisines),
      onRemove: (unselectedCuisines) => removeCuisineFromRestaurant(unselectedCuisines),
      itemLabel: (cuisine) => cuisine.cuisineName,
      itemEquality: (c1, c2) => c1.id == c2.id, 
    );
  }

  void _showSeatingSelectionDialog() {
    _showSelectionDialog<Seating>(
      title: 'Select Seatings',
      allItems: allSeatings,
      selectedItems: restaurant.seatings ?? [],
      onAdd: (selectedSeatings) => addSeatingToRestaurant(selectedSeatings),
      onRemove: (unselectedSeatings) => removeSeatingFromRestaurant(unselectedSeatings),
      itemLabel: (seating) => seating.seatingName,
      itemEquality: (s1, s2) => s1.id == s2.id, 
    );
  }

  void _showCategorySelectionDialog() {
    _showSelectionDialog<RCategory>(
      title: 'Select Categories',
      allItems: allCategories,
      selectedItems: restaurant.categories ?? [],
      onAdd: (selectedCategories) => addCategoryToRestaurant(selectedCategories),
      onRemove: (unselectedCategories) => removeCategoryFromRestaurant(unselectedCategories),
      itemLabel: (category) => category.rCategoryName,
      itemEquality: (c1, c2) => c1.id == c2.id, 
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

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Price category', 
                              style: 
                                TextStyle(fontSize: 20, 
                                fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left
                              ),
                              //space between
                              const SizedBox(width: 20),
                              DropdownButton(
                                value: restaurant.priceId! - 1,
                                items: const [
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('Cheap'),
                        
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text('Average'),
                                  ),
                                  DropdownMenuItem(
                                    value: 3,
                                    child: Text('Expensive'),
                                  ),
                                ],
                                onChanged: (int? value){
                                  setState(() {
                                    restaurant.priceId = value! + 1;
                                    value = restaurant.priceId! - 1;
                                    restaurant.price = allPrices[value! - 1].priceName;
                                  });
                                  Logger().i('${restaurant.priceId} ${restaurant.price}');
                                },
                              )
                          ]
                        ),
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
                      //elvalaszto vonal
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      //text Edit Restaurant details
                      const Text(
                        'Edit Restaurant Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //text "Cuisines"
                      const Text(
                        'Cuisines',
                        style: TextStyle(
                          fontSize: 20,
                          // fontStyle: FontStyle.italic,
                        ),
                      ),
                      // Cuisines
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8.0,
                          children: restaurant.cuisines?.map((cuisine) {
                            return Chip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              label: Text(cuisine.cuisineName),
                            );
                          }).toList() ?? [],
                        ),
                      ),
                      TextButton(
                        onPressed: _showCuisineSelectionDialog,
                        child: Text('+ Add Cuisine'),
                      ),

                      //text "Categories"
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 20,
                          // fontStyle: FontStyle.italic,
                        ),
                      ),
                      //Categories
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8.0,
                          children: restaurant.categories?.map((category) {
                            return Chip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              label: Text(category.rCategoryName),
                            );
                          }).toList() ?? [],
                        ),
                      ),
                      TextButton(
                        onPressed: _showCategorySelectionDialog,
                        child: Text('+ Add Category'),
                      ),
                      //text "Seatings"
                      const Text(
                        'Seatings',
                        style: TextStyle(
                          fontSize: 20,
                          // fontStyle: FontStyle.italic,
                        ),
                      ),
                      //Seatings
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8.0,
                          children: restaurant.seatings?.map((seating) {
                            return Chip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              label: Text(seating.seatingName),
                            );
                          }).toList() ?? [],
                        ),
                      ),
                      TextButton(
                        onPressed: _showSeatingSelectionDialog,
                        child: Text('+ Add Seating'),
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
