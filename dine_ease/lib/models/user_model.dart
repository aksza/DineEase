class User{
  int id;
  String firstName;
  String lastName;
  String email;
  String phoneNum;
  bool isAdmin;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNum,
    required this.isAdmin,
  });

  factory User.fromJson(dynamic json){
    return User(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNum: json['phoneNum'] as String,
      isAdmin: json['admin'] as bool,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNum': phoneNum,
      'admin': isAdmin,
    };
  }

}