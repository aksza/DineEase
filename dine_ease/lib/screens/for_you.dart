import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForYou extends StatefulWidget {
  static const routeName = '/foryou';
  final String token;

  const ForYou({required this.token,super.key});

  @override
  State<ForYou> createState() => _ForYou();
}

class _ForYou extends State<ForYou> {
  late String email = '';
  late SharedPreferences prefs;

  @override
  void initState(){
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async{
    prefs = await SharedPreferences.getInstance();
    email = prefs.getString('role')!;
    setState(() {
      email = email;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(email),
      ),
    );
  }
}