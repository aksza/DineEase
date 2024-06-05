import 'package:dine_ease/models/order_model.dart';
import 'package:dine_ease/models/reservation_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RWaitingView extends StatefulWidget {
  Reservation reservation;
  final VoidCallback refreshWaitingList;

  RWaitingView({Key? key, required this.reservation,required this.refreshWaitingList}) : super(key: key);

  @override
  State<RWaitingView> createState() => _RWaitingViewState();
}

class _RWaitingViewState extends State<RWaitingView> {
  RequestUtil _request = RequestUtil();
  late Map<String, _OrderSummary> _orderSummaries;
  late Map<String, List<String>> _menuComments;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _orderSummaries = {};
    _menuComments = {};
    getOrders(widget.reservation.id);
  }

  Future<void> getOrders(int reservationId) async {
    final response = await _request.getOrdersByReservationId(reservationId);

    final orderSummaries = <String, _OrderSummary>{};
    final menuComments = <String, List<String>>{};

    for (var order in response) {
      if (orderSummaries.containsKey(order.menuName)) {
        orderSummaries[order.menuName]!.count++;
      } else {
        orderSummaries[order.menuName!] = _OrderSummary(order.menuName!, 1);
      }
      if (order.comment != null) {
        if (menuComments.containsKey(order.menuName)) {
          menuComments[order.menuName]!.add(order.comment!);
        } else {
          menuComments[order.menuName!] = [order.comment!];
        }
      }
    }

    setState(() {
      _orderSummaries = orderSummaries;
      _menuComments = menuComments;
    });
  }

  // Respond to reservation with request util
Future<void> respondToReservation(bool accepted) async {
  int? tableNumber;
  String? comment;

  // Show alert dialog to get table number and comment
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Table Number'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if(accepted)
            TextField(
              onChanged: (value) {
                tableNumber = int.tryParse(value);
              },
              decoration: InputDecoration(labelText: 'Table number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              onChanged: (value) {
                comment = value;
              },
              decoration: InputDecoration(labelText: 'Comment (optional)'),
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _sendResponse(accepted, tableNumber, comment);
            },
            child: Text('Send'),
          ),
        ],
      );
    },
  );
}

void _sendResponse(bool accepted, int? tableNumber, String? comment) async {
  var res = widget.reservation;
  res.accepted = accepted;
  res.tableNumber = tableNumber ?? 0; 
  res.restaurantResponse = comment;

  await _request.putUpdateReservation(widget.reservation.id, res);

  widget.refreshWaitingList();
}

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.reservation.name!} - table for ${widget.reservation.partySize}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'at ${DateFormat('HH:mm dd/MM/yyyy').format(DateTime.parse(widget.reservation.date))}',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Phone number: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${widget.reservation.phoneNum}',
                            ),
                          ],
                        ),
                        if (widget.reservation.comment != '')
                          Row(
                            children: [
                              Text(
                                'Comment: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${widget.reservation.comment}',
                              ),
                            ],
                          ),
                      ]
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end, 
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            respondToReservation(true);
                          },
                          child: Text('Accept'),
                        ),
                        SizedBox(height: 10), 
                        ElevatedButton(
                          onPressed: () {
                            respondToReservation(false);
                          },
                          child: Text('Reject'),
                        ),
                      ],
                    ),

                  ]
                ),
                
                
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Ordered menu: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.reservation.ordered! ? 'Yes' : 'No',
                    ),
                    if (widget.reservation.ordered == true)
                      IconButton(
                        icon: Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                        ),
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var entry in _orderSummaries.entries)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        Text(
                          '${entry.key} (x${entry.value.count})',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_menuComments.containsKey(entry.key))
                          for (var comment in _menuComments[entry.key]!)
                            Text(
                              '- $comment',
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderSummary {
  final String menuName;
  int count;

  _OrderSummary(this.menuName, this.count);
}
