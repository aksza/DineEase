// import 'dart:ffi';

class User{
  int id;
  String firstName;
  String lastName;
  String email;
  String phoneNum;
  bool isAdmin;
  // List<Favorit>? favorits;
  // List<Reservation>? reservations;
  // List<Review>? reviews;
  // List<Rating>? ratings;
  // List<Meeting>? meetings;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNum,
    required this.isAdmin,
    // this.favorits,
    // this.reservations,
    // this.reviews,
    // this.ratings,
    // this.meetings,
  });

  factory User.fromJson(dynamic json){
    return User(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNum: json['phoneNum'] as String,
      isAdmin: json['admin'] as bool,
      // favorits: json['favorits'],
      // reservations: json['reservations'],
      // reviews: json['reviews'],
      // ratings: json['ratings'],
      // meetings: json['meetings'],
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
      // 'favorits': favorits?.map((x) => x.toMap()).toList(),
      // 'reservations': reservations?.map((x) => x.toMap()).toList(),
      // 'reviews': reviews?.map((x) => x.toMap()).toList(),
      // 'ratings': ratings?.map((x) => x.toMap()).toList(),
      // 'meetings': meetings?.map((x) => x.toMap()).toList(),
    };
  }

}