class CuisineRestaurant{
  int cuisineId;
  int restaurantId;

  CuisineRestaurant({
    required this.cuisineId,
    required this.restaurantId,
  });

  factory CuisineRestaurant.fromJson(dynamic json) {
    return CuisineRestaurant(
      cuisineId: json['cuisineId'] as int,
      restaurantId: json['restaurantId'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cuisineId': cuisineId,
      'restaurantId': restaurantId,
    };
  }

  
}