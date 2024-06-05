import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Restaurant updated successfully'),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update restaurant'),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  //name
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _nameController..text = restaurant.name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                  ),
                  //address
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _addressController..text = restaurant.address,
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                    ),
                  ),
                  //phone number
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _phoneNumController..text = restaurant.phoneNum,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                  ),
                  //email
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _emailController..text = restaurant.email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  //owner id
                  Padding(padding: const EdgeInsets.all(8.0), child: Text('Owner ID: ${restaurant.ownerId}') ),
                  //description
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _descriptionController..text = restaurant.description ?? '',
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                  ),
                  //price
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextFormField(
                  //     controller: _priceController..text = restaurant.price,
                  //     decoration: InputDecoration(
                  //       labelText: 'Price',
                  //     ),
                  //   ),
                  // ),
                  //max table capacity
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _maxTableCapacityController..text = restaurant.maxTableCapacity.toString(),
                      decoration: InputDecoration(
                        labelText: 'Max Table Capacity',
                      ),
                    ),
                  ),
                  //cuisines
                  //categories
                  //openings
                  //seatings
                  //submit button
                  ElevatedButton(
                    onPressed: () {
                      //update restaurant
                      Restaurant updatedRestaurant = Restaurant(
                        id: restaurant.id,
                        name: _nameController.text,
                        address: _addressController.text,
                        phoneNum: _phoneNumController.text,
                        email: _emailController.text,
                        description: _descriptionController.text,
                        price: restaurant.price,
                        ownerId: restaurant.ownerId,
                        maxTableCapacity: int.parse(_maxTableCapacityController.text),
                        forEvent: restaurant.forEvent,
                      );
                      updateRestaurant(updatedRestaurant);
                    },
                    child: Text('Update'),
                  ),
                ],
              ),
            ),

    );
  }
}