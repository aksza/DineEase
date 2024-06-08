class SeatingRestaurant{
  int seatingId;
  int restaurantId;

  SeatingRestaurant({
    required this.seatingId,
    required this.restaurantId,
  });

  factory SeatingRestaurant.fromJson(dynamic json) {
    return SeatingRestaurant(
      seatingId: json['seatingId'] as int,
      restaurantId: json['restaurantId'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'seatingId': seatingId,
      'restaurantId': restaurantId,
    };
  }
}