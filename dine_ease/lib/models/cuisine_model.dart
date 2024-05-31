class Cuisine{
  int id;
  String cuisineName;

  Cuisine(
    {
      required this.id,
      required this.cuisineName
    }
  );

  factory Cuisine.fromJson(dynamic json){
    return Cuisine(
      id: json['id'] as int,
      cuisineName: json['cuisineName'] as String
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'cuisineName': cuisineName
    };
  }
}