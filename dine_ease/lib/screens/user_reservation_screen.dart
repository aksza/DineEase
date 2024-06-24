import 'package:dine_ease/models/meeting_model.dart';
import 'package:dine_ease/models/reservation_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/reservation_view.dart';
import 'package:dine_ease/widgets/meeting_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserReservationScreen extends StatefulWidget {
  static const routename = '/user-reservation';
  final bool isreservation;

  const UserReservationScreen({super.key, required this.isreservation});

  @override
  State<UserReservationScreen> createState() => _UserReservationScreenState();
}

class _UserReservationScreenState extends State<UserReservationScreen> {
  final RequestUtil requestUtil = RequestUtil();

  late int userId;
  late SharedPreferences prefs;
  bool isLoading = true;
  List<Reservation> reservations = [];
  List<Meeting> meetings = [];
  List<Reservation> pastReservations = [];
  List<Meeting> pastMeetings = [];

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId')!;
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    try {
      if (widget.isreservation == true) {
        var reservationData = await requestUtil.getReservationsByUserId(userId);
        setState(() {
          DateTime currentDate = DateTime.now();
          reservations = reservationData.where((res) => DateTime.parse(res.date).isAfter(currentDate)).toList();
          pastReservations = reservationData.where((res) => DateTime.parse(res.date).isBefore(currentDate)).toList();
          isLoading = false;
        });
      } else {
        var reservationData = await requestUtil.getWaitingsByUserId(userId);
        var meetingData = await requestUtil.getWaitingsMByUserId(userId);
        setState(() {
          DateTime currentDate = DateTime.now();
          reservations = reservationData.where((res) => DateTime.parse(res.date).isAfter(currentDate)).toList();
          pastReservations = reservationData.where((res) => DateTime.parse(res.date).isBefore(currentDate)).toList();
          meetings = meetingData.where((meet) => DateTime.parse(meet.meetingDate).isAfter(currentDate)).toList();
          pastMeetings = meetingData.where((meet) => DateTime.parse(meet.meetingDate).isBefore(currentDate)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      Logger().e('Error fetching reservations: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.isreservation ? 'Reservations' : 'Waiting List'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (widget.isreservation)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (reservations.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Reservations',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: reservations.length,
                          itemBuilder: (context, index) {
                            final reservation = reservations[index];
                            return ReservationView(reservation: reservation);
                          },
                        ),
                      ),
                    ],
                    if (pastReservations.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'History',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: pastReservations.length,
                          itemBuilder: (context, index) {
                            final reservation = pastReservations[index];
                            return ReservationView(reservation: reservation);
                          },
                        ),
                      ),
                    ],
                    if (reservations.isEmpty && pastReservations.isEmpty)
                      const Center(child: Text('You do not have any reservations yet')),
                  ],
                )
              : ListView(
                  children: [
                    if (reservations.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Reservation Waiting List',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...reservations.map((reservation) => ReservationView(reservation: reservation)).toList(),
                    ],
                    if (pastReservations.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Reservation Waiting History',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...pastReservations.map((reservation) => ReservationView(reservation: reservation)).toList(),
                    ],
                    if (meetings.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Meeting Waiting List',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...meetings.map((meeting) => MeetingView(meeting: meeting)).toList(),
                    ],
                    if (pastMeetings.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Meeting Waiting History',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...pastMeetings.map((meeting) => MeetingView(meeting: meeting)).toList(),
                    ],
                  ],
                ),
    );
  }
}
