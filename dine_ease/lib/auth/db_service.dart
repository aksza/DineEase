import 'package:dine_ease/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataBaseProvider extends ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _token = '';
  String get token => _token;

  int _userId = 0;
  int get userId => _userId;

  String _email = '';
  String get email => _email;

  String _role = '';
  String get role => _role;

  Future<void> setToken(String token) async {
    Logger().i('Setting token: $token');
    final SharedPreferences prefs = await _prefs;
    prefs.setString('token', token);
    _token = token;

    Map<String,dynamic> decodedToken = JwtDecoder.decode(token);

    await dotenv.load(fileName: "assets/env/.env");
    const String e =  "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress";
    const String r = "http://schemas.microsoft.com/ws/2008/06/identity/claims/role";
    const String i = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier";
    
    _email = decodedToken[e];
    prefs.setString('email', _email);
    _role = decodedToken[r];
    prefs.setString('role', _role);
    var uid = decodedToken[i];
    Logger().i('uid: ${uid.runtimeType}');

    _userId = int.parse(uid);
    prefs.setInt('userId', _userId.toInt());
    //kilogoljuk a uid tipusat
    notifyListeners();
  }

  Future<dynamic> getToken() async {
    final SharedPreferences prefs = await _prefs;
    _token = prefs.getString('token') ?? '';
    notifyListeners();
    return _token;
  }

  Future<String> getEmail() async {
    final SharedPreferences prefs = await _prefs;
    _email = prefs.getString('email') ?? '';
    notifyListeners();
    return _email;
  }

  Future<String> getRole() async {
    final SharedPreferences prefs = await _prefs;
    _role = prefs.getString('role') ?? '';
    notifyListeners();
    return _role;
  }

  Future<int> getUserId() async {
    final SharedPreferences prefs = await _prefs;
    _userId = prefs.getInt('userId') ?? 0;
    notifyListeners();
    return _userId;
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