import 'package:dine_ease/models/meeting_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RMWaitingView extends StatefulWidget {
  Meeting meeting;
  final VoidCallback refreshWaitingList;

  RMWaitingView({Key? key, required this.meeting,required this.refreshWaitingList}) : super(key: key);

  @override
  State<RMWaitingView> createState() => _RMWaitingViewState();
}

class _RMWaitingViewState extends State<RMWaitingView> {
  RequestUtil _request = RequestUtil();

  @override
  void initState() {
    super.initState();
  }
  
  Future<void> respondToMeeting(bool accepted) async {
    int? tableNumber;
    String? comment;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if(accepted)
              TextField(
                onChanged: (value) {
                  comment = value;
                },
                decoration: const InputDecoration(labelText: 'Comment (optional)'),
              ),
              if(!accepted)
              const Center(
                child: Text('Are you sure you want to reject this meeting?'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _sendResponse(accepted, tableNumber, comment);
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _sendResponse(bool accepted, int? tableNumber, String? comment) async {
    var res = widget.meeting;
    res.accepted = accepted;
    res.restaurantResponse = comment;

    await _request.putUpdateMeeting(widget.meeting.id, res);

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
                          'For ${widget.meeting.eventName} ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),                       
                        const SizedBox(height: 5),
                        Text(
                          'with ${widget.meeting.guestSize} people',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          'Meeting at ${DateFormat('HH:mm dd/MM/yyyy').format(DateTime.parse(widget.meeting.meetingDate))}',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Event at ${DateFormat('HH:mm dd/MM/yyyy').format(DateTime.parse(widget.meeting.eventDate))}',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Text(
                              'Phone number: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${widget.meeting.phoneNum}',
                            ),
                          ],
                        ),
                        if (widget.meeting.comment != '')
                          Row(
                            children: [
                              const Text(
                                'Comment: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${widget.meeting.comment}',
                              ),
                            ],
                          ),
                      ]
                    ),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end, 
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            respondToMeeting(true);
                          },
                          child: const Text('Accept'),
                        ),
                        const SizedBox(height: 10), 
                        ElevatedButton(
                          onPressed: () {
                            respondToMeeting(false);
                          },
                          child: const Text('Reject'),
                        ),
                      ],
                    ),

                  ]
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}