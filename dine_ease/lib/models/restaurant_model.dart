import 'dart:html';

class Restaurant{
  String name;
  String? description;
  String address;
  String phoneNum;
  String email;
  double rating;
  // Price price;
  bool forEvent;
  // Owner owner;
  int maxTableCapacity;
  int taxIdNum;
  // List<CuisinesRestaurant>? cuisineRestaurants;
  // List<Favorit>? favorits;
  // List<Meeting>? meetings;
  // List<Menus>? menus;
  // List<Opening>? openings;
  // List<Rating>? ratings;
  // List<Reservation>? reservations;
  // List<Review>? reviews;
  // List<SeatingsRestaurant>? seatingsRestaurants;
  // List<CategoriesRestaurant>? categoriesRestaurants;
  // List<PhotosRestaurant>? photosRestaurants;
  // List<Eventt>? events;

  Restaurant({
    required this.name,
    this.description,
    required this.address,
    required this.phoneNum,
    required this.email,
    required this.rating,
    // required this.price,
    required this.forEvent,
    // required this.owner,
    required this.maxTableCapacity,
    required this.taxIdNum,
    // this.cuisineRestaurants,
    // this.favorits,
    // this.meetings,
    // this.menus,
    // this.openings,
    // this.ratings,
    // this.reservations,
    // this.reviews,
    // this.seatingsRestaurants,
    // this.categoriesRestaurants,
    // this.photosRestaurants,
    // this.events,
  });

  factory Restaurant.fromJson(dynamic json){
    return Restaurant(
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      phoneNum: json['phoneNum'] as String,
      email: json['email'] as String,
      rating: json['rating'] as double,
      // price: json['price'],
      forEvent: json['forEvent'] as bool,
      // owner: json['owner'],
      maxTableCapacity: json['maxTableCapacity'] as int,
      taxIdNum: json['taxIdNum'] as int,
      // cuisineRestaurants: json['cuisineRestaurants'],
      // favorits: json['favorits'],
      // meetings: json['meetings'],
      // menus: json['menus'],
      // openings: json['openings'],
      // ratings: json['ratings'],
      // reservations: json['reservations'],
      // reviews: json['reviews'],
      // seatingsRestaurants: json['seatingsRestaurants'],
      // categoriesRestaurants: json['categoriesRestaurants'],
      // photosRestaurants: json['photosRestaurants'],
      // events: json['events'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'description': description,
      'address': address,
      'phoneNum': phoneNum,
      'email': email,
      'rating': rating,
      // 'price': price.toMap(),
      'forEvent': forEvent,
      // 'owner': owner.toMap(),
      'maxTableCapacity': maxTableCapacity,
      'taxIdNum': taxIdNum,
      // 'cuisineRestaurants': cuisineRestaurants?.map((x) => x.toMap()).toList(),
      // 'favorits': favorits?.map((x) => x.toMap()).toList(),
      // 'meetings': meetings?.map((x) => x.toMap()).toList(),
      // 'menus': menus?.map((x) => x.toMap()).toList(),
      // 'openings': openings?.map((x) => x.toMap()).toList(),
      // 'ratings': ratings?.map((x) => x.toMap()).toList(),
      // 'reservations': reservations?.map((x) => x.toMap()).toList(),
      // 'reviews': reviews?.map((x) => x.toMap()).toList(),
      // 'seatingsRestaurants': seatingsRestaurants?.map((x) => x.toMap()).toList(),
      // 'categoriesRestaurants': categoriesRestaurants?.map((x) => x.toMap()).toList(),
      // 'photosRestaurants': photosRestaurants?.map((x) => x.toMap()).toList(),
      // 'events': events?.map((x) => x.toMap()).toList(),
    };
  }
}