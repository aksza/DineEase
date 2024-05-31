import 'package:dine_ease/models/e_category.dart';

class EventPost{
  final int id;
  final String eventName;
  final int restaurantId;
  final String restaurantName;
  final String? description;
  final DateTime startingDate;
  final DateTime endingDate;
  List<ECategory>? eCategories;

  EventPost({
    required this.id,
    required this.eventName,
    required this.restaurantId,
    required this.restaurantName,
    this.description,
    required this.startingDate,
    required this.endingDate,
    this.eCategories
  });
}