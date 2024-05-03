class RestaurantPost{
  final String name;
  final int rating;
  bool isFavorite;
  final String imagePath;

  RestaurantPost({
    required this.name,
    required this.rating,
    required this.isFavorite,
    required this.imagePath
  });
}