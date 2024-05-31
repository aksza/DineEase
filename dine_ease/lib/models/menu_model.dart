class Menu{
  int id;
  int restaurantId;
  String name;
  int menuypeId;
  String menuTypeName;
  String ingredients;
  int price;

  Menu({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.menuypeId,
    required this.menuTypeName,
    required this.ingredients,
    required this.price,
  });

  factory Menu.fromJson(dynamic json){
    return Menu(
      id: json['id'] as int,
      restaurantId: json['restaurantId'] as int,
      name: json['name'] as String,
      menuypeId: json['menuTypeId'] as int,
      menuTypeName: json['menuTypeName'] as String,
      ingredients: json['ingredients'] as String,
      price: json['price'] as int,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'restaurantId': restaurantId,
      'name': name,
      'menuTypeId': menuypeId,
      'menuTypeName': menuTypeName,
      'ingredients': ingredients,
      'price': price,
    };
  }
}