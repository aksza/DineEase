class Order{
  int menuId;
  String? menuName;
  String? comment;
  int reservationId;
  int? price = 0;

  Order({
    required this.menuId,
    this.menuName,
    this.comment,
    required this.reservationId,
    this.price,
  });

  factory Order.fromJson(dynamic json){
    return Order(
      menuId: json['menuId'] as int,
      menuName: json['menuName'] ?? '',
      comment: json['comment'],
      reservationId: json['reservationId'] as int,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'menuId': menuId,
      'menuName': menuName ?? '',
      'comment': comment,
      'reservationId': reservationId,
    };
  }  

  Map<String, dynamic> toOMap(){
    return {
      'menuId': menuId,
      'comment': comment,
      'reservationId': reservationId,
    };
  }  
}