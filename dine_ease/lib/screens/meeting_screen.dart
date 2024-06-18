import 'package:dine_ease/models/meeting_create.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeetingScreen extends StatefulWidget {
  static const routeName = '/meeting';
  Restaurant? selectedRestaurant;

  MeetingScreen({Key? key, this.selectedRestaurant});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen>{

  final RequestUtil requestUtil = RequestUtil();

  final TextEditingController guestSizeController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventTimeController = TextEditingController();
  final TextEditingController meetingTimeController = TextEditingController();
  final TextEditingController meetingDateController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  late SharedPreferences prefs;
  late int userId;

  @override
  void initState(){
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId')!;
    setState(() {
      userId = userId;
    });
  }

  Future<void> schedule() async {
    final String dateTimeString = '${eventDateController.text}T${eventTimeController.text}:00.000';
    final DateTime formattedEventDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(dateTimeString);
    final String meetingDateTimeString = '${meetingDateController.text}T${meetingTimeController.text}:00.000';
    final DateTime formattedMeetingDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(meetingDateTimeString);
    try{
      MeetingCreate meetingCreate = MeetingCreate(
        restaurantId: widget.selectedRestaurant!.id,
        userId: userId,
        eventId: 1,//TODO: event id-nal ki kell cserelni listazasra az eventtypebol
        eventDate: formattedEventDateTime,
        meetingDate: formattedMeetingDateTime,
        phoneNum: phoneNumController.text,
        guestSize: guestSizeController.text.isNotEmpty ? int.parse(guestSizeController.text) : 0,
        comment: commentController.text.isNotEmpty ? commentController.text : null,
      );
      //kiirjuk az osszes adatot
      Logger().i('MeetingCreate: ${meetingCreate.toMap()}');
      await requestUtil.postScheduleAMeeting(meetingCreate);
    }
    catch(e){
      Logger().e('Error scheduling meeting: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(DateTime.now().year + 1),
  );
  if (picked != null && picked != DateTime.now()) {
    setState(() {
      eventDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    });
  }
}

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final DateTime now = DateTime.now();
        final DateTime selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        eventTimeController.text = DateFormat('HH:mm').format(selectedTime);
      });
    }
  }

    Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        meetingDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime2(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final DateTime now = DateTime.now();
        final DateTime selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        meetingTimeController.text = DateFormat('HH:mm').format(selectedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('Meeting at ${widget.selectedRestaurant!.name}'),
      ),
      body: SafeArea(child: 
        Column(children: [
          //implementing all fields
          Expanded(child: 
            SingleChildScrollView(child: 
              Column(children: [
                //event date
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      readOnly: true,
                      controller: eventDateController,
                      onTap: () => _selectDate(context),
                      decoration: const InputDecoration(
                        labelText: 'Event Date',
                        hintText: 'Select event date',
                      ),
                      
                    ),
                  ),
                  //event time
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      readOnly: true,
                      controller: eventTimeController,
                      onTap: () => _selectTime(context),
                      decoration: const InputDecoration(
                        labelText: 'Event Time',
                        hintText: 'Select event time',
                      ),
                    
                    ),
                  ),
                  //guest size
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: guestSizeController,
                      decoration: const InputDecoration(
                        labelText: 'Guest Size',
                        hintText: 'Enter guest size',
                      ),
                    ),
                  ),
                  //meeting date
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      readOnly: true,
                      controller: meetingDateController,
                      onTap: () => _selectDate2(context),
                      decoration: const InputDecoration(
                        labelText: 'Meeting Date',
                        hintText: 'Select meeting date',
                      ),
                    
                    ),
                  ),
                  //meeting time
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      readOnly: true,
                      controller: meetingTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Meeting Time',
                        hintText: 'Select meeting time',
                      ),
                      onTap: () => _selectTime2(context),
                    ),
                  ),
                  //phone number
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: phoneNumController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter phone number',
                      ),
                    ),
                  ),
                  //comment
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        labelText: 'Comment',
                        hintText: 'Enter comment',
                      ),
                    ),
                  )
                ]
              )
            )
          ),
          //reserve button
          ElevatedButton(
            onPressed: (){
              //ha nem uresek a fieldek
              if(eventDateController.text.isEmpty || eventTimeController.text.isEmpty || guestSizeController.text.isEmpty || meetingDateController.text.isEmpty || meetingTimeController.text.isEmpty || phoneNumController.text.isEmpty){
                //kiirjuk melyik mezok uresek
                Logger().i("Empty fields: ${eventDateController.text.isEmpty}, ${eventTimeController.text.isEmpty}, ${guestSizeController.text.isEmpty}, ${meetingDateController.text.isEmpty}, ${meetingTimeController.text.isEmpty}, ${phoneNumController.text.isEmpty}");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields!'),
                  ),
                );
              }
              else{
                schedule();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Meeting scheduled successfully!'),
                  ),
                );
                //navigate back
                Navigator.pop(context);
              }
            },
            child: const Text('Schedule Meeting'),
          )
        ],)
      ),
    );
  }
}