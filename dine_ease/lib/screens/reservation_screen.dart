import 'package:dine_ease/models/reservation_create.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationScreen extends StatefulWidget {
  static const routeName = '/reservation';
  Restaurant? selectedRestaurant;

  ReservationScreen({Key? key, this.selectedRestaurant});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen>{

  final RequestUtil requestUtil = RequestUtil();

  final TextEditingController partySizeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
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

  Future<void> reserve() async {
    final String dateTimeString = '${dateController.text}T${timeController.text}:00.000';
    final DateTime formattedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(dateTimeString);
    try{
      ReservationCreate rescreate = ReservationCreate(
        restaurantId: widget.selectedRestaurant!.id,
        userId: userId,
        partySize: int.parse(partySizeController.text),
        date: formattedDateTime,
        phoneNum: '0712345678',
        //comment if not null else null
        comment: commentController.text.isNotEmpty ? commentController.text : null,
      );
      Logger().i('Reservation: ${rescreate.toMap()}');
      await requestUtil.postReserveATable(rescreate);
    }
    catch(e){
      Logger().e('Error reserving table: $e');
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
      dateController.text = DateFormat('yyyy-MM-dd').format(picked); // A kiválasztott dátum formázása
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
      timeController.text = DateFormat('HH:mm').format(selectedTime); // A kiválasztott időpont formázása
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
        title: Text('Reserve at ${widget.selectedRestaurant!.name}'),
      ),
      body: SafeArea(child: 
        Column(children: [
          //party size
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: partySizeController,
              decoration: const InputDecoration(
                labelText: 'Party Size',
                hintText: 'Enter party size',
              ),
            ),
          ),         
          // Date picker
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                readOnly: true,
                controller: dateController,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(
                  labelText: 'Date',
                  hintText: 'Select date',
                ),
              ),
            ),
            // Time picker
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                readOnly: true,
                controller: timeController,
                onTap: () => _selectTime(context),
                decoration: const InputDecoration(
                  labelText: 'Time',
                  hintText: 'Select time',
                ),
              ),
            ),
          //phone number
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
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
          ),
          //reserve button
          ElevatedButton(
            onPressed: (){
              //ha nem uresek a fieldek
              if(partySizeController.text.isEmpty || dateController.text.isEmpty || timeController.text.isEmpty)
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields'),
                  ),
                );
              }
              else{
                reserve();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Table reserved successfully!'),
                  ),
                );
                //navigate back
                Navigator.pop(context);
              }
            },
            child: const Text('Reserve'),
          )
        ],)
      ),
    );
  }
}