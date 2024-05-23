class MeetingCreate{
  int userId;
  int restaurantId;
  int eventId;
  DateTime eventDate;
  int guestSize;
  DateTime meetingDate;
  String phoneNum;
  String? comment;

  MeetingCreate({
    required this.userId,
    required this.restaurantId,
    required this.eventId,
    required this.eventDate,
    required this.guestSize,
    required this.meetingDate,
    required this.phoneNum,
    this.comment,
  });

  factory MeetingCreate.fromJson(dynamic json){
    return MeetingCreate(
      userId: json['userId'] as int,
      restaurantId: json['restaurantId'] as int,
      eventId: json['eventId'] as int,
      eventDate: json['eventDate'] as DateTime,
      guestSize: json['guestSize'] as int,
      meetingDate: json['meetingDate'] as DateTime,
      phoneNum: json['phoneNum'] as String,
      comment: json['comment'] as String,
    );
  }

  Map<String, dynamic> toMap(){
    String formattedEventDate = eventDate.toIso8601String();
    String formattedMeetingDate = meetingDate.toIso8601String();
    return {
      'userId': userId,
      'restaurantId': restaurantId,
      'eventId': eventId,
      'eventDate': formattedEventDate,
      'guestSize': guestSize,
      'meetingDate': formattedMeetingDate,
      'phoneNum': phoneNum,
      'comment': comment,
    };
  }
}