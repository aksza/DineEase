class RegisterUser{
  String firstName;
  String lastName;
  String email;
  String phoneNum;
  String password;
  
  RegisterUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNum,
    required this.password,
  });

  factory RegisterUser.fromJson(dynamic json){
    return RegisterUser(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNum: json['phoneNum'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNum,
      'password': password,
    };
  }
}