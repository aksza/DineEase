import 'package:dine_ease/models/event_post_model.dart';
import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/screens/event_details_screen.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class EventView extends StatefulWidget {
  final EventPost event;
  const EventView({super.key, required this.event});

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
  }

  Future<Eventt> getEventById(int id) async {
    var sevent = await _requestUtil.getEventById(id);
    sevent.eCategories = widget.event.eCategories;
    return sevent;
  }

  Future<void> getEventByIdNew(int id) async {
    var sevent = await getEventById(id);
    setState(() {
      selectedEvent = sevent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // a kivalasztott eventre navigalas
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetails(selectedEvent: selectedEvent),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo section
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(
                'assets/test_images/calendar4.png',
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            // Information section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Event name and date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.event.eventName} at ${widget.event.restaurantName}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${DateFormat.MMMEd().format(widget.event.startingDate)}',
                      ),
                    ],
                  ),
                  // Add any other elements you need here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
