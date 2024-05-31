class EventType{
  int id;
  String eventName;

  EventType(
    {
      required this.id,
      required this.eventName
    }
  );

  factory EventType.fromJson(dynamic json){
    return EventType(
      id: json['id'] as int,
      eventName: json['eventName'] as String
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'eventName': eventName
    };
  }
}