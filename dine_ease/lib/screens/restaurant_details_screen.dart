import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/widgets/custom_carousel_slider.dart';
import 'package:flutter/material.dart';

class RestaurantDetails extends StatefulWidget {
  static const routeName = '/restaurant_details_screen';
  Restaurant? selectedRestaurant;

  RestaurantDetails({Key? key, this.selectedRestaurant});

  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(widget.selectedRestaurant!.name),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCarouselSlider(images: 
              // widget.selectedRestaurant!.images
              [
                'assets/test_images/kfc.jpeg',
                'assets/test_images/mcdonalds.jpg',
                'assets/test_images/pizzahut.jpg',
                'assets/test_images/subway.png',
              ]),
            //restaurant name with different text style
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 5),
              child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.selectedRestaurant!.name,
                    style: TextStyle(
                      fontSize: 25,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                  //sizedbox for spacing
                  SizedBox(width: 10,),
                  IconButton(
                    icon: 
                    // Icon(widget.selectedRestaurant.isFavorite ? Icons.favorite : Icons.favorite_border),
                    Icon(Icons.favorite_border),
                    onPressed: (){
                      // widget.onPressed!();
                      // setState(() {
                      //   widget.selectedRestaurant.isFavorite = !widget.selectedRestaurant.isFavorite;
                      // });
                    },
                  )
                ],
              ),
              ),
              //rating with stars
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 15, 10),
                child: 
                  Text(
                    '${widget.selectedRestaurant!.rating != null ? widget.selectedRestaurant!.rating.toString() : '0'} ⭐',
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 102, 102, 102),
                    ),
                  ),     
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 15, 10),
                child: Row(
                        children: [
                          Icon(Icons.comment, color: Colors.orange[700],),
                          Text(
                            '5 reviews',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 102, 102, 102),
                            ),
                          ),
                        ]
                      ),
              ),
              //address with icon
              Padding(
                padding: const EdgeInsets.fromLTRB(17.0, 0, 15, 5),
                child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.orange[700],),
                          Text(
                            widget.selectedRestaurant!.address,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 102, 102, 102),
                            ),
                          ),
                        ]
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
                child: Text('${widget.selectedRestaurant!.description}',
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 102, 102, 102),
                  ),
              ),
            ), 
            //a button to show menu, in center
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: ElevatedButton(
            //       onPressed: (){}, 
            //       child: Text('Show menu',),
            //       style: ButtonStyle(
            //         backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 211, 211, 211)),
            //         padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
            //         textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20, color: Colors.black))
            //       ),
            //     ),
            // ),
            
          ],
      ),
    ),
    //bottom navigation bar with a button to reserve a table if the restaurant is not for event, if it is for event then 
    bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: (){}, 
              //if the restaurant is for event then the button text should be 'Reserve a table' otherwise 'Schedule a meeting'
              child: Text(widget.selectedRestaurant!.forEvent ? 'Schedule a meeting' : 'Reserve a table'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange[700]),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20, color: Colors.black))
              ),
            ),
          ),
    //ha az adott étteremhez tartozik event, akkor az eventeket is megjeleníteni egy horizontalisan gorgetheto listaban
    
    );
  }
}