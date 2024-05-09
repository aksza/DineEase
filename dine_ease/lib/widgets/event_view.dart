import 'package:dine_ease/models/event_post_model.dart';
import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/screens/event_details_screen.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class EventView extends StatefulWidget {
  final EventPost event;
  const EventView({ super.key,required this.event});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {

  late Eventt selectedEvent;
  final RequestUtil _requestUtil = RequestUtil();

  @override
  void initState() {
    super.initState();
    getEventByIdNew(widget.event.id);
    // Logger().i(selectedEvent);
  }

  Future<Eventt> getEventById(int id) async{
    var sevent = await _requestUtil.getEventById(id);
    Logger().i('eventview:${sevent.eventName} ${sevent.restaurantName} ${sevent.startingDate} ${sevent.endingDate} ${sevent.id} ${sevent.restaurantId}');
    return sevent;
  }
  
  Future<void> getEventByIdNew(int id) async{
    var sevent = await getEventById(id);
    setState(() {
      selectedEvent = sevent;
    });
  }

  @override
  Widget build(BuildContext context) {

    return 
    GestureDetector(
      onTap: (){
        //a kivalasztott eventre navigalas
        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventDetails(selectedEvent: selectedEvent,)),
                    );
      },
      child:
      Container(
        //magassag es szelesseg
        height: 100,
        // width: 100,
        // width: double.infinity,

        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: ListTile(
          title: Text(widget.event.eventName),
          subtitle: Text('${DateFormat.MMMEd().format(widget.event.startingDate).toString()}'),
          leading: Image.asset('assets/test_images/kfc.jpeg', width: 50, height: 50, fit: BoxFit.cover,),
          
        ),
      )
    );
  }
}