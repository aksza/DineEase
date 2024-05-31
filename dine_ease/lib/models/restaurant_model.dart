import 'package:dine_ease/models/cuisine_model.dart';
import 'package:dine_ease/models/opening_model.dart';
import 'package:dine_ease/models/r_category.dart';
import 'package:dine_ease/models/seating_model.dart';
import 'package:flutter/foundation.dart';

class Restaurant {
  int id;
  String name;
  String? description;
  String address;
  String phoneNum;
  String email;
  double? rating; // Módosítás: átállítás int-ről double-re
  String price;
  bool forEvent;
  int maxTableCapacity;
  List<Cuisine>? cuisines;
  List<RCategory>? categories;
  List<Opening>? openings;
  List<Seating>? seatings;

  Restaurant({
    required this.id,
    required this.name,
    this.description,
    required this.address,
    required this.phoneNum,
    required this.email,
    this.rating,
    required this.price,
    required this.forEvent,
    required this.maxTableCapacity,
    this.cuisines,
    this.categories,
    this.openings,
    this.seatings,
  });

  factory Restaurant.fromJson(dynamic json) {
    return Restaurant(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      phoneNum: json['phoneNum'] as String,
      email: json['email'] as String,
      rating: json['rating'] is int ? (json['rating'] as int).toDouble() : json['rating'], // Módosítás: átállítás int-ről double-re
      price: json['price']['priceName'] as String,
      forEvent: json['forEvent'] as bool,
      maxTableCapacity: json['maxTableCap'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'phoneNum': phoneNum,
      'email': email,
      'rating': rating,
      'price': price,
      'forEvent': forEvent,
      'maxTableCap': maxTableCapacity,
    };
  }
}
