class Rating{
  int? id;
  int restaurantId;
  String? restaurantName;
  int userId;
  int ratingNumber;

  Rating({this.id, required this.restaurantId, this.restaurantName, required this.userId, required this.ratingNumber});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'],
      userId: json['userId'],
      ratingNumber: json['ratingNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'userId': userId,
      'ratingNumber': ratingNumber,
    };
  }

  Map<String, dynamic> toCreateMap() {
    return {
      'restaurantId': restaurantId,
      'userId': userId,
      'ratingNumber': ratingNumber,
    };
  }


}