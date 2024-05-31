class Seating{
  int id;
  String seatingName;

  Seating(
    {
      required this.id,
      required this.seatingName
    }
  );

  factory Seating.fromJson(dynamic json){
    return Seating(
      id: json['id'] as int,
      seatingName: json['seatingName'] as String
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'seatingName': seatingName
    };
  }
}