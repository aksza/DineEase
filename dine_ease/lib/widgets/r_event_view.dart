import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';

class REventViewScreen extends StatefulWidget {
  Eventt event;
  final VoidCallback onUpdate;

  REventViewScreen({required this.event, required this.onUpdate});

  @override
  State<REventViewScreen> createState() => _REventViewScreenState();
}

class _REventViewScreenState extends State<REventViewScreen> {
  RequestUtil requestUtil = RequestUtil();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Define the action to be taken when the event is tapped.
        print('Event tapped: ${widget.event.eventName}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange[700],
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.event.eventName,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
