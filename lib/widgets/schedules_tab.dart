import 'dart:convert';
import 'package:elective3project/models/booking.dart';
import 'package:flutter/material.dart';

class SchedulesTab extends StatelessWidget {
  final List<Booking> bookedFlights;

  const SchedulesTab({super.key, required this.bookedFlights});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: bookedFlights.length,
      itemBuilder: (context, index) {
        final booking = bookedFlights[index];
        final departureDetails = json.decode(booking.departureFlightDetails);

        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            leading: const Icon(Icons.flight, color: Colors.blue),
            title: Text('${booking.origin} to ${booking.destination}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                'Departs: ${departureDetails['departureTime']} - Arrives: ${departureDetails['arrivalTime']}'),
            trailing: Text(booking.status,
                style: TextStyle(
                    color: _getStatusColor(booking.status),
                    fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Scheduled':
        return Colors.blue;
      case 'Confirmed':
        return Colors.green;
      case 'On Time':
        return Colors.green;
      case 'Delayed':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
