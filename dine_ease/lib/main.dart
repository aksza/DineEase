import 'dart:io';
import 'package:dine_ease/auth/auth_service.dart';
import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/dine_ease.dart';
import 'package:dine_ease/models/event_post_model.dart';
import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/screens/event_details_screen.dart';
import 'package:dine_ease/screens/favorits_page.dart';
import 'package:dine_ease/screens/home_page.dart';
import 'package:dine_ease/screens/login.dart';
import 'package:dine_ease/screens/meeting_screen.dart';
import 'package:dine_ease/screens/menu_screen.dart';
import 'package:dine_ease/screens/reservation_screen.dart';
import 'package:dine_ease/screens/restaurant_details_screen.dart';
import 'package:dine_ease/screens/sign_up.dart';
import 'package:dine_ease/screens/splash_screen.dart';
import 'package:dine_ease/screens/user_screen.dart';
import 'package:dine_ease/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatelessWidget {

  final token;

  const MyApp({
    @required this.token,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => DataBaseProvider()),
          ChangeNotifierProvider(create: (context) => DineEase()),
        ],
        child: 
          MaterialApp(
          title: 'DineEase',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(230, 81, 0, 1)),
            useMaterial3: true,
          ),
          initialRoute: token != null ? '/home' : '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/sign-up-user': (context) => const SignUpScreen(),
            // '/foryou' : (context) => HomePage(),
            '/user': (context) => const UserScreen(),
            '/welcome': (context) => const WelcomeScreen(),
            '/favorits': (context) => FavoritsPage(),
            '/home': (context) => HomePage(),
            '/event_details_screen': (context) => EventDetails(selectedEvent: 
              // EventPost(
              //   id: 0,
              //   eventName: '',
              //   restaurantName: '',
              //   startingDate: DateTime.now(),
              //   endingDate: DateTime.now(),
              //   restaurantId: 0,
              //   description: '',
              // )
              // Eventt(
              //   id: 0,
              //   eventName: '',
              //   restaurantName: '',
              //   startingDate: DateTime.now(),
              //   endingDate: DateTime.now(),
              //   restaurantId: 0,
              //   description: '',
              // )
              null
            ,),
            '/restaurant_details_screen': (context) => RestaurantDetails(selectedRestaurant: 
              null),
            '/reservation': (context) => ReservationScreen(selectedRestaurant: null),
            '/meeting': (context) => MeetingScreen(selectedRestaurant: null),
            '/menu_screen': (context) => MenuScreen(restaurantId: 1),
          },
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