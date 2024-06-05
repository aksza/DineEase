import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/reservation_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/r_waiting_view.dart';
import 'package:flutter/material.dart';

class RWaitingListScreen extends StatefulWidget {

  static const routeName = '/r_waitinglist';

  const RWaitingListScreen({super.key});

  @override
  State<RWaitingListScreen> createState() => _RWaitingListScreenState();
}

class _RWaitingListScreenState extends State<RWaitingListScreen> {
  final RequestUtil _requestUtil = RequestUtil();
  late List<Reservation> waitingList = [];
  bool isLoading = true;
  late int restaurantId = 0;

  @override
  void initState() {
    fetchWaitingList();
    super.initState();
  }

  void refreshWaitingList() {
  setState(() {
    isLoading = true;
  });
  fetchWaitingList();
}

  //listazas fuggveny
  void fetchWaitingList() async {
    var resid = await DataBaseProvider().getUserId();

    setState(() {
      restaurantId = resid;
    });
    try {
      List<Reservation> response = await _requestUtil.getWaitingListByRestaurantId(resid);
      
      setState(() {
        waitingList = response;
        isLoading = false;
      });
    } catch (error) {
      rethrow;
    }
  }


  @override
  Widget build(BuildContext context) {
    //ha betolt a lista akkor a waitinglistet listazza ki
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: waitingList.length,
              itemBuilder: (context, index) {
                return RWaitingView(
                  reservation: waitingList[index],
                  refreshWaitingList: refreshWaitingList,
                );
              },
            ),
    );
  }
}