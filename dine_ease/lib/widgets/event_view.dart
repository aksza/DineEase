import 'package:dine_ease/models/event_post_model.dart';
import 'package:flutter/material.dart';

class EventView extends StatelessWidget {
  final EventPost event;

  const EventView({ super.key,required this.event});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child: ListTile(
        title: Text(event.eventName),
        subtitle: Text('${event.startingDate.toIso8601String()} - ${event.endingDate.toIso8601String()}'),
        leading: Image.asset('assets/test_images/kfc.jpeg', width: 50, height: 50, fit: BoxFit.cover,),
        
      ),
    );
  }
}