class Opening{
  int? id;
  int? restaurantId;
  String openingHour;
  String closingHour;
  int day;

  Opening(
    {
      this.id,
      this.restaurantId,
      required this.openingHour,
      required this.closingHour,
      required this.day
    }
  );

  factory Opening.fromJson(dynamic json){
    return Opening(
      id: json['id'] as int,
      restaurantId: json['restaurantId'] as int,
      openingHour: json['openingHour'] as String,
      closingHour: json['closingHour'] as String,
      day: json['day'] as int
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'restaurantId': restaurantId,
      'openingHour': openingHour,
      'closingHour': closingHour,
      'day': day
    };
  }

  Map<String, dynamic> toUpdateMap(){
    return {
      'id': id,
      'restaurantId': restaurantId,
      'openingHour': openingHour,
      'closingHour': closingHour,
      'day': day
    };
  }

  Map<String, dynamic> toCreateMap(){
    return {
      'restaurantId': restaurantId,
      'openingHour': openingHour,
      'closingHour': closingHour,
      'day': day
    };
  }

}