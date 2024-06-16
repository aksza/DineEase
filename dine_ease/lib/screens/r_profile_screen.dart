import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:dine_ease/models/upload_restaurant_image.dart';
import 'package:dine_ease/utils/image_util.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:dine_ease/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
  late List<UploadImages> images;
  
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
      var image = await _requestUtil.getPhotosByRestaurantId(resid);

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
        images = image;
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

  //update openings
  void updateOpenings(List<Opening> openings) async {
    try {
      await _requestUtil.putUpdateOpenings(openings);
      setState(() {
        restaurant.openings = openings;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Openings updated successfully'),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to update openings'),
      ));
    }
  }

  //add openings
  void addOpenings(List<Opening> openings) async {
    try {
      await _requestUtil.postAddOpenings(openings);
      setState(() {
        restaurant.openings = openings;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Openings added successfully'),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to add openings'),
      ));
    }
  }

  void addOrUpdateOpenings(List<Opening> openings) async {
    List<Opening> newOpenings = [];
    List<Opening> updatedOpenings = [];
    for (var opening in openings) {
      if (opening.id == null) {
        newOpenings.add(opening);
      } else {
        updatedOpenings.add(opening);
      }
    }
    Logger().i(newOpenings);
    Logger().i(updatedOpenings);

    if (newOpenings.isNotEmpty) {
      addOpenings(newOpenings);
    }

    if (updatedOpenings.isNotEmpty) {
      updateOpenings(updatedOpenings);
    }
  }

  //delete photo
  void deletePhoto(UploadImages photo) async {
    try {
      await _requestUtil.deleteRemovePhoto(photo.id);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Photo deleted successfully'),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to delete photo'),
      ));
    }
  }

  //add photo
  // void addPhoto(File photo) async {
  //   try {
  //     await _requestUtil.postAddPhoto(UploadImages(restaurantId: restaurant.id, image: photo.path));
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Photo added successfully'),
  //     ));
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Failed to add photo'),
  //     ));
  //   }
  // }

  //show alert dialog delete photo
  void _showDeletePhotoDialog(UploadImages photo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Photo'),
          content: const Text('Are you sure you want to delete this photo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Logger().i('Delete photo with id: ${photo.id}');
                deletePhoto(photo);
                setState(() {
                  images.removeWhere((element) => element.id == photo.id);
                });
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSelectionDialog<T>({
  required String title,
  required List<T> allItems,
  required List<T> selectedItems,
  required Function(List<T>) onAdd,
  required Function(List<T>) onRemove,
  required String Function(T) itemLabel,
  required bool Function(T, T) itemEquality, 
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
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
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

  // Show opening edit dialog
  void _showOpeningEditDialog() {
  showDialog(
    context: context,
    builder: (context) {
      List<Opening> tempOpenings = List.from(restaurant.openings ?? []);
      List<TextEditingController> startControllers = List.generate(7, (index) {
        final opening = tempOpenings.firstWhere(
          (o) => o.day == index,
          orElse: () => Opening(day: index, openingHour: '', closingHour: ''),
        );
        return TextEditingController(text: opening.openingHour);
      });

      List<TextEditingController> endControllers = List.generate(7, (index) {
        final opening = tempOpenings.firstWhere(
          (o) => o.day == index,
          orElse: () => Opening(day: index, openingHour: '', closingHour: ''),
        );
        return TextEditingController(text: opening.closingHour);
      });

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Openings'),
            contentPadding: EdgeInsets.all(16.0),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 7,
                itemBuilder: (context, index) {
                  final opening = tempOpenings.firstWhere(
                    (o) => o.day == index,
                    orElse: () => Opening(day: index, openingHour: '', closingHour: ''),
                  );

                  return Column(
                    children: [
                      Row(
                        children: [
                          Text(DateFormat.EEEEE('en_US').format(DateTime(2022, 1, 3 + index))),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((selectedTime) {
                                  if (selectedTime != null) {
                                    final formattedTime = _formatTime(selectedTime);
                                    setState(() {
                                      opening.openingHour = formattedTime;
                                      startControllers[index].text = formattedTime;
                                    });
                                  }
                                });
                              },
                              child: AbsorbPointer(
                                child: MyTextField(
                                  controller: startControllers[index],
                                  hintText: 'Start Time',
                                  obscureText: false,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((selectedTime) {
                                  if (selectedTime != null) {
                                    final formattedTime = _formatTime(selectedTime);
                                    setState(() {
                                      opening.closingHour = formattedTime;
                                      endControllers[index].text = formattedTime;
                                    });
                                  }
                                });
                              },
                              child: AbsorbPointer(
                                child: MyTextField(
                                  controller: endControllers[index],
                                  hintText: 'End Time',
                                  obscureText: false,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                startControllers[index].text = '';
                                opening.openingHour = '';
                                endControllers[index].text = '';
                                opening.closingHour = '';
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  bool allFieldsValid = true;
                  bool allTimingsValid = true;

                  for (int i = 0; i < 7; i++) {
                    if ((startControllers[i].text.isNotEmpty && endControllers[i].text.isEmpty) ||
                        (startControllers[i].text.isEmpty && endControllers[i].text.isNotEmpty)) {
                      allFieldsValid = false;
                      continue; 
                    }
                    
                    if (_compareTime(startControllers[i].text, endControllers[i].text) > 0) {
                      allTimingsValid = false;
                      break;
                    }
                  }

                  if (allFieldsValid && allTimingsValid) {
                    setState(() {
                      restaurant.openings = tempOpenings;
                      Logger().i(restaurant.openings!.map((o) => o.toMap()).toList());
                    });
                    addOrUpdateOpenings(tempOpenings);
                    Navigator.pop(context);
                  } else {
                    String message = '';
                    if (!allFieldsValid) {
                      message = 'Some fields are empty. Are you sure you want to save?';
                    } else if (!allTimingsValid) {
                      message = 'Start time cannot be greater than end time.';
                    }
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                      ),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}

  int _compareTime(String startTime, String endTime) {
    if (startTime.isEmpty && endTime.isEmpty) {
      return 0;
    }

    if (startTime.isEmpty) {
      return 1;
    }
    if (endTime.isEmpty) {
      return -1;
    }

    DateTime start = DateTime.tryParse(startTime) ?? DateTime(2000);
    DateTime end = DateTime.tryParse(endTime) ?? DateTime(2000);

    return start.compareTo(end);
  }

  String _formatTime(TimeOfDay timeOfDay) {
    int hour = timeOfDay.hour;
    int minute = timeOfDay.minute;    

    String formattedTime = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  //add photo
  Future<UploadImages?> addPhoto(Uint8List photo) async {
    try {
      // Uint8List image = await photo.readAsBytes();
      var resp = await _requestUtil.postAddPhoto(restaurant.id, photo);
      if(resp != null){
        setState(() {
          images.add(resp);
        });
        return resp;
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Photo added successfully'),
      ));
      return null;
      //  final _directory =
      // await getTemporaryDirectory();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to add photo'),
      ));
      return null;
    }
  }

  void selectImage() async{
    Uint8List? image = await pickImage(ImageSource.gallery);
    if(image != null){
      // addPhoto(File(image.toString()));
      await addPhoto(image);
      setState((){
        
      });
    }
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
                      //text photos
                      const Text(
                        'Photos',
                        style: TextStyle(
                          fontSize: 20,
                          // fontStyle: FontStyle.italic,
                        ),
                      ),
                      //photos
                      if(images.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CarouselSlider.builder(
                          itemCount: images.length,
                          itemBuilder: (BuildContext context, int index, int realIndex) {
                            return Stack(
                              children: [
                                Image.asset(
                                  "assets/test_images/${images[index].image!}",
                                  fit: BoxFit.cover,
                                ),
                                
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      // Itt írd meg a törlés logikáját
                                      _showDeletePhotoDialog(images[index]);
                                      
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                          options: CarouselOptions(
                            height: 200,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                      //add photo button
                      ElevatedButton(
                        onPressed: () {
                          selectImage();
                        },
                        child: const Text('Add Photo'),
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
                      //text openings
                      const Text(
                        'Openings',
                        style: TextStyle(
                          fontSize: 20,
                          // fontStyle: FontStyle.italic,
                        ),
                      ),
                      //Openings listazas textkent, nem chipkent
                      Padding(
                      padding: const EdgeInsets.fromLTRB(80.0, 8.0, 80.0, 8.0),
                      child: Column(
                        //center
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(7, (index) {
                          final opening = restaurant.openings?.firstWhere(
                            (o) => o.day == index,
                            orElse: () => Opening(day: index, openingHour: '', closingHour: '',id: 0),
                          );

                          final dayName = DateFormat.EEEE('en_US').format(DateTime(2022, 1, 3 + index)); 
                          final isClosed = opening?.openingHour.isEmpty ?? true;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //day
                              Text(
                                dayName,
                                style: const TextStyle(fontSize: 16),
                              ),
                              //time
                              Text(
                                isClosed ? 'Closed' : '${opening!.openingHour} - ${opening.closingHour}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                      //edit opening button that looks like update button
                      ElevatedButton(
                        onPressed: (){
                          _showOpeningEditDialog();
                        }, child: 
                        const Text('Edit Openings')
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
                      ElevatedButton(
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
                      ElevatedButton(
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
                      ElevatedButton(
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
