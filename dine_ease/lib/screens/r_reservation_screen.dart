import 'dart:math';
import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/order_model.dart';
import 'package:dine_ease/models/reservation_model.dart';
import 'package:dine_ease/models/reservation_new_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class RReservationScreen extends StatefulWidget {
  static const routeName = '/r_reservation';

  const RReservationScreen({super.key});

  @override
  State<RReservationScreen> createState() => _RReservationScreenState();
}

class _RReservationScreenState extends State<RReservationScreen> {

  late List<Reservation> acceptedReservations;
  late int restaurantId;
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    getAcceptedReservations();
  }

  Future<List<Reservation>?> getAcceptedReservations()async {
    DataBaseProvider dbProvider = DataBaseProvider();
    int restaurantId = await dbProvider.getUserId();

    RequestUtil requestUtil = RequestUtil();
    acceptedReservations = await requestUtil.getAcceptedReservationsByRestaurantId(restaurantId);
    setState(() {
      isLoading = false;
    });
    return acceptedReservations;
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  List<ReservationNew> _getDataSource() {
    List<ReservationNew> appointments = <ReservationNew>[];

    for (Reservation reservation in acceptedReservations) {
      
      appointments.add(ReservationNew(
        reservation: reservation,
        startTime: DateTime.parse(reservation.date),
        endTime: DateTime.parse(reservation.date).add(const Duration(hours: 2)),
        subject: reservation.id.toString(),
        color: getRandomColor(),
        isAllDay: false,
      ));
    }

    return appointments;
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SafeArea(
      child: SfCalendar(
        showDatePickerButton: true,
        allowedViews: const [
          CalendarView.day,
          CalendarView.week,
          CalendarView.month
        ],
        view: CalendarView.month,
        allowViewNavigation: true,
        firstDayOfWeek: 1,
        initialDisplayDate: DateTime.now(),
        dataSource: MeetingDataSource(_getDataSource()),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.appointment) {
            final ReservationNew appointment = details.appointments!.first;
            _showAppointmentDetails(context, appointment);
          }
        },
      ),
    );
  }

  Future<List<Order>> getOrdersByReservationId(int reservationId) async {
    RequestUtil requestUtil = RequestUtil();
    List<Order>? orders = await requestUtil.getOrdersByReservationId(reservationId);
    return orders;
  }

  void _showAppointmentDetails(
      BuildContext context, ReservationNew appointment) {
    bool showOrders = false;
    Future<List<Order>>? ordersFuture;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Table for ${appointment.reservation.partySize}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Restaurant: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(appointment.reservation.restaurantName),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Name: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(appointment.reservation.name ?? ''),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Party size: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(appointment.reservation.partySize.toString()),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Date: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(DateFormat('yyyy-MM-dd HH:mm').format(
                            DateTime.parse(appointment.reservation.date))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Phone number: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(appointment.reservation.phoneNum),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Table number: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(appointment.reservation.tableNumber.toString()),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (appointment.reservation.comment != '' &&
                        appointment.reservation.comment != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Comment: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(appointment.reservation.comment!),
                        ],
                      ),
                    const SizedBox(height: 10),
                    if (appointment.reservation.restaurantResponse != '' &&
                        appointment.reservation.restaurantResponse != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Restaurant response: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(appointment.reservation.restaurantResponse!),
                        ],
                      ),
                    const SizedBox(height: 10),
                    if (appointment.reservation.ordered != null &&
                        appointment.reservation.ordered!)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ordered: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const Text('Yes'),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showOrders = !showOrders;
                                if (showOrders) {
                                  ordersFuture = getOrdersByReservationId(appointment.reservation.id);
                                } else {
                                  ordersFuture = null;
                                }
                              });
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.restaurant_menu_outlined),
                                Text('See orders'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    if (showOrders)
                      FutureBuilder<List<Order>>(
                        future: ordersFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Text('No orders found');
                          } else {
                            return Column(
                              children: snapshot.data!
                                  .map((order) => Column(
                                        children: [
                                          Icon(Icons.restaurant_sharp),
                                          Text(order.menuName!),
                                          const Divider(),
                                        ],
                                      ))
                                  .toList(),
                            );
                          }
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  @override
  MeetingDataSource(List<ReservationNew> source) {
    appointments = source;
  }
}
