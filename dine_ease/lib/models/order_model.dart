class Order{
  int menuId;
  String? comment;
  int reservationId;

  Order({
    required this.menuId,
    this.comment,
    required this.reservationId,
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