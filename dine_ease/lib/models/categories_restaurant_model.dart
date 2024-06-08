class CategoriesRestaurant{
  int rCategoryId;
  int restaurantId;

  CategoriesRestaurant({
    required this.rCategoryId,
    required this.restaurantId,
  });

  factory CategoriesRestaurant.fromJson(dynamic json) {
    return CategoriesRestaurant(
      rCategoryId: json['rCategoryid'] as int,
      restaurantId: json['restaurantId'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rCategoryid': rCategoryId,
      'restaurantId': restaurantId,
    };
  }
}