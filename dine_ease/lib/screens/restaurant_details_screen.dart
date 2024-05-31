import 'package:dine_ease/models/rating_model.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/restaurant_post.dart';
import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/models/review_models.dart';
import 'package:dine_ease/screens/meeting_screen.dart';
import 'package:dine_ease/screens/menu_screen.dart';
import 'package:dine_ease/screens/reservation_screen.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/custom_carousel_slider.dart';
import 'package:dine_ease/widgets/restaurant_review.dart';
import 'package:flutter/material.dart';

import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantDetails extends StatefulWidget {
  static const routeName = '/restaurant_details_screen';
  Restaurant? selectedRestaurant;

  RestaurantDetails({super.key, this.selectedRestaurant});

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  late RestaurantPost sr;
  final RequestUtil _requestUtil = RequestUtil();
  bool isLoading = true;  
  final reviewTextController = TextEditingController();  
  late int userId;
  late SharedPreferences prefs;
  late Review? review;
  // late int rating;
  late Rating rating;

  int tempRating = 0; // Ideiglenes értékelés a csillagok kijelzésére
  bool showRatingButtons = false; // A Send és Cancel gombok megjelenítése

  @override
  void initState() {
    super.initState();
    initPrefs();
    initSelectedRestaurant();
    sr = Provider.of<DineEase>(context, listen: false).getRestaurantById(widget.selectedRestaurant!.id);
  }

  //init shared preferences
  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId')!;
    });
    initRating();
  }

  void initRating() async{
  try {
    var ratingData = await _requestUtil.getRatingsByUserId(userId);
    Rating rating1 = Rating(restaurantId: widget.selectedRestaurant!.id, userId: userId, ratingNumber: 0); // Alapértelmezett érték 0
    // Megkeressük a megfelelő restaurantId-t a ratingek között
    for (var ratingItem in ratingData) {
      if (ratingItem.restaurantId == widget.selectedRestaurant!.id) {
        rating1 = ratingItem;
        break; // Ha megtaláltuk a megfelelő restaurantId-t, kilépünk a ciklusból
      }
    }
    setState(() {
      
      rating = rating1;
      tempRating = rating1.ratingNumber; // Az ideiglenes érték is a rating értékét kapja
    });
  } catch (e) {
    Logger().e('Error fetching ratings: $e');
  }
}


  // Initialize the selected restaurant
  void initSelectedRestaurant() async {
    if (widget.selectedRestaurant != null) {
      try {
        var categories = await _requestUtil.getRCategoriesByRestaurantId(widget.selectedRestaurant!.id);
        var cuisines = await _requestUtil.getCuisinesByRestaurantId(widget.selectedRestaurant!.id);
        var openings = await _requestUtil.getOpeningsByRestaurantId(widget.selectedRestaurant!.id);
        var seatings = await _requestUtil.getSeatingsByRestaurantId(widget.selectedRestaurant!.id);
        var reviews = await _requestUtil.getReviewsByRestaurantId(widget.selectedRestaurant!.id);
        Logger().i('Categories: $categories');
        setState(() {
          widget.selectedRestaurant!.categories = categories;
          widget.selectedRestaurant!.cuisines = cuisines;
          widget.selectedRestaurant!.openings = openings;
          widget.selectedRestaurant!.seatings = seatings;
          widget.selectedRestaurant!.reviews = reviews;
          isLoading = false;  
        });
      } catch (e) {
        Logger().e('Error fetching restaurant details: $e');
        setState(() {
          isLoading = false;  
        });
      }
    } else {
      Logger().i('Restaurant already available');
      setState(() {
        isLoading = false; 
      });
    }
  }

  Future<void> deleteReview(int reviewId) async {
    try {

      await _requestUtil.deleteRemoveReview(reviewId);
      setState(() {
        widget.selectedRestaurant!.reviews!.removeWhere((review) => review.id == reviewId);
      });
    } catch (e) {
      Logger().e('Error deleting review: $e');
    }
  }

  // Function to edit a review
  Future<void> editReview(int reviewId, String newText) async {
    try {
      
      Review review = Review(
        id: reviewId,
        restaurantId: widget.selectedRestaurant!.id,
        userId: userId,
        content: newText,
      );
      await _requestUtil.updateReview(reviewId,review);
      setState(() {
        var review = widget.selectedRestaurant!.reviews!.firstWhere((review) => review.id == reviewId);
        review.content = newText;
        Logger().i('Review edited: ${review.content}');
      });
    } catch (e) {
      Logger().e('Error editing review: $e');
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

  //add review
  void sendReview(String review) async {
    try {
      Review rev = Review(
        restaurantId: widget.selectedRestaurant!.id,
        userId: userId,
        content: review,
      );
      await _requestUtil.postAddReview(rev);
      Logger().i('Review added: ${rev.content}');
      // Clear the text field after adding review
      reviewTextController.clear();
      // Fetch reviews again to update the list
      var reviewData = await _requestUtil.getReviewsByRestaurantId(widget.selectedRestaurant!.id);

      setState(() {
        widget.selectedRestaurant!.reviews = reviewData;
      });

    } catch (e) {
      Logger().e('Error adding review: $e');
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

  // Function to add a rating
  void addRating(int r) async {
    try {
      Rating rating1 = Rating(
        restaurantId: widget.selectedRestaurant!.id,
        userId: userId,
        ratingNumber: r,
      );
      if (rating.ratingNumber != 0) {
        rating1.id = rating.id;
        await _requestUtil.updateRating(rating.id!,rating1);
      } 
      else
      {
        await _requestUtil.postAddRating(rating1);
        initRating();
      }
      setState(() {
        rating = rating1;
        showRatingButtons = false; // Hide the rating buttons after submission
      });
      Logger().i('Rating added: $r');
    } catch (e) {
      Logger().e('Error adding rating: $e');
    }
  }

  void _handleDelete(int ratingId) {
    setState(() {
      rating = Rating(restaurantId: widget.selectedRestaurant!.id, userId: userId, ratingNumber: 0);
      tempRating = 0;
      showRatingButtons = false;
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Rating"),
          content: Text("Are you sure you want to delete your rating?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _requestUtil.deleteRemoveRating(rating.id!);
                  Navigator.pop(context);
                  _handleDelete(rating.id!); 
                } catch (e) {
                  print('Error deleting rating: $e');
                  Navigator.pop(context); 
                }
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
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
        child: isLoading  
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(  
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
                    //an icon with a star and the rating of the restaurant
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 15, 10),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow[700]),
                          Text(
                            '${widget.selectedRestaurant!.rating != null ? widget.selectedRestaurant!.rating.toString() : '0'}',
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
                          child: 
                          Row(
                            children: [
                              Icon(Icons.description, color: Colors.orange[700]),
                              const Text(
                                'Description:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                )
                              )
                            ]
                          )
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
                    //user's rating in star buttons, the user can rate the restaurant
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rating',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              // Display star icons based on the current rating
                              for (int i = 1; i <= 5; i++)
                                IconButton(
                                  icon: Icon(
                                    i <= tempRating ? Icons.star : Icons.star_border,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      tempRating = i;
                                      showRatingButtons = true; // Show the rating buttons when a star is tapped
                                    });
                                  },
                                ),
                              // Show Send and Cancel buttons if showRatingButtons is true
                              if (showRatingButtons)
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.send, color: Colors.orange),
                                      onPressed: () {
                                        addRating(tempRating);
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    IconButton(
                                      icon: Icon(Icons.cancel, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          tempRating = rating.ratingNumber; // Revert to the previous rating
                                          showRatingButtons = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              // Show Trash icon if there is already a rating
                              if (rating.ratingNumber != 0 && !showRatingButtons)
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed:() =>  _showDeleteConfirmationDialog(context),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 15, 10),
                      child: Row(
                        children: [
                          Icon(Icons.comment, color: Colors.orange[700]),
                          Text(
                            '${widget.selectedRestaurant!.reviews != null ? widget.selectedRestaurant!.reviews!.length : 0} reviews',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                    //a textcontroller for the review textfield and a button to sumbit the review
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Write your review here...',
                                border: OutlineInputBorder(),
                              ),
                              controller: reviewTextController,
                            ),
                          ),
                          //iconbutton to submit the review
                          IconButton(
                            icon: Icon(Icons.send, color: Colors.orange[700]),
                            onPressed: () {
                              if(reviewTextController.text.isNotEmpty)
                              {
                                sendReview(reviewTextController.text);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.selectedRestaurant!.reviews!.length,
                      itemBuilder: (context, index) {
                        return RestaurantReview(
                          review: widget.selectedRestaurant!.reviews![index],
                          onDelete: () async{
                            await deleteReview(widget.selectedRestaurant!.reviews![index].id!);
                          },
                          onEdit: (newText)async => {
                            await editReview(widget.selectedRestaurant!.reviews![index].id!,newText),
                          },
                        );
                      },
                    ),
                                
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
