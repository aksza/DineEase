import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
// import 'dart:html';

import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/categories_restaurant_model.dart';
import 'package:dine_ease/models/cuisine_model.dart';
import 'package:dine_ease/models/cuisines_restaurant_model.dart';
import 'package:dine_ease/models/e_category.dart';
import 'package:dine_ease/models/event_type_model.dart';
import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/models/meeting_create.dart';
import 'package:dine_ease/models/meeting_model.dart';
import 'package:dine_ease/models/menu_model.dart';
import 'package:dine_ease/models/menu_type_model.dart';
import 'package:dine_ease/models/opening_model.dart';
import 'package:dine_ease/models/order_model.dart';
import 'package:dine_ease/models/price_model.dart';
import 'package:dine_ease/models/r_category.dart';
import 'package:dine_ease/models/rating_model.dart';
import 'package:dine_ease/models/register_restaurant_form.dart';
import 'package:dine_ease/models/reservation_create.dart';
import 'package:dine_ease/models/reservation_model.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/models/review_models.dart';
import 'package:dine_ease/models/seating_model.dart';
import 'package:dine_ease/models/seatings_restaurant_model.dart';
import 'package:dine_ease/models/upload_restaurant_image.dart';
import 'package:dine_ease/models/user_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class RequestUtil {
  String baseUrl = 'https://';
  RequestUtil() {
    initialize().then((value) {
      baseUrl += value;
    });
  }

  Future<String> initialize() async{
    await dotenv.load(fileName: "assets/env/.env");
    String baseUrl;
    if(kIsWeb){
      baseUrl = dotenv.env['BASE_URL_W']!;
    } else {
      baseUrl = dotenv.env['BASE_URL_E']!;
    }
    return baseUrl;
  }

  Future<http.Response> postUserLogin(String email, String password) async {
    try{
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['USER_LOGIN']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
          {
            'email': email,
            'password': password
          }
        )        
      );
      Logger().i(resp.body);
      return resp;
    }catch(e){
      Logger().e('Error logging in user: $e');
      rethrow;
    }    
  }

  Future<http.Response> postLogin(String email, String password) async {
    try{
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['LOGIN']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
          {
            'email': email,
            'password': password
          }
        )        
      );
      Logger().i(resp.body);
      return resp;
    }catch(e){
      Logger().e('Error logging in: $e');
      rethrow;
    }    
  }

  Future<void> postUserCreate(String firstName,String lastName,String email,String password,String phoneNum) async {
    try{
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['USER_CREATE']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
          {
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'password': password,
            'phoneNum': phoneNum,
            'admin' : false
          }
        )        
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error creating user: $e');
      rethrow;
    }    
  }

  Future<void> postRestaurantCreate(RegisterRestaurant registerRestaurant) async {
    try{
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RESTAURANT_CREATE']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
          registerRestaurant.toMap()
        )        
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error creating restaurant: $e');
      rethrow;
    }    
  }

  Future<List<Restaurant>> getRestaurants() async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RESTAURANT_GET']!);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      List<dynamic> restaurants = jsonDecode(resp.body);
      return restaurants.map((restaurant) => Restaurant.fromJson(restaurant)).toList();
    }catch(e){
      Logger().e('Error getting restaurants: $e');
      rethrow;
    }
  }

  Future<List<Restaurant>> getFavoritRestaurantsByUserId(int userId) async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['FAVORIT_RESTAURANT_GET']! + userId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }      
      );
      Logger().i(resp.body);
      List<dynamic> restaurants = jsonDecode(resp.body);
      return restaurants.map((restaurant) => Restaurant.fromJson(restaurant)).toList();
    }catch(e){
      Logger().e('Error getting favorit restaurants: $e');
      rethrow;
    }
  }

  Future<void> postAddFavoritRestaurant(int userId, int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['ADDFAVORIT_RESTAURANT_POST']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          {
            'userId': userId,
            'restaurantId': restaurantId
          }
        )        
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error adding favorit restaurant: $e');
      rethrow;
    }    
  }

  Future<void> deleteRemoveFavoritRestaurant(int userId, int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['REMOVEFAVORIT_RESTAURANT_DELETE']!);
      Logger().i(url);
      resp = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          {
            'userId': userId,
            'restaurantId': restaurantId
          }
        )        
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error removing favorit restaurant: $e');
      rethrow;
    }    
  }

  Future<List<Eventt>> getEvents() async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['EVENT_GET']!);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      List<dynamic> events = jsonDecode(resp.body);
      return events.map((event) => Eventt.fromJson(event)).toList();
    }catch(e){
      Logger().e('Error getting events: $e');
      rethrow;
    }
  }

  Future<Eventt> getEventById(int eventId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['EVENT_GET_BY_ID']! + eventId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      return Eventt.fromJson(jsonDecode(resp.body));
    }catch(e){
      Logger().e('Error getting event by id: $e');
      rethrow;
    }
  }

  Future<Restaurant> getRestaurantById(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RESTAURANT_GET_BY_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      return Restaurant.fromJson(jsonDecode(resp.body));
    }catch(e){
      Logger().e('Error getting restaurant by id: $e');
      rethrow;
    }
  }

  Future<int> postReserveATable(ReservationCreate reservationCreate) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RESERVE_TABLE_POST']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          reservationCreate.toMap()
        )
      );
      Logger().i(resp.body);
      return jsonDecode(resp.body);
    }catch(e){
      Logger().e('Error reserving a table: $e');
      rethrow;
    }    
  }

  Future<void> postScheduleAMeeting(MeetingCreate meetingCreate) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['SCHEDULE_MEETING_POST']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
          meetingCreate.toMap()
        )        
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error scheduling a meeting: $e');
      rethrow;
    }    
  }

  Future<List<Menu>> getMenuByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['MENU_GET']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      List<dynamic> menus = jsonDecode(resp.body);
      return menus.map((menu) => Menu.fromJson(menu)).toList();
    }
    catch(e){
      Logger().e('Error getting menu by restaurant id: $e');
      rethrow;
    }
  }

  //add order
  Future<void> postOrder(Order order) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['ORDER_POST']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(order.toOMap())        
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error posting order: $e');
      rethrow;
    }    
  }

  Future<User> getUserById(int userId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['USER_GET_BY_ID']! + userId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      return User.fromJson(jsonDecode(resp.body));
    }catch(e){
      Logger().e('Error getting user by id: $e');
      rethrow;
    }
  }

  Future<void> postUserUpdate(int userId,User user) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['USER_UPDATE']! + userId.toString());
      Logger().i(url);
      resp = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(user.toMap())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error updating user: $e');
      rethrow;
    }    
  }

  Future<List<Reservation>> getReservationsByUserId(int userId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RESERVATION_GET_BY_USER_ID']! + userId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> reservations = jsonDecode(resp.body);
      return reservations.map((reservation) => Reservation.fromJson(reservation)).toList();
    }catch(e){
      Logger().e('Error getting reservations by user id: $e');
      rethrow;
    }
  }
  Future<List<Reservation>> getWaitingsByUserId(int userId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['WAITING_GET_BY_USER_ID']! + userId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> reservations = jsonDecode(resp.body);
      return reservations.map((reservation) => Reservation.fromJson(reservation)).toList();
    }catch(e){
      Logger().e('Error getting reservations by user id: $e');
      rethrow;
    }
  }

  Future<List<Meeting>> getMeetingsByUserId(int userId) async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['MEETING_GET_BY_USER_ID']! + userId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> meetings = jsonDecode(resp.body);
      return meetings.map((meeting) => Meeting.fromJson(meeting)).toList();
    }catch(e){
      Logger().e('Error getting meetings by user id: $e');
      rethrow;
    }
  }

  Future<List<Meeting>> getWaitingsMByUserId(int userId) async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['WAITINGM_GET_BY_USER_ID']! + userId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> meetings = jsonDecode(resp.body);
      return meetings.map((meeting) => Meeting.fromJson(meeting)).toList();
    }catch(e){
      Logger().e('Error getting meetings by user id: $e');
      rethrow;
    }
  }

  Future<List<Review>> getReviewsByUserId (int userId) async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['REVIEW_GET_BY_USER_ID']! + userId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> reviews = jsonDecode(resp.body);
      return reviews.map((review) => Review.fromJson(review)).toList();
    }catch(e){
      Logger().e('Error getting reviews by user id: $e');
      rethrow;
    }
  }

  Future<void> deleteRemoveReview(int reviewId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['REMOVE_REVIEW_DELETE']!+ reviewId.toString());
      Logger().i(url);
      resp = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      Logger().i('review: $reviewId');

      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error removing review: $e');
      rethrow;
    }    
  }

  Future<void> updateReview(int reviewId,Review review) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['REVIEW_UPDATE']! + reviewId.toString());
      Logger().i(url);
      resp = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(review.toUpdateMap())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error updating review: $e');
      rethrow;
    }    
  }
  //getRatingsByUserId
  Future<List<Rating>> getRatingsByUserId (int userId) async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RATING_GET_BY_USER_ID']! + userId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> ratings = jsonDecode(resp.body);
      return ratings.map((rating) => Rating.fromJson(rating)).toList();
    }catch(e){
      Logger().e('Error getting ratings by user id: $e');
      rethrow;
    }
  }

  //updateRating
  Future<void> updateRating(int ratingId,Rating rating) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RATING_UPDATE']! + ratingId.toString());
      Logger().i(url);
      resp = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(rating.toMap())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error updating rating: $e');
      rethrow;
    }    
  }

  //deleteRating
  Future<void> deleteRemoveRating(int ratingId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['REMOVE_RATING_DELETE']!+ ratingId.toString());
      Logger().i(url);
      resp = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error removing rating: $e');
      rethrow;
    }    
  }

  //addRating
  Future<void> postAddRating(Rating rating) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['ADD_RATING_POST']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(rating.toCreateMap())        
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error adding rating: $e');
      rethrow;
    }    
  }

  //getEcategories
  Future<List<ECategory>> getEcategories() async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['ECATEGORY_GET']!);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      List<dynamic> eCategories = jsonDecode(resp.body);
      return eCategories.map((eCategory) => ECategory.fromJson(eCategory)).toList();
    }catch(e){
      Logger().e('Error getting eCategories: $e');
      rethrow;
    }
  }

  //getECategoriesByEvent
  Future<List<ECategory>> getECategoriesByEvent(int eventId) async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl  + dotenv.env['EVENT_GET_BY_ID']! + eventId.toString() + dotenv.env['ECATEGORY_GET_BY_EVENT']!);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      List<dynamic> eCategories = jsonDecode(resp.body);
      return eCategories.map((eCategory) => ECategory.fromEJson(eCategory)).toList();
    }catch(e){
      Logger().e('Error getting eCategories by event: $e');
      rethrow;
    }
  }

  //getRCategories
  Future<List<RCategory>> getRcategories() async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RCATEGORY_GET']!);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      List<dynamic> rCategories = jsonDecode(resp.body);
      return rCategories.map((rCategory) => RCategory.fromJson(rCategory)).toList();
    }catch(e){
      Logger().e('Error getting rCategories: $e');
      rethrow;
    }
  }

  //getRCategoriesByRestaurantId
  Future<List<RCategory>?> getRCategoriesByRestaurantId(int restaurantId) async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RESTAURANT_GET_BY_ID']! + restaurantId.toString() +dotenv.env['RCATEGORY_GET_BY_RESTAURANT']! );
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      if (resp.body.isEmpty) {
        return null;
      }
      List<dynamic> rCategories = jsonDecode(resp.body);
      return rCategories.map((rCategory) => RCategory.fromRJson(rCategory)).toList();
    }catch(e){
      Logger().e('${restaurantId} Error getting rCategories by restaurant: $e');
      rethrow;
    }
  }

  //getCuisines
  Future<List<Cuisine>> getCuisines() async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['CUISINE_GET']!);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      List<dynamic> cuisines = jsonDecode(resp.body);
      return cuisines.map((cuisine) => Cuisine.fromJson(cuisine)).toList();
    }catch(e){
      Logger().e('Error getting cuisines: $e');
      rethrow;
    }
  }

  //getCuisinesByRestaurantId
  Future<List<Cuisine>?> getCuisinesByRestaurantId(int restaurantId) async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RESTAURANT_GET_BY_ID']! + restaurantId.toString() +dotenv.env['CUISINE_GET_BY_RESTAURANT']! );
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      if (resp.body.isEmpty) {
        return null;
      }
      List<dynamic> cuisines = jsonDecode(resp.body);
      return cuisines.map((cuisine) => Cuisine.fromCJson(cuisine)).toList();
    }catch(e){
      Logger().e('Error getting cuisines by restaurant: $e');
      rethrow;
    }
  }

  //getOpeningsByRestaurantId
  Future<List<Opening>?> getOpeningsByRestaurantId(int restaurantId) async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RESTAURANT_GET_BY_ID']! + restaurantId.toString() +dotenv.env['OPENING_GET_BY_RESTAURANT']! );
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      if (resp.body.isEmpty) {
        return null;
      }
      List<dynamic> openings = jsonDecode(resp.body);
      return openings.map((opening) => Opening.fromJson(opening)).toList();
    }catch(e){
      Logger().e('Error getting openings by restaurant: $e');
      rethrow;
    }
  }

  //add openings
  Future<void> postAddOpenings(List<Opening> openings)async{
    try{
      String token =await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['OPENING_POST']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(openings.map((opening) => opening.toCreateMap()).toList())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error adding openings: $e');
      rethrow;
    }
  }

  //update openings
  Future<void> putUpdateOpenings(List<Opening> openings)async{
    try{
      String token =await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['OPENING_PUT']!);
      Logger().i(url);
      resp = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(openings.map((opening) => opening.toUpdateMap()).toList())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error updating openings: $e');
      rethrow;
    }
  }
  

  //getPrices
  Future<List<Price>> getPrices() async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['PRICE_GET']!);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      List<dynamic> prices = jsonDecode(resp.body);
      return prices.map((price) => Price.fromJson(price)).toList();
    }catch(e){
      Logger().e('Error getting prices: $e');
      rethrow;
    }
  }

  //getPriceByRestaurantId
  Future<Price?> getPriceByRestaurantId(int restaurantId) async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RESTAURANT_GET_BY_ID']! + restaurantId.toString() +dotenv.env['PRICE_GET_BY_RESTAURANT']! );
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      if (resp.body.isEmpty) {
        return null;
      }
      return Price.fromJson(jsonDecode(resp.body));
    }catch(e){
      Logger().e('Error getting price by restaurant: $e');
      rethrow;
    }
  }

  //getSeatings
  Future<List<Seating>> getSeatings() async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['SEATING_GET']!);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      List<dynamic> seatings = jsonDecode(resp.body);
      return seatings.map((seating) => Seating.fromJson(seating)).toList();
    }catch(e){
      Logger().e('Error getting seatings: $e');
      rethrow;
    }
  }

  //getSeatingsByRestaurantId
  Future<List<Seating>?> getSeatingsByRestaurantId(int restaurantId) async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RESTAURANT_GET_BY_ID']! + restaurantId.toString() +dotenv.env['SEATING_GET_BY_RESTAURANT']! );
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      if (resp.body.isEmpty) {
        return null;
      }
      List<dynamic> seatings = jsonDecode(resp.body);
      return seatings.map((seating) => Seating.fromSJson(seating)).toList();
    }catch(e){
      Logger().e('Error getting seatings by restaurant: $e');
      rethrow;
    }
  }

  //getMeetingEventTypes
  Future<List<EventType>> getMeetingEventTypes() async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['MEETING_EVENTTYPE_GET']!);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      List<dynamic> eventTypes = jsonDecode(resp.body);
      return eventTypes.map((eventType) => EventType.fromJson(eventType)).toList();
    }catch(e){
      Logger().e('Error getting eventTypes: $e');
      rethrow;
    }
  }

  //getMenuTypes
  Future<List<MenuType>> getMenuTypes() async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['MENU_TYPE_GET']!);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      List<dynamic> menuTypes = jsonDecode(resp.body);
      return menuTypes.map((menuType) => MenuType.fromJson(menuType)).toList();
    }catch(e){
      Logger().e('Error getting menuTypes: $e');
      rethrow;
    }
  }

  //addReview
  Future<void> postAddReview(Review review) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['ADD_REVIEW_POST']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(review.toAddMap())        
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error adding review: $e');
      rethrow;
    }    
  }

  //getReviewsByRestaurantId
  Future<List<Review>?> getReviewsByRestaurantId(int restaurantId) async{
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['REVIEW_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      if (resp.body.isEmpty) {
        return null;
      }
      List<dynamic> reviews = jsonDecode(resp.body);
      return reviews.map((review) => Review.fromJson(review)).toList();
    }catch(e){
      Logger().e('Error getting reviews by restaurant: $e');
      rethrow;
    }
  }

  //search in restaurants
  Future<List<Restaurant>?> searchRestaurants(String search) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RESTAURANT_SEARCH']! + search);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      List<dynamic> restaurants = jsonDecode(resp.body);
      return restaurants.map((restaurant) => Restaurant.fromJson(restaurant)).toList();
    }catch(e){
      Logger().e('Error searching restaurants: $e');
      rethrow;
    }
  }

  //search in events
  Future<List<Eventt>?> searchEvents(String search) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['EVENT_SEARCH']! + search);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }       
      );
      Logger().i(resp.body);
      List<dynamic> events = jsonDecode(resp.body);
      return events.map((event) => Eventt.fromJson(event)).toList();
    }catch(e){
      Logger().e('Error searching events: $e');
      rethrow;
    }
  }

  //put function updating reservation
  Future<void> putUpdateReservation(int reservationId,Reservation reservation) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RESERVATION_UPDATE']!);
      Logger().i(url);
      resp = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(reservation.toMap())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error updating reservation: $e');
      rethrow;
    }    
  }

  //get waitinglist by restaurant id
  Future<List<Reservation>> getWaitingListByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['WAITING_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> waitingList = jsonDecode(resp.body);
      return waitingList.map((waiting) => Reservation.fromJson(waiting)).toList();
    }catch(e){
      Logger().e('Error getting waiting list by restaurant id: $e');
      rethrow;
    }
  }

  //get accepted reservations by restaurant id
  Future<List<Reservation>> getAcceptedReservationsByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['ACCEPTED_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> acceptedReservations = jsonDecode(resp.body);
      return acceptedReservations.map((acceptedReservation) => Reservation.fromJson(acceptedReservation)).toList();
    }catch(e){
      Logger().e('Error getting accepted reservations by restaurant id: $e');
      rethrow;
    }
  }

  //getorders by reservation id
  Future<List<Order>> getOrdersByReservationId(int reservationId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['ORDER_GET_BY_RES_ID']! + reservationId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> orders = jsonDecode(resp.body);
      return orders.map((order) => Order.fromJson(order)).toList();
    }catch(e){
      Logger().e('Error getting orders by reservation id: $e');
      rethrow;
    }
  }

  //get events by restaurant id
  Future<List<Eventt>> getEventsByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['EVENT_GET_F_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> events = jsonDecode(resp.body);
      return events.map((event) => Eventt.fromJson(event)).toList();
    }catch(e){
      // Logger().e('Error getting events by restaurant id: $e');
      Logger().e(baseUrl + dotenv.env['EVENT_GET_F_BY_RES_ID']! + restaurantId.toString());
      rethrow;
    }
  }

  //get old events
  Future<List<Eventt>> getOldEvents(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['EVENT_GET_O_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> events = jsonDecode(resp.body);
      return events.map((event) => Eventt.fromJson(event)).toList();
    }catch(e){
      Logger().e('Error getting old events: $e');
      rethrow;
    }
  }

  //add event
  Future<void> postAddEvent(Eventt eventt) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['EVENT_POST']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(eventt.toCreateMap())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error adding event: $e');
      rethrow;
    }    
  }

  //update event
  Future<void> putUpdateEvent(Eventt eventt) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['EVENT_UPDATE']!);
      Logger().i(url);
      resp = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(eventt.toMap())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error updating event: $e');
      rethrow;
    }    
  }

  //update restaurant
  Future<void> putUpdateRestaurant(Restaurant restaurant) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['RESTAURANT_UPDATE']!);
      Logger().i(url);
      resp = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(restaurant.toUpdateMap())
      );
      Logger().i(restaurant.toUpdateMap());
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error updating restaurant: $e');
      rethrow;
    }    
  }

  //add cuisinerestaurant
  Future<void> postAddCuisinesRestaurant(List<CuisineRestaurant> cuisinerestaurant)async
  {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['CUISINE_RESTAURANT_POST']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(cuisinerestaurant.map((cuisinerestaurant) => cuisinerestaurant.toMap()).toList())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error adding cuisinerestaurant: $e');
      rethrow;
    }    
  }
  
  //remove cuisinerestaurant
  Future<void> deleteRemoveCuisineRestaurant(List<CuisineRestaurant> cuisinerestaurant) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['REMOVE_CUISINE_RESTAURANT_DELETE']!);
      Logger().i(url);
      resp = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(cuisinerestaurant.map((cuisinerestaurant) => cuisinerestaurant.toMap()).toList())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error removing cuisinerestaurant: $e');
      rethrow;
    }    
  }

  //add seatingrestaurant
  Future<void> postAddSeatingRestaurant(List<SeatingRestaurant> seatingrestaurant)async
  {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['SEATING_RESTAURANT_POST']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(seatingrestaurant.map((seatingrestaurant) => seatingrestaurant.toMap()).toList())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error adding seatingrestaurant: $e');
      rethrow;
    }    
  }

  //remove seatingrestaurant
  Future<void> deleteRemoveSeatingRestaurant(List<SeatingRestaurant> seatingrestaurant) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['REMOVE_SEATING_RESTAURANT_DELETE']!);
      Logger().i(url);
      resp = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(seatingrestaurant.map((seatingrestaurant) => seatingrestaurant.toMap()).toList())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error removing seatingrestaurant: $e');
      rethrow;
    }    
  }

  //add categoriesrestaurant
  Future<void> postAddCategoriesRestaurant(List<CategoriesRestaurant> categoriesrestaurant)async
  {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['CATEGORIES_RESTAURANT_POST']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(categoriesrestaurant.map((categoriesrestaurant) => categoriesrestaurant.toMap()).toList())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error adding categoriesrestaurant: $e');
      rethrow;
    }    
  }

  //remove categoriesrestaurant
  Future<void> deleteRemoveCategoriesRestaurant(List<CategoriesRestaurant> categoriesrestaurant) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['REMOVE_CATEGORIES_RESTAURANT_DELETE']!);
      Logger().i(url);
      resp = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(categoriesrestaurant.map((categoriesrestaurant) => categoriesrestaurant.toMap()).toList())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error removing categoriesrestaurant: $e');
      rethrow;
    }    
  }

  //add menu
  Future<void> postAddMenu(Menu menu) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['MENU_POST']!);
      Logger().i(url);
      resp = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(menu.toCreateMap())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error adding menu: $e');
      rethrow;
    }    
  }

  //delete menu
  Future<void> deleteRemoveMenu(int menuId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['REMOVE_MENU_DELETE']! + menuId.toString());
      Logger().i(url);
      resp = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error removing menu: $e');
      rethrow;
    }    
  }

  //update menu
  Future<void> putUpdateMenu(Menu menu) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['MENU_UPDATE']! + menu.id.toString());
      Logger().i(url);
      resp = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(menu.toMap())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error updating menu: $e');
      rethrow;
    }    
  }
  //get photos by restaurant id
  Future<List<UploadImages>?> getPhotosByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['PHOTO_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i("resp:" + resp.body);
      List<dynamic> photos = jsonDecode(resp.body);
      return photos.map((photo) => UploadImages.fromJson(photo)).toList();
    }catch(e){
      Logger().e('Error getting photos by restaurant id: $e');
      rethrow;
    }
  }

  //delete photo
  Future<void> deleteRemovePhoto(int photoId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['REMOVE_PHOTO_DELETE']! + photoId.toString());
      Logger().i(url);
      resp = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error removing photo: $e');
      rethrow;
    }    
  }

  //add photo
  Future<UploadImages?> postAddPhoto(int restaurantId, Uint8List photo) async {
  try {
    String token = await DataBaseProvider().getToken();
    await dotenv.load(fileName: "assets/env/.env");
    final url = Uri.parse(baseUrl + dotenv.env['PHOTO_POST']!);
    Logger().i(url);

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['restaurantId'] = restaurantId.toString()
      ..files.add(http.MultipartFile.fromBytes(
        'imageFile',
        photo,
        filename: 'photo.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    Logger().i(responseBody);
    return UploadImages.fromJson(jsonDecode(responseBody));
  } catch (e) {
    Logger().e('Error adding photo: $e');
    rethrow;
  }
  }

  //get accepted meetings by restaurant id
  Future<List<Meeting>> getAcceptedMeetingsByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['ACCEPTED_MEETING_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> acceptedMeetings = jsonDecode(resp.body);
      return acceptedMeetings.map((acceptedMeeting) => Meeting.fromJson(acceptedMeeting)).toList();
    }catch(e){
      Logger().e('Error getting accepted meetings by restaurant id: $e');
      rethrow;
    }
  }

  //get waitinglist by restaurant id
  Future<List<Meeting>> getWaitingMeetingsByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['WAITING_MEETING_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> waitingList = jsonDecode(resp.body);
      return waitingList.map((waiting) => Meeting.fromJson(waiting)).toList();
    }catch(e){
      Logger().e('Error getting waiting list by restaurant id: $e');
      rethrow;
    }
  }

  //daily reservations by restaurant id - list of int
  Future<List<int>> getDailyReservationsByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['DAILY_RESERVATIONS_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> dailyReservations = jsonDecode(resp.body);
      return dailyReservations.map((dailyReservation) => dailyReservation as int).toList();
    }catch(e){
      Logger().e('Error getting daily reservations by restaurant id: $e');
      rethrow;
    }
  }

  //hourly reservations by restaurant id - list of int
  Future<List<int>> getHourlyReservationsByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['HOURLY_RESERVATIONS_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> hourlyReservations = jsonDecode(resp.body);
      return hourlyReservations.map((hourlyReservation) => hourlyReservation as int).toList();
    }catch(e){
      Logger().e('Error getting hourly reservations by restaurant id: $e');
      rethrow;
    }
  }

  //monthly resrvaions by restaurant id - list of int
  Future<List<int>> getMonthlyReservationsByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['MONTHLY_RESERVATIONS_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> monthlyReservations = jsonDecode(resp.body);
      return monthlyReservations.map((monthlyReservation) => monthlyReservation as int).toList();
    }catch(e){
      Logger().e('Error getting monthly reservations by restaurant id: $e');
      rethrow;
    }
  }

  //orders per reservations by restaurant id - list of int
  Future<List<int>> getOrdersPerReservationsByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl + dotenv.env['ORDERS_PER_RESERVATIONS_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> ordersPerReservations = jsonDecode(resp.body);
      return ordersPerReservations.map((ordersPerReservation) => ordersPerReservation as int).toList();
    }catch(e){
      Logger().e('Error getting orders per reservations by restaurant id: $e');
      rethrow;
    }
  }

  //eventnumber by restaurant id - list of int
  Future<List<int>> getEventNumberByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['EVENT_NUMBER_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> eventNumber = jsonDecode(resp.body);
      return eventNumber.map((eventNumber) => eventNumber as int).toList();
    }catch(e){
      Logger().e('Error getting event number by restaurant id: $e');
      rethrow;
    }
  }

  //daily meetings by restaurant id - list of int
  Future<List<int>> getDailyMeetingsByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['DAILY_MEETINGS_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> dailyMeetings = jsonDecode(resp.body);
      return dailyMeetings.map((dailyMeeting) => dailyMeeting as int).toList();
    }catch(e){
      Logger().e('Error getting daily meetings by restaurant id: $e');
      rethrow;
    }
  }

  //hourly meetings by restaurant id - list of int
  Future<List<int>> getHourlyMeetingsByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['HOURLY_MEETINGS_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> hourlyMeetings = jsonDecode(resp.body);
      return hourlyMeetings.map((hourlyMeeting) => hourlyMeeting as int).toList();
    }catch(e){
      Logger().e('Error getting hourly meetings by restaurant id: $e');
      rethrow;
    }
  }

  //monthly meetings by restaurant id - list of int

  Future<List<int>> getMonthlyMeetingsByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['MONTHLY_MEETINGS_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> monthlyMeetings = jsonDecode(resp.body);
      return monthlyMeetings.map((monthlyMeeting) => monthlyMeeting as int).toList();
    }catch(e){
      Logger().e('Error getting monthly meetings by restaurant id: $e');
      rethrow;
    }
  }

  //meeting waitinglist by restaurant id
  Future<List<Meeting>> getMeetingWaitingListByRestaurantId(int restaurantId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['MEETING_WAITING_GET_BY_RES_ID']! + restaurantId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> meetingWaitingList = jsonDecode(resp.body);
      return meetingWaitingList.map((meetingWaiting) => Meeting.fromJson(meetingWaiting)).toList();
    }catch(e){
      Logger().e('Error getting meeting waiting list by restaurant id: $e');
      rethrow;
    }
  }

  //put function updating meetings
  Future<void> putUpdateMeeting(int meetingId,Meeting meeting) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['MEETING_UPDATE']!);
      Logger().i(url);
      resp = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(meeting.toMap())
      );
      Logger().i(resp.body);
    }catch(e){
      Logger().e('Error updating meeting: $e');
      rethrow;
    }    
  }

  //get restaurants with most reservations
  Future<List<Restaurant>> getRestaurantsWithMostReservations() async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['RESTAURANT_MOST_RESERVATIONS_GET']!);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> restaurants = jsonDecode(resp.body);
      return restaurants.map((restaurant) => Restaurant.fromJson(restaurant)).toList();
    }catch(e){
      Logger().e('Error getting restaurants with most reservations: $e');
      rethrow;
    }
  }

  //restaurants by last five reservations
  Future<List<Restaurant>> getRestaurantsByLastFiveReservations(int userId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['RESTAURANT_LAST_FIVE_RESERVATIONS_GET']! + userId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> restaurants = jsonDecode(resp.body);
      return restaurants.map((restaurant) => Restaurant.fromJson(restaurant)).toList();
    }catch(e){
      Logger().e('Error getting restaurants by last five reservations: $e');
      rethrow;
    }
  }

  //get most rated restaurants
  Future<List<Restaurant>> getMostRatedRestaurants() async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['MOST_RATED_RESTAURANTS_GET']!);
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> restaurants = jsonDecode(resp.body);
      return restaurants.map((restaurant) => Restaurant.fromJson(restaurant)).toList();
    }catch(e){
      Logger().e('Error getting most rated restaurants: $e');
      rethrow;
    }
  }

  //get events by favorit restaurant
  Future<List<Eventt>> getEventsByFavoritRestaurant(int userId) async {
    try{
      String token = await DataBaseProvider().getToken();
      http.Response resp;
      await dotenv.load(fileName: "assets/env/.env");
      final url = Uri.parse(baseUrl +  dotenv.env['EVENT_GET_BY_FAVORIT_RESTAURANT']! + userId.toString());
      Logger().i(url);
      resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }
      );
      Logger().i(resp.body);
      List<dynamic> events = jsonDecode(resp.body);
      return events.map((event) => Eventt.fromJson(event)).toList();
    }catch(e){
      Logger().e('Error getting events by favorit restaurant: $e');
      rethrow;
    }
  }
}