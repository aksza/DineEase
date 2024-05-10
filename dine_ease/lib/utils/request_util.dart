import 'dart:convert';
// import 'dart:html';

import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/event_post_model.dart';
import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/models/meeting_create.dart';
import 'package:dine_ease/models/register_restaurant_form.dart';
import 'package:dine_ease/models/reservation_create.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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

  Future<void> postReserveATable(ReservationCreate reservationCreate) async {
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
}