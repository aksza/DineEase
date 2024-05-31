class ECategory{
  int id;
  String eCategoryName;

  ECategory(
    {
      required this.id,
      required this.eCategoryName
    }
  );

  factory ECategory.fromJson(dynamic json){
    return ECategory(
      id: json['id'] as int,
      eCategoryName: json['eCategoryName'] as String
    );
  }

  factory ECategory.fromEJson(dynamic json){
    return ECategory(
      id: json['eCategoryId'] as int,
      eCategoryName: json['eCategoryName'] as String
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'eCategoryName': eCategoryName
    };
  }
  
}