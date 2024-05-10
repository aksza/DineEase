class ReservationCreate{
  int restaurantId;
  int userId;
  int partySize;
  DateTime date;
  String phoneNum; 
  bool? ordered = false;
  String? comment;

  ReservationCreate({
    required this.restaurantId,
    required this.userId,
    required this.partySize,
    required this.date,
    required this.phoneNum,
    this.ordered,
    this.comment,
  });

  factory ReservationCreate.fromJson(dynamic json){
    return ReservationCreate(
      restaurantId: json['restaurantId'] as int,
      userId: json['userId'] as int,
      partySize: json['partySize'] as int,
      date: json['date'] as DateTime,
      phoneNum: json['phoneNum'] as String,
      ordered: json['ordered'] as bool,
      comment: json['comment'] as String,
    );
  }

  Map<String, dynamic> toMap(){
    String formattedDate = date.toIso8601String();

    return {
      'restaurantId': restaurantId,
      'userId': userId,
      'partySize': partySize,
      'date': formattedDate,
      'phoneNum': phoneNum,
      'ordered': ordered ?? false,
      'comment': comment,
    };
  }
}