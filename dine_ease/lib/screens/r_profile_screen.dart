import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/restaurant_model.dart';
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
  //ide meg cuisine, categories,price, openings, seatings kellene - de azok listák, nem textcontroller-ek, fetchinget is kellene csinálni hozzájuk, majd a formon megjeleníteni es az etterem kivalasztja a sajatjat  
  
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

      setState(() {
        restaurant = response;
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
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
        content: Text('Restaurant updated successfully'),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
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
                      // cuisines
                      // categories
                      // openings
                      // seatings
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
                            );
                            updateRestaurant(updatedRestaurant);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
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
