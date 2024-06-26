class Review{
  int? id;
  int restaurantId;
  String? restaurantName;
  int userId;
  String? userName;
  String content;

  Review({
    this.id,
    required this.restaurantId,
    this.restaurantName,
    required this.userId,
    this.userName,
    required this.content
  });

  factory Review.fromJson(dynamic json){
    return Review(
      id: json['id'] as int,
      restaurantId: json['restaurantId'] as int,
      restaurantName: json['restaurantName'] as String,
      userId: json['userId'] as int,
      userName: json['userName'] as String?,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'userId': userId,
      'userName': userName,
      'content': content,
    };
  }

  Map<String,dynamic> toUpdateMap(){
    return {
      'id' : id,
      'restaurantId' : restaurantId,
      'userId' : userId,
      'content' : content,
    };
  }

  Map<String,dynamic> toAddMap(){
    return {
      'restaurantId' : restaurantId,
      'userId' : userId,
      'content' : content,
    };
  }

}