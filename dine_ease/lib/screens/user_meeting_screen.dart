import 'package:dine_ease/models/meeting_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/meeting_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMeetingScreen extends StatefulWidget{
  static const routename = '/user-meeting';

  const UserMeetingScreen({super.key});

  @override
  State<UserMeetingScreen> createState() => _UserMeetingScreenState();
}

class _UserMeetingScreenState extends State<UserMeetingScreen>{

  final RequestUtil requestUtil = RequestUtil();

  late int userId;
  late SharedPreferences prefs;
  bool isLoading = true;
  List<Meeting> meetings = [];


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

  //fetching reservations by user id
  Future<void> fetchMeetings() async {
      try {
        
        var meetingData = await requestUtil.getMeetingsByUserId(userId);
        setState(() {
          meetings = meetingData;
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
        //title is reservation or waiting
        title: const Text('Meetings'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : meetings.isEmpty
              ? Center(child: Text('You do not have accepted meetings yet'))
              : ListView.builder(
                  itemCount: meetings.length,
                  itemBuilder: (context, index) {
                    final meeting = meetings[index];
                    return MeetingView(meeting: meeting);
                  },
                ),
    );
  }
}