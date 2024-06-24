import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/models/event_post_model.dart';
import 'package:dine_ease/widgets/event_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DineEase>(builder: (context, value, child) => 
      SafeArea(child: 
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: value.events.length,
                  itemBuilder: (context, index){
                    EventPost event = value.events[index];

                    return EventView(event: event);
                  }
                )
              )
            ]
          )
        )
      )
    ,);
      
  }
}