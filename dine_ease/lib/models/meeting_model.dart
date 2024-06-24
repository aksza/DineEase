
class Meeting{
  int id;
  int eventId;
  String eventName;
  int userId;
  int restaurantId;
  String restaurantName;
  String eventDate;
  int guestSize;
  String meetingDate;
  String phoneNum;
  String? comment;
  bool? accepted;
  String? restaurantResponse;

  Meeting({
    required this.id,
    required this.eventId,
    required this.eventName,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.eventDate,
    required this.guestSize,
    required this.meetingDate,
    required this.phoneNum,
    this.comment,
    this.accepted,
    this.restaurantResponse
  });

  factory Meeting.fromJson(dynamic json){
    return Meeting(
      id: json['id'] as int,
      eventId: json['eventId'] as int,
      eventName: json['eventName'] as String,
      userId: json['userId'] as int,
      restaurantId: json['restaurantId'] as int,
      restaurantName: json['restaurantName'] as String,
      eventDate: json['eventDate'] as String,
      guestSize: json['guestSize'] as int,
      meetingDate: json['meetingDate'] as String,
      phoneNum: json['phoneNum'] as String,
      comment: json['comment'] ?? '',
      accepted: json['accepted'],
      restaurantResponse: json['restaurantResponse'] ?? '',
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'eventId': eventId,
      'eventName': eventName,
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'eventDate': eventDate,
      'guestSize': guestSize,
      'meetingDate': meetingDate,
      'phoneNum': phoneNum,
      'comment': comment,
      'accepted': accepted,
      'restaurantResponse': restaurantResponse
    };
  }
}