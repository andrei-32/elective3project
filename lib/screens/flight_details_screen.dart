import 'package:elective3project/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:elective3project/models/booking.dart';

class FlightDetailsScreen extends StatefulWidget {
  const FlightDetailsScreen({super.key});

  @override
  State<FlightDetailsScreen> createState() => _FlightDetailsScreenState();
}

class _FlightDetailsScreenState extends State<FlightDetailsScreen> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _showCancelDialog(Booking booking) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Flight'),
          content: TextField(
            controller: _reasonController,
            decoration: const InputDecoration(hintText: "Reason for cancellation"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                final db = DatabaseHelper();
                await db.updateBookingStatus(booking.id!, 'Cancelled');
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back to the previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Flight canceled')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final booking = ModalRoute.of(context)!.settings.arguments as Booking;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(booking.flight.destination, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Chip(
                      label: Text(booking.status),
                      backgroundColor: booking.status == 'Cancelled' ? Colors.red : Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text('Departure: ${booking.departureDate.toLocal().toString().split(' ')[0]} at ${booking.flight.departureTime}',
                    style: const TextStyle(fontSize: 16)),
                Text('Arrival: ${booking.departureDate.toLocal().toString().split(' ')[0]} at ${booking.flight.arrivalTime}',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16.0),
                Text('Passengers: ${booking.adults} Adults, ${booking.children} Children, ${booking.infants} Infants',
                    style: const TextStyle(fontSize: 16)),
                Text('Class: ${booking.flightClass}', style: const TextStyle(fontSize: 16)),
                Text('Trip Type: ${booking.tripType}', style: const TextStyle(fontSize: 16)),
                if (booking.returnDate != null)
                  Text('Return Date: ${booking.returnDate!.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(fontSize:.16)),
                const SizedBox(height: 32.0),
                if (booking.status != 'Cancelled')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showCancelDialog(booking),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Cancel Flight'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
