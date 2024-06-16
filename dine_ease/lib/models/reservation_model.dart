class Reservation{
  int id;
  int restaurantId;
  String restaurantName;
  int userId;
  String? name;
  int partySize;
  String date;
  String phoneNum;
  bool? ordered;
  int? tableNumber;
  String? comment;
  bool? accepted;
  String? restaurantResponse;

  Reservation({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.userId,
    this.name,
    required this.partySize,
    required this.date,
    required this.phoneNum,
    this.ordered,
    this.tableNumber,
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
      name: json['name'] ?? '',
      partySize: json['partySize'] as int,
      date: json['date'] as String,
      phoneNum: json['phoneNum'] as String,
      ordered: json['ordered'] ?? false,
      //ha a comment null, akkor üres string legyen
      tableNumber: json['tableNumber'] ?? 0,
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
      'name': name ?? '',
      'partySize': partySize,
      'date': date,
      'phoneNum': phoneNum,
      'ordered': ordered ?? false,
      'tableNumber': tableNumber ?? 0,
      'comment': comment,
      'accepted': accepted,
      'restaurantResponse': restaurantResponse,
    };
  }
}