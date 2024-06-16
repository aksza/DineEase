import 'package:dine_ease/models/meeting_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingNew extends Appointment{
  final Meeting meeting;

  MeetingNew({
    required this.meeting,
    required startTime,
    required endTime,
    required subject,
    required color,
    required isAllDay,
  }) : super(
    startTime: startTime,
    endTime: endTime,
    subject: subject,
    color: color,
    isAllDay: isAllDay,
  );
  
}