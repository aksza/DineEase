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
      comment: json['comment'] as String,
      reservationId: json['reservationId'] as int,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'menuId': menuId,
      'comment': comment,
      'reservationId': reservationId,
    };
  }  
  
}