import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/restaurant_post.dart';
import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/screens/meeting_screen.dart';
import 'package:dine_ease/screens/menu_screen.dart';
import 'package:dine_ease/screens/reservation_screen.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/custom_carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

class RestaurantDetails extends StatefulWidget {
  static const routeName = '/restaurant_details_screen';
  Restaurant? selectedRestaurant;

  RestaurantDetails({Key? key, this.selectedRestaurant});

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  late RestaurantPost sr;
  final RequestUtil _requestUtil = RequestUtil();
  bool isLoading = true;  // Added loading state variable

  @override
  void initState() {
    super.initState();
    initSelectedRestaurant();
    sr = Provider.of<DineEase>(context, listen: false).getRestaurantById(widget.selectedRestaurant!.id);
  }

  // Initialize the selected restaurant
  void initSelectedRestaurant() async {
    if (widget.selectedRestaurant != null) {
      try {
        var categories = await _requestUtil.getRCategoriesByRestaurantId(widget.selectedRestaurant!.id);
        var cuisines = await _requestUtil.getCuisinesByRestaurantId(widget.selectedRestaurant!.id);
        var openings = await _requestUtil.getOpeningsByRestaurantId(widget.selectedRestaurant!.id);
        var seatings = await _requestUtil.getSeatingsByRestaurantId(widget.selectedRestaurant!.id);
        Logger().i('Categories: $categories');
        setState(() {
          widget.selectedRestaurant!.categories = categories;
          widget.selectedRestaurant!.cuisines = cuisines;
          widget.selectedRestaurant!.openings = openings;
          widget.selectedRestaurant!.seatings = seatings;
          isLoading = false;  // Set loading to false once data is fetched
        });
      } catch (e) {
        Logger().e('Error fetching restaurant details: $e');
        setState(() {
          isLoading = false;  // Set loading to false in case of error
        });
      }
    } else {
      Logger().i('Restaurant already available');
      setState(() {
        isLoading = false;  // Set loading to false if data is already available
      });
    }
  }

  // Function to toggle favorite status
  void toggleFavorite(RestaurantPost restaurant) {
    Logger().i(sr.isFavorite);
    if (restaurant.isFavorite) {
      removeFromFavorits(restaurant);
      setState(() {
        sr.isFavorite = false;
      });
    } else {
      addToFavorits(restaurant);
      setState(() {
        sr.isFavorite = true;
      });
    }
  }

  // Add to favorites
  void addToFavorits(RestaurantPost restaurant) {
    Provider.of<DineEase>(context, listen: false).addToFavorits(restaurant);
    Logger().i('Added to favorites: ${sr.isFavorite}');
  }

