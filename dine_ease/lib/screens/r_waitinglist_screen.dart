import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/meeting_model.dart';
import 'package:dine_ease/models/reservation_model.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/r_m_waiting.dart';
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
  late List<Meeting> mwaitingList = [];
  bool isLoading = true;
  late int restaurantId = 0;
  late bool isForEvent;

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

    //get restaurant by id
    Restaurant res = await _requestUtil.getRestaurantById(resid);

    setState(() {
      restaurantId = resid;
      isForEvent = res.forEvent;
    });
    if(!isForEvent){
      try {
        List<Reservation> response = await _requestUtil.getWaitingListByRestaurantId(resid);
        
        setState(() {
          waitingList = response;
          isLoading = false;
        });
      } catch (error) {
        rethrow;
    }
    }else{
      try {
      List<Meeting> response = await _requestUtil.getMeetingWaitingListByRestaurantId(resid);
      
      setState(() {
        mwaitingList = response;
        isLoading = false;
      });
    } catch (error) {
      rethrow;
    }
    }
  }


 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : !isForEvent 
            ? (waitingList.isEmpty
                ? const Center(
                    child: Text('The waiting list is empty'),
                  )
                : ListView.builder(
                    itemCount: waitingList.length,
                    itemBuilder: (context, index) {
                      return RWaitingView(
                        reservation: waitingList[index],
                        refreshWaitingList: refreshWaitingList,
                      );
                    },
                  )
              )
            : (mwaitingList.isEmpty
                ? const Center(
                    child: Text('The waiting list is empty'),
                  )
                : ListView.builder(
                    itemCount: mwaitingList.length,
                    itemBuilder: (context, index) {
                      return RMWaitingView(
                        meeting: mwaitingList[index],
                        refreshWaitingList: refreshWaitingList,
                      );
                    },
                  )
              ),
  );
}

}