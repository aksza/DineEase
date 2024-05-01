import 'dart:convert';

import 'package:dine_ease/models/register_restaurant_form.dart';
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
}