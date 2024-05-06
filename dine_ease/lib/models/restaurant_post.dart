class RestaurantPost{
  final int id;
  final String name;
  final double? rating;
  bool isFavorite;
  final String imagePath;

  RestaurantPost({
    required this.id,
    required this.name,
    this.rating,
    required this.isFavorite,
    required this.imagePath
  });
}