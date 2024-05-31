class Price{
  int id;
  String priceName;

  Price(
    {
      required this.id,
      required this.priceName
    }
  );

  factory Price.fromJson(dynamic json){
    return Price(
      id: json['id'] as int,
      priceName: json['priceName'] as String
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'priceName': priceName
    };
  }
}