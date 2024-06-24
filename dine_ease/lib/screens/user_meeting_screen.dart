import 'package:dine_ease/models/meeting_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/meeting_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMeetingScreen extends StatefulWidget {
  static const routename = '/user-meeting';

  const UserMeetingScreen({super.key});

  @override
  State<UserMeetingScreen> createState() => _UserMeetingScreenState();
}

class _UserMeetingScreenState extends State<UserMeetingScreen> {
  final RequestUtil requestUtil = RequestUtil();

  late int userId;
  late SharedPreferences prefs;
  bool isLoading = true;
  List<Meeting> futureMeetings = [];
  List<Meeting> pastMeetings = [];

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId')!;
    fetchMeetings();
  }

  Future<void> fetchMeetings() async {
    try {
      var meetingData = await requestUtil.getMeetingsByUserId(userId);
      setState(() {
        DateTime currentDate = DateTime.now();
        futureMeetings = meetingData.where((meet) => DateTime.parse(meet.meetingDate).isAfter(currentDate)).toList();
        pastMeetings = meetingData.where((meet) => DateTime.parse(meet.meetingDate).isBefore(currentDate)).toList();
        isLoading = false;
      });
    } catch (e) {
      Logger().e('Error fetching meetings: $e');
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
        title: const Text('Meetings'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (futureMeetings.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Meetings',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: futureMeetings.length,
                      itemBuilder: (context, index) {
                        final meeting = futureMeetings[index];
                        return MeetingView(meeting: meeting);
                      },
                    ),
                  ),
                ],
                if (pastMeetings.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Meeting History',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pastMeetings.length,
                      itemBuilder: (context, index) {
                        final meeting = pastMeetings[index];
                        return MeetingView(meeting: meeting);
                      },
                    ),
                  ),
                ],
                if (futureMeetings.isEmpty && pastMeetings.isEmpty)
                  const Center(child: Text('You do not have any meetings yet')),
              ],
            ),
    );
  }
}
