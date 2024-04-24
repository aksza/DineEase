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
      final response = await requestUtil.postUserLogin(email, password);
      if(response.statusCode == 200){
        await DataBaseProvider().setToken(response.body);
        Logger().i('User logged in successfully');

        _isAuthenticated = true;
        notifyListeners();
        return true;
    }else{
      return false;
    }
    }catch(e){

      return false;
    }
  }

  void logout(BuildContext context) {
    DataBaseProvider().logOut(context);
    _isAuthenticated = false;
    notifyListeners();
  }
}