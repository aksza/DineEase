import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/widgets/custom_carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EventDetails extends StatefulWidget {
  static const routeName = '/event_details_screen';
  Eventt? selectedEvent;
  EventDetails({super.key, this.selectedEvent});

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  
  @override
  Widget build(BuildContext context) {
    //appbar egy vissza gombbal, es a kivalasztott event 
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
                // widget.selectedEvent!.images
                [
                  'assets/test_images/kfc.jpeg',
                  'assets/test_images/mcdonalds.jpg',
                  'assets/test_images/pizzahut.jpg',
                  'assets/test_images/subway.png',
                ]
              ),
              //event name
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0,15,15,5),
                child: Text(widget.selectedEvent!.eventName, style: TextStyle(fontSize: 25),),
              ),
              //restaurant name with different text style
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 5),
                child: Text('Location: ${widget.selectedEvent!.restaurantName}',
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 102, 102, 102),
                  //dolt betukkel irja
                  fontStyle: FontStyle.italic
                  ),),
                ),
                //event starting date in a suitable format (e.g. 2021.12.31 12:00)
                Padding(padding: 
                  const EdgeInsets.fromLTRB(15.0, 0, 15, 5),
                  child: Text('Starts: ${DateFormat.MMMMEEEEd().format(widget.selectedEvent!.startingDate).toString() + ', ' + DateFormat.Hm().format(widget.selectedEvent!.startingDate).toString()}',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 102, 102, 102),
                    ),
                ),
                )
                //event ending date in a suitable format (e.g. 2021.12.31 12:00)
                ,Padding(padding: 
                  const EdgeInsets.fromLTRB(15.0, 0, 15, 5),
                  child: Text('Ends: ${DateFormat.MMMMEEEEd().format(widget.selectedEvent!.endingDate).toString() + ', ' + DateFormat.Hm().format(widget.selectedEvent!.endingDate).toString()}',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 102, 102, 102),
                    ),
                ),
                ),
                //description title
                Padding(padding: 
                  const EdgeInsets.fromLTRB(15.0, 15, 15, 5),
                  child: Text('Description:', style: TextStyle(fontSize: 20),),
                ),
                //event description
                Padding(padding: 
                  const EdgeInsets.fromLTRB(15.0, 0, 15, 5),
                  child: Text('${widget.selectedEvent!.description}',
                  style: TextStyle(
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
              onPressed: (){}, 
              child: Text('Reserve a table'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange[700]),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20, color: Colors.black))
              ),
            ),
          ),
    );
    
  }
}