  // Remove from favorites
  void removeFromFavorits(RestaurantPost restaurant) {
    Provider.of<DineEase>(context, listen: false).removeFromFavorits(restaurant);
    Logger().i('Removed from favorites: ${sr.isFavorite}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.selectedRestaurant!.name),
      ),
      body: SafeArea(
        child: isLoading  // Show loading indicator if loading is true
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(  // Added SingleChildScrollView
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCarouselSlider(
                      images: [
                        'assets/test_images/kfc.jpeg',
                        'assets/test_images/mcdonalds.jpg',
                        'assets/test_images/pizzahut.jpg',
                        'assets/test_images/subway.png',
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.selectedRestaurant!.name,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(sr.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.orange[700],
                            ),
                            onPressed: () {
                              toggleFavorite(sr);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 15, 10),
                      child: Text(
                        '${widget.selectedRestaurant!.rating != null ? widget.selectedRestaurant!.rating.toString() : '0'} ⭐',
                        style: const TextStyle(
                          fontSize: 17,
                          
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 15, 10),
                      child: Row(
                        children: [
                          Icon(Icons.comment, color: Colors.orange[700]),
                          Text(
                            '5 reviews',
                            style: const TextStyle(
                              fontSize: 17,
                              
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(17.0, 0, 15, 5),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.orange[700]),
                          Text(
                            widget.selectedRestaurant!.address,
                            style: const TextStyle(
                              fontSize: 17,
                              
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.selectedRestaurant!.categories != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(17.0, 0, 15, 5),
                        child: Row(
                          children: [
                            Icon(Icons.fastfood, color: Colors.orange[700]),
                            Text(
                              'Categories:',
                              style: const TextStyle(
                                fontSize: 17,
                                
                              ),
                            ),
                            SizedBox(width: 10),
                            Wrap(
                              spacing: 5,
                              children: widget.selectedRestaurant!.categories!.map((e) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[700]!),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(e.rCategoryName),
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    if (widget.selectedRestaurant!.cuisines != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(17.0, 0, 15, 5),
                        child: Row(
                          children: [
                            Icon(Icons.food_bank_rounded, color: Colors.orange[700]),
                            Text(
                              'Cuisines:',
                              style: const TextStyle(
                                fontSize: 17,
                                
                              ),
                            ),
                            SizedBox(width: 10),
                            Wrap(
                              spacing: 5,
                              children: widget.selectedRestaurant!.cuisines!.map((e) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[700]!),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(e.cuisineName),
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    //seating types
                    if (widget.selectedRestaurant!.seatings != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(17.0, 0, 15, 5),
                        child: Row(
                          children: [
                            Icon(Icons.event_seat, color: Colors.orange[700]),
                            Text(
                              'Seating:',
                              style: const TextStyle(
                                fontSize: 17,
                                
                              ),
                            ),
                            SizedBox(width: 10),
                            Wrap(
                              spacing: 5,
                              children: widget.selectedRestaurant!.seatings!.map((e) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[700]!),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(e.seatingName),
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(17.0, 0, 15, 5),
                      child: Row(
                        children: [
                          Icon(Icons.attach_money, color: Colors.orange[700]),
                          Text(
                            "${widget.selectedRestaurant!.price} pricing",
                            style: const TextStyle(
                              fontSize: 17,
                              
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 15, 15, 5),
                      child: Text('Description:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 5),
                      child: Text(
                        '${widget.selectedRestaurant!.description}',
                        style: TextStyle(
                          fontSize: 17,
                          
                        ),
                      ),
                    ),
                    //title openings and opening hours, the day is formatted to be displayed as a day
                    if(widget.selectedRestaurant!.openings != null)
                      ... [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 15, 15, 5),
                          child: 
                          Row(
                            children: [
                              Icon(Icons.access_time, color: Colors.orange[700]),
                              const Text(
                                'Opening hours:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                )
                              )
                            ]
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 5),
                          child: Column(
                            children: widget.selectedRestaurant!.openings!.map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Text('${e.day[0].toUpperCase()}${e.day.substring(1)}:'),
                                  //day of the week is formatted to be displayed as a day
                                  Text('${DateTime.sunday == e.day ? 'Sunday' : DateTime.monday == e.day ? 'Monday' : DateTime.tuesday == e.day ? 'Tuesday' : DateTime.wednesday == e.day ? 'Wednesday' : DateTime.thursday == e.day ? 'Thursday' : DateTime.friday == e.day ? 'Friday' : 'Saturday'}',
                                  style: TextStyle(
                                    fontSize: 17
                                  ),),
                                  Text('${e.openingHour} - ${e.closingHour}',
                                  style: TextStyle(
                                    fontSize: 17
                                  ),
                                  ),
                                  
                                ],
                              ),
                            )).toList(),
                          ),
                        ),
                      ],

                    if (!widget.selectedRestaurant!.forEvent)
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MenuScreen(restaurantId: widget.selectedRestaurant!.id
                          )),
                          );
                        },
                          child: Text('Show menu'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 211, 211, 211)),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                            textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20, color: Colors.black)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            if (!widget.selectedRestaurant!.forEvent) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservationScreen(selectedRestaurant: widget.selectedRestaurant!)),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MeetingScreen(selectedRestaurant: widget.selectedRestaurant)),
              );
            }
          },
          child: Text(widget.selectedRestaurant!.forEvent ? 'Schedule a meeting' : 'Reserve a table'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orange[700]),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
            textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20, color: Colors.black)),
          ),
        ),
      ),
    );
  }
}
