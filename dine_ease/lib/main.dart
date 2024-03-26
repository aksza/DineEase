import 'dart:io';
import 'package:dine_ease/screens/login.dart';
import 'package:dine_ease/screens/sign_up_user.dart';
import 'package:dine_ease/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Map<String, WidgetBuilder> _getRoutes() {
      return <String,WidgetBuilder>{
      '/': (context) => const SplashScreen(),
      //ontap metodus ures lesz
      '/login': (context) => LoginScreen(onTap: (){}),
      '/sign-up-user': (context) => const SignUpUserScreen(),
    };
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DineEase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      onGenerateRoute: (settings) {
        final routes = _getRoutes();
        final builder = routes[settings.name];
        return MaterialPageRoute(builder: (context) => builder!(context));
      }
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}