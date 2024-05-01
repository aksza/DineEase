class RegisterRestaurant{
  String name;
  String? description;
  String address;
  String phoneNum;
  String email;
  String password;
  int priceId; // priceid kellene
  bool forEvent;
  String ownerName;
  String ownerPhoneNum;
  int maxTableCapacity;
  int taxIdNum;

  RegisterRestaurant({
    required this.name,
    this.description,
    required this.address,
    required this.phoneNum,
    required this.email,
    required this.password,
    required this.priceId,
    required this.forEvent,
    required this.ownerName,
    required this.ownerPhoneNum,
    required this.maxTableCapacity,
    required this.taxIdNum,
  });

  factory RegisterRestaurant.fromJson(dynamic json){
    return RegisterRestaurant(
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      phoneNum: json['phoneNum'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      priceId: json['price'] as int,
      forEvent: json['forEvent'] as bool,
      ownerName: json['owner']['name'] as String,
      ownerPhoneNum: json['owner']['phoneNum'] as String,
      maxTableCapacity: json['maxTableCap'] as int,
      taxIdNum: json['taxIdNum'] as int,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'description': description,
      'address': address,
      'phoneNum': phoneNum,
      'email': email,
      'password': password,
      'priceId': priceId,
      'forEvent': forEvent,
      'owner': {
        'name': ownerName,
        'phoneNum': ownerPhoneNum
      },
      'maxTableCap': maxTableCapacity,
      'taxIdNum': taxIdNum,
    };
  }
}