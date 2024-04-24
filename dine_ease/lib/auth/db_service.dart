import 'package:dine_ease/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataBaseProvider extends ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _token = '';
  String get token => _token;

  Future<void> setToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('token', token);
    _token = token;
    notifyListeners();
  }

  Future<void> getToken() async {
    final SharedPreferences prefs = await _prefs;
    _token = prefs.getString('token') ?? '';
    notifyListeners();
  }

  Future<void> removeToken() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove('token');
    _token = '';
    notifyListeners();
  }

  void logOut(BuildContext context) {
    removeToken();
    Navigator.of(context).pushNamed(WelcomeScreen.routeName);
  }


}