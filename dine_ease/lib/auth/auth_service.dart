import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AuthService with ChangeNotifier{
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  final RequestUtil requestUtil = RequestUtil();

  Future<bool> login(String email, String password) async {
    
    try{
      Logger().i('Logging in user with email: $email and password: $password');
      final response = await requestUtil.postLogin(email, password);
      Logger().i(response.body);
      if(response.statusCode == 200){
        final resp = response.body;
        await DataBaseProvider().setToken(resp);
        Logger().i('User logged in successfully');

        _isAuthenticated = true;
        notifyListeners();
        return true;
      }else{
        Logger().e('Failed');
        return false;
      }
    }catch(e){
      Logger().e('Error logging in user: $e');
      return false;
    }
  }

  void logout(BuildContext context) {
    DataBaseProvider().logOut(context);
    _isAuthenticated = false;
    notifyListeners();
  }
}