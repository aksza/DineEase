import 'package:dine_ease/models/e_category.dart';

class Eventt{
  int id;
  String eventName;
  int restaurantId;
  String restaurantName;
  String? description;
  DateTime startingDate;
  DateTime endingDate;
  List<ECategory>? eCategories;
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
    this.eCategories
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

  Map<String, dynamic> toCreateMap(){
    return {
      'eventName': eventName,
      'restaurantId': restaurantId,
      'description': description,
      'startingDate': startingDate.toIso8601String(),
      'endingDate': endingDate.toIso8601String(),
    };
  }



}