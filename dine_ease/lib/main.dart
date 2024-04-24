import 'dart:io';
import 'package:dine_ease/auth/auth_service.dart';
import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/screens/for_you.dart';
import 'package:dine_ease/screens/login.dart';
import 'package:dine_ease/screens/sign_up.dart';
import 'package:dine_ease/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      '/login': (context) => const LoginScreen(),
      '/sign-up-user': (context) => const SignUpScreen(),
      '/foryou' : (context) => ForYou(),
    };
  }
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => DataBaseProvider())
        ],
        child: 
          MaterialApp(
          title: 'DineEase',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(230, 81, 0, 1)),
            useMaterial3: true,
          ),
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          onGenerateRoute: (settings) {
            final routes = _getRoutes();
            final builder = routes[settings.name];
            return MaterialPageRoute(builder: (context) => builder!(context));
          }
        )
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