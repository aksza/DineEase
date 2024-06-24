import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/screens/reservation_screen.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/custom_carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EventDetails extends StatefulWidget {
  static const routeName = '/event_details_screen';
  Eventt? selectedEvent;
  EventDetails({super.key, this.selectedEvent});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {

  final requestUtil = RequestUtil();
  late Restaurant restaurant;

  @override
  void initState() {
    super.initState();
    getRestaurant();
  }

  Future<void> getRestaurant() async {
    restaurant = await requestUtil.getRestaurantById(widget.selectedEvent!.restaurantId);
    setState(() {
      restaurant = restaurant;
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[700],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text('Event ${widget.selectedEvent!.eventName}'),
        ),
        body: 
          SafeArea(
            child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              CustomCarouselSlider(images: 
                [
                  'assets/test_images/calendar4.png'
                ]
              ),
              //event name
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0,15,15,5),
                child: Text(widget.selectedEvent!.eventName, style: const TextStyle(fontSize: 25),),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 5),
                child: Text('Location: ${widget.selectedEvent!.restaurantName}',
                style: const TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 102, 102, 102),
                  fontStyle: FontStyle.italic
                  ),),
                ),
                Padding(padding: 
                  const EdgeInsets.fromLTRB(15.0, 0, 15, 5),
                  child: Text('Starts: ${DateFormat.MMMMEEEEd().format(widget.selectedEvent!.startingDate).toString() + ', ' + DateFormat.Hm().format(widget.selectedEvent!.startingDate).toString()}',
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 102, 102, 102),
                    ),
                ),
                )
                ,Padding(padding: 
                  const EdgeInsets.fromLTRB(15.0, 0, 15, 5),
                  child: Text('Ends: ${DateFormat.MMMMEEEEd().format(widget.selectedEvent!.endingDate).toString() + ', ' + DateFormat.Hm().format(widget.selectedEvent!.endingDate).toString()}',
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 102, 102, 102),
                    ),
                ),
                ),

                if(widget.selectedEvent!.eCategories != null)
                ...[
                  const Padding(padding: 
                    EdgeInsets.fromLTRB(15.0, 15, 15, 5),
                    child: Text('Categories:', style: TextStyle(fontSize: 20),),
                  ),
                  Padding(padding: 
                    const EdgeInsets.fromLTRB(15.0, 0, 15, 5),
                    child: Text('${widget.selectedEvent!.eCategories!.map((e) => e.eCategoryName).join(', ')}',
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 102, 102, 102),
                      ),
                  ),
                  ),
                ],
                const Padding(padding: 
                  EdgeInsets.fromLTRB(15.0, 15, 15, 5),
                  child: Text('Description:', style: TextStyle(fontSize: 20),),
                ),
                Padding(padding: 
                  const EdgeInsets.fromLTRB(15.0, 0, 15, 5),
                  child: Text('${widget.selectedEvent!.description}',
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 102, 102, 102),
                    ),
                ),
                ),               
              ]
            )
            ) 
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReservationScreen(selectedRestaurant: restaurant,startingDate: widget.selectedEvent!.startingDate,endingDate: widget.selectedEvent!.endingDate,)),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange[700]),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 20, color: Colors.black))
              ), 
              child: const Text('Reserve a table'),
            ),
          ),
    );
    
  }
}