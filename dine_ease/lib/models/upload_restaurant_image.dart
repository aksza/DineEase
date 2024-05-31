class UploadImages{
  String? imageFile;
  int restaurantId;

  UploadImages({
    this.imageFile,
    required this.restaurantId,
  });

  factory UploadImages.fromJson(dynamic json){
    return UploadImages(
      imageFile: json['imageFile'] as String,
      restaurantId: json['restaurantId'] as int,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'imageFile': imageFile,
      'restaurantId': restaurantId,
    };
  }
}