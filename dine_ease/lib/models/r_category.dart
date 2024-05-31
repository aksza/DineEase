class RCategory{
  int id;
  String rCategoryName;

  RCategory(
    {
      required this.id,
      required this.rCategoryName
    }
  );

  factory RCategory.fromJson(dynamic json){
    return RCategory(
      id: json['id'] as int,
      rCategoryName: json['rCategoryName'] as String
    );
  }

  factory RCategory.fromRJson(dynamic json){
    return RCategory(
      id: json['rCategoryId'] as int,
      rCategoryName: json['rCategoryName'] as String
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'rCategoryName': rCategoryName
    };
  }
  
}