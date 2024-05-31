class Reservation{
  int id;
  int restaurantId;
  String restaurantName;
  int userId;
  int partySize;
  String date;
  String phoneNum;
  bool? ordered;
  String? comment;
  bool? accepted;
  String? restaurantResponse;

  Reservation({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.userId,
    required this.partySize,
    required this.date,
    required this.phoneNum,
    this.ordered,
    this.comment,
    this.accepted,
    this.restaurantResponse,
  });

  factory Reservation.fromJson(dynamic json){
    return Reservation(
      id: json['id'] as int,
      restaurantId: json['restaurantId'] as int,
      restaurantName: json['restaurantName'] as String,
      userId: json['userId'] as int,
      partySize: json['partySize'] as int,
      date: json['date'] as String,
      phoneNum: json['phoneNum'] as String,
      ordered: json['ordered'] as bool,
      //ha a comment null, akkor üres string legyen
      comment: json['comment'] ?? '',
      accepted: json['accepted'],
      restaurantResponse: json['restaurantResponse'] ?? '',
    );
  }

  Map<String, dynamic> toMap(){
    // String formattedDate = date.toIso8601String();

    return {
      'id': id,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'userId': userId,
      'partySize': partySize,
      'date': date,
      'phoneNum': phoneNum,
      'ordered': ordered ?? false,
      'comment': comment,
      'accepted': accepted,
      'restaurantResponse': restaurantResponse,
    };
  }
}