import 'package:dine_ease/helper/order_notifier.dart';
import 'package:dine_ease/models/order_model.dart';
import 'package:dine_ease/models/reservation_create.dart';
import 'package:dine_ease/models/restaurant_model.dart';
import 'package:dine_ease/screens/menu_screen.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationScreen extends StatefulWidget {
  static const routeName = '/reservation';
  final Restaurant? selectedRestaurant;
  DateTime? startingDate;
  DateTime? endingDate;

  ReservationScreen({Key? key, this.selectedRestaurant, this.startingDate, this.endingDate});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final RequestUtil requestUtil = RequestUtil();

  final TextEditingController partySizeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();
  List<Order> orders = [];

  late SharedPreferences prefs;
  late int userId;

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
    initDate();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId')!;
    var openings = await requestUtil.getOpeningsByRestaurantId(widget.selectedRestaurant!.id);
    setState(() {
      userId = userId;
      widget.selectedRestaurant?.openings = openings;
    });
  }

  void initDate() {
    if (widget.startingDate != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(widget.startingDate!);
    }
    if (widget.endingDate != null) {
      timeController.text = DateFormat('HH:mm').format(widget.startingDate!);
    }
  }

  Future<void> reserve() async {
    final String dateTimeString = '${dateController.text}T${timeController.text}:00.000';
    final DateTime formattedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(dateTimeString);
    try {
      ReservationCreate rescreate = ReservationCreate(
        restaurantId: widget.selectedRestaurant!.id,
        userId: userId,
        partySize: int.parse(partySizeController.text),
        date: formattedDateTime,
        phoneNum: phoneNumController.text,
        comment: commentController.text.isNotEmpty ? commentController.text : null,
      );

      if (orders.isNotEmpty) {
        rescreate.ordered = true;
      }

      Logger().i('Reservation: ${rescreate.toMap()}');
      var resid = await requestUtil.postReserveATable(rescreate);

      await Future.wait(orders.map((order) async {
        try {
          order.reservationId = resid;
          await requestUtil.postOrder(order);
        } catch (orderError) {
          Logger().e('Error posting order: ${order.toMap()} - $orderError');
        }
      }));

    } catch (e) {
      Logger().e('Error reserving table: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final DateTime now = DateTime.now();
        final DateTime selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        timeController.text = DateFormat('HH:mm').format(selectedTime);
      });
    }
  }

  double calculateTotalPrice(List<Order> orders) {
    double total = 0.0;
    for (var order in orders) {
      total += order.price!;
    }
    return total;
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
        title: Text('Reserve at ${widget.selectedRestaurant!.name}'),
      ),
      body: SafeArea(
        child: Consumer<OrderProvider>(
          builder: (context, orderProvider, child) {
            double totalPrice = calculateTotalPrice(orderProvider.orders);
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: partySizeController,
                            decoration: const InputDecoration(
                              labelText: 'Party Size',
                              hintText: 'Enter party size',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            readOnly: true,
                            controller: dateController,
                            onTap: () => _selectDate(context),
                            decoration: const InputDecoration(
                              labelText: 'Date',
                              hintText: 'Select date',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            readOnly: true,
                            controller: timeController,
                            onTap: () => _selectTime(context),
                            decoration: const InputDecoration(
                              labelText: 'Time',
                              hintText: 'Select time',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: phoneNumController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              hintText: 'Enter phone number',
                            ),
                            keyboardType: TextInputType.phone
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              labelText: 'Comment',
                              hintText: 'Enter comment',
                            ),
                          ),
                        ),
                        if (orderProvider.orders.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Your orders: $totalPrice RON',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: orderProvider.orders.length,
                          itemBuilder: (context, index) {
                            final order = orderProvider.orders[index];
                            return ListTile(
                              title: Text(
                                ' ${order.menuName!}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('  ${order.price} RON'),
                              trailing: GestureDetector(
                                onTap: () {
                                  orderProvider.removeOrder(index);
                                },
                                child: const Icon(Icons.cancel),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuScreen(
                            restaurantId: widget.selectedRestaurant!.id,
                            reservationId: 1,
                          ),
                        ),
                      );
                    },
                    child: const Text('Menu'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (partySizeController.text.isEmpty ||
                          dateController.text.isEmpty ||
                          timeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields'),
                          ),
                        );
                      } else {
                        if (int.parse(partySizeController.text) < 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Party size must be at least 1'),
                            ),
                          );
                          return;
                        } else if (DateTime.parse('${dateController.text}T${timeController.text}:00.000').isBefore(DateTime.now())) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Date must be in the future'),
                            ),
                          );
                          return;
                        } else if (phoneNumController.text.length < 10 || phoneNumController.text.length > 12 || phoneNumController.text.contains(RegExp(r'[a-zA-Z]'))) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Phone number must be between 10 and 12 characters long and no letters allowed'),
                            ),
                          );
                          return;
                        } else if (int.parse(partySizeController.text) > widget.selectedRestaurant!.maxTableCapacity) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Party size must be less than or equal to ${widget.selectedRestaurant!.maxTableCapacity}'),
                            ),
                          );
                          return;
                        }
                        setState(() {
                          orders = List<Order>.from(orderProvider.orders);
                        });
                        reserve();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Table reserved successfully!'),
                          ),
                        );
                        orderProvider.clearOrders();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Reserve'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}
