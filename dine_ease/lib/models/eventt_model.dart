class Eventt{
  int id;
  String eventName;
  int restaurantId;
  String restaurantName;
  String? description;
  DateTime startingDate;
  DateTime endingDate;
  // List<PhotoEvent>? photoEvents;
  // List<CategoriesEvent>? categoriesEvents;

  Eventt({
    required this.id,
    required this.eventName,
    required this.restaurantId,
    required this.restaurantName,
    this.description,
    required this.startingDate,
    required this.endingDate,
    // this.photoEvents,
    // this.categoriesEvents
  });

  factory Eventt.fromJson(dynamic json){
    return Eventt(
      id: json['id'] as int,
      eventName: json['eventName'] as String,
      restaurantId: json['restaurantId'] as int,
      restaurantName: json['restaurantName'] as String,
      description: json['description'] as String,
      startingDate: DateTime.parse(json['startingDate'] as String),
      endingDate: DateTime.parse(json['endingDate'] as String),
      // photoEvents: json['photoEvents'],
      // categoriesEvents: json['categoriesEvents']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'eventName': eventName,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'description': description,
      'startingDate': startingDate.toIso8601String(),
      'endingDate': endingDate.toIso8601String(),
      // 'photoEvents': photoEvents,
      // 'categoriesEvents': categoriesEvents
    };
  }

}