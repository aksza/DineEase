import 'package:dine_ease/models/cuisine_model.dart';
import 'package:dine_ease/models/opening_model.dart';
import 'package:dine_ease/models/r_category.dart';
import 'package:dine_ease/models/review_models.dart';
import 'package:dine_ease/models/seating_model.dart';

class Restaurant {
  int id;
  String name;
  String? description;
  String address;
  String phoneNum;
  String email;
  int? ownerId;
  double? rating; 
  int? priceId;
  String price;
  bool forEvent;
  int maxTableCapacity;
  bool? isFavorite;
  String? imagePath;
  List<Cuisine>? cuisines;
  List<RCategory>? categories;
  List<Opening>? openings;
  List<Seating>? seatings;
  List<Review>? reviews;

  Restaurant({
    required this.id,
    required this.name,
    this.description,
    required this.address,
    required this.phoneNum,
    required this.email,
    this.ownerId,
    this.rating,
    this.priceId,
    required this.price,
    required this.forEvent,
    required this.maxTableCapacity,
    this.isFavorite,
    this.imagePath,
    this.cuisines,
    this.categories,
    this.openings,
    this.seatings,
    this.reviews,
  });

  factory Restaurant.fromJson(dynamic json) {
    return Restaurant(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      phoneNum: json['phoneNum'] as String,
      email: json['email'] as String,
      ownerId: json['ownerId'],
      rating: json['rating'] is int ? (json['rating'] as int).toDouble() : json['rating'],
      priceId: json['priceId'] as int,
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
      'priceId': priceId,
      'price': price,
      'forEvent': forEvent,
      'maxTableCap': maxTableCapacity,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'phoneNum': phoneNum,
      'email': email,
      'ownerId': ownerId,
      'priceId': priceId,
      'forEvent': forEvent,
      'maxTableCap': maxTableCapacity,
    };
  }


}
