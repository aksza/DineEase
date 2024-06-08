class UploadImages{
  int id;
  String? image;
  int restaurantId;

  UploadImages({
    required this.id,
    this.image,
    required this.restaurantId,
  });

  factory UploadImages.fromJson(Map<String, dynamic> json) {
    return UploadImages(
      id: json['id'],
      image: json['image'],
      restaurantId: json['restaurantId'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'image': image,
      'restaurantId': restaurantId,
    };
  }
}