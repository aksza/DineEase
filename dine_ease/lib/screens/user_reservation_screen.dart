import 'package:dine_ease/models/reservation_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/reservation_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserReservationScreen extends StatefulWidget {
  static const routename = '/user-reservation';
  final bool isreservation;

  const UserReservationScreen({super.key, required this.isreservation});

  @override
  State<UserReservationScreen> createState() => _UserReservationScreenState();
}

class _UserReservationScreenState extends State<UserReservationScreen> {

  final RequestUtil requestUtil = RequestUtil();

  late int userId;
  late SharedPreferences prefs;
  bool isLoading = true;
  List<Reservation> reservations = [];


  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId')!;
    fetchReservations();
  }

  //fetching reservations by user id
  Future<void> fetchReservations() async {
      try {
        if(widget.isreservation == true){
          var reservationData = await requestUtil.getReservationsByUserId(userId);
          setState(() {
            reservations = reservationData;
            isLoading = false;
          });
        }
        else{
          var reservationData = await requestUtil.getWaitingsByUserId(userId);
          setState(() {
            reservations = reservationData;
            isLoading = false;
          });
        }
      } catch (e) {
        Logger().e('Error fetching reservations: $e');
        setState(() {
          isLoading = false;
        });
      }
    }


    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //title is reservation or waiting
        title: Text(widget.isreservation ? 'Reservations' : 'Waiting List'),
      ),
       body: isLoading
          ? Center(child: CircularProgressIndicator())
          : reservations.isEmpty
              ? Center(child: Text('You do not have accepted reservations yet'))
              : ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = reservations[index];
                    return ReservationView(reservation: reservation);
                  },
                ),
    );
  }
}