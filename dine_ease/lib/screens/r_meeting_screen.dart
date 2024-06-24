import 'dart:math';
import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/meeting_model.dart';
import 'package:dine_ease/models/meeting_new_model.dart';
import 'package:dine_ease/models/order_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class RMeetingScreen extends StatefulWidget {
  static const routeName = '/r_meeting';

  const RMeetingScreen({super.key});

  @override
  State<RMeetingScreen> createState() => _RMeetingScreenState();
}

class _RMeetingScreenState extends State<RMeetingScreen> {

  late List<Meeting> acceptedMeeting;
  late int restaurantId;
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    getAcceptedMeetings();
  }

  Future<List<Meeting>?> getAcceptedMeetings()async {
    DataBaseProvider dbProvider = DataBaseProvider();
    int restaurantId = await dbProvider.getUserId();

    RequestUtil requestUtil = RequestUtil();
    acceptedMeeting = await requestUtil.getAcceptedMeetingsByRestaurantId(restaurantId);
    setState(() {
      isLoading = false;
    });
    return acceptedMeeting;
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  List<MeetingNew> _getDataSource() {
    List<MeetingNew> appointments = <MeetingNew>[];

    for (Meeting meeting in acceptedMeeting) {
      
      appointments.add(MeetingNew(
        meeting: meeting,
        startTime: DateTime.parse(meeting.meetingDate),
        endTime: DateTime.parse(meeting.meetingDate).add(const Duration(hours: 2)),
        subject: meeting.id.toString(),
        color: getRandomColor(),
        isAllDay: false,
      ));
    }

    return appointments;
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SafeArea(
      child: SfCalendar(
        showDatePickerButton: true,
        allowedViews: const [
          CalendarView.day,
          CalendarView.week,
          CalendarView.month
        ],
        view: CalendarView.month,
        allowViewNavigation: true,
        firstDayOfWeek: 1,
        initialDisplayDate: DateTime.now(),
        dataSource: MeetingDataSource(_getDataSource()),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.appointment) {
            final MeetingNew appointment = details.appointments!.first;
            _showAppointmentDetails(context, appointment);
          }
        },
      ),
    );
  }


  void _showAppointmentDetails(
      BuildContext context, MeetingNew appointment) {
    bool showOrders = false;
    Future<List<Order>>? ordersFuture;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Meeting for ${appointment.meeting.eventName}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Restaurant: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(appointment.meeting.restaurantName),
                      ],
                    ),
                    const SizedBox(height: 10),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Guest size: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(appointment.meeting.guestSize.toString()),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Event Date: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(DateFormat('yyyy-MM-dd HH:mm').format(
                            DateTime.parse(appointment.meeting.eventDate))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Event Date: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(DateFormat('yyyy-MM-dd HH:mm').format(
                            DateTime.parse(appointment.meeting.meetingDate))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Phone number: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(appointment.meeting.phoneNum),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (appointment.meeting.comment != '' &&
                        appointment.meeting.comment != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Comment: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(appointment.meeting.comment!),
                        ],
                      ),
                    const SizedBox(height: 10),
                    if (appointment.meeting.restaurantResponse != '' &&
                        appointment.meeting.restaurantResponse != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Restaurant response: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(appointment.meeting.restaurantResponse!),
                        ],
                      ),
                    const SizedBox(height: 10),
                    ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  @override
  MeetingDataSource(List<MeetingNew> source) {
    appointments = source;
  }
}
