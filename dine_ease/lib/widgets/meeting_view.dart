import 'package:dine_ease/models/meeting_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeetingView extends StatelessWidget {
  final Meeting meeting;

  MeetingView({required this.meeting});

  @override
  Widget build(BuildContext context) {
    DateTime parsedEventDate = DateTime.parse(meeting.eventDate);
    DateTime parsedMeetingDate = DateTime.parse(meeting.meetingDate);
    String formattedEventDate = DateFormat('yyyy-MM-dd HH:mm').format(parsedEventDate);
    String formattedMeetingDate = DateFormat('yyyy-MM-dd HH:mm').format(parsedMeetingDate);

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meeting.eventName,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Restaurant: ${meeting.restaurantName}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Event Date: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(formattedEventDate),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Meeting Date: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(formattedMeetingDate),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Guest Size: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${meeting.guestSize}'),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Phone: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(meeting.phoneNum),
              ],
            ),
            if (meeting.comment != null && meeting.comment!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Comment: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(meeting.comment!),
                  ),
                ],
              ),
            ],
            if (meeting.accepted != null) ...[
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Status: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(meeting.accepted! ? 'Accepted' : 'Rejected'),
                ],
              ),
            ],
            if (meeting.restaurantResponse != null && meeting.restaurantResponse!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Response: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(meeting.restaurantResponse!),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
