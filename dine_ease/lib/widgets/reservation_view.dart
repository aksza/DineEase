import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dine_ease/models/reservation_model.dart';

class ReservationView extends StatelessWidget {
  final Reservation reservation;

  ReservationView({required this.reservation});

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(reservation.date);
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(parsedDate);

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
              reservation.restaurantName,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Party Size: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${reservation.partySize}'),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Date: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(formattedDate),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Phone Number: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(reservation.phoneNum),
              ],
            ),
            const SizedBox(height: 8.0),
            if (reservation.comment != null && reservation.comment!.isNotEmpty) ...[
              const Text(
                'Comment:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(reservation.comment!),
              const SizedBox(height: 8.0),
            ],
            if (reservation.restaurantResponse != null && reservation.restaurantResponse!.isNotEmpty) ...[
              const Text(
                'Restaurant Response:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(reservation.restaurantResponse!),
              const SizedBox(height: 8.0),
            ],
            if (reservation.accepted != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Accepted: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    reservation.accepted! ? Icons.check_circle : Icons.cancel,
                    color: reservation.accepted! ? Colors.green : Colors.red,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}