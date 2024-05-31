class MenuType{
  int id;
  String name;

  MenuType(
    {
      required this.id,
      required this.name
    }
  );

  factory MenuType.fromJson(dynamic json){
    return MenuType(
      id: json['id'] as int,
      name: json['name'] as String
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name
    };
  }
}