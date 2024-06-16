
import 'package:dine_ease/models/reservation_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ReservationNew extends Appointment {
  final Reservation reservation;

  ReservationNew({
    required this.reservation,
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
