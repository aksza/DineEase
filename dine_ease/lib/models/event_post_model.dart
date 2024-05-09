class EventPost{
  final int id;
  final String eventName;
  final int restaurantId;
  final String restaurantName;
  final String? description;
  final DateTime startingDate;
  final DateTime endingDate;

  EventPost({
    required this.id,
    required this.eventName,
    required this.restaurantId,
    required this.restaurantName,
    this.description,
    required this.startingDate,
    required this.endingDate
  });
}