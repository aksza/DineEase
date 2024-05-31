class Opening{
  int id;
  String openingHour;
  String closingHour;
  int day;

  Opening(
    {
      required this.id,
      required this.openingHour,
      required this.closingHour,
      required this.day
    }
  );

  factory Opening.fromJson(dynamic json){
    return Opening(
      id: json['id'] as int,
      openingHour: json['openingHour'] as String,
      closingHour: json['closingHour'] as String,
      day: json['day'] as int
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'openingHour': openingHour,
      'closingHour': closingHour,
      'day': day
    };
  }
}