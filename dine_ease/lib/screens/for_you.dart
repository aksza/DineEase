import 'package:dine_ease/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForYou extends StatefulWidget {
  static const routeName = '/foryou';
  // final String token;

  const ForYou({super.key});

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
    email = prefs.getString('email')!;
    setState(() {
      email = email;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(),
      body: Center(
        child: Text(email),
      ),
    );
  }
}