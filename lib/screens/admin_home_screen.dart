import 'package:elective3project/database/database_helper.dart';
import 'package:elective3project/models/booking.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Booking> _bookings = [];
  final List<String> _statuses = [
    'Scheduled', 'Confirmed', 'On Time', 'Delayed', 'Cancelled', 'Rescheduled',
    'Check-in Open', 'Check-in Closed', 'Boarding Soon', 'Boarding', 'Gate Closed'
  ];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final db = DatabaseHelper();
    final bookings = await db.getAllBookings();
    setState(() {
      _bookings = bookings;
    });
  }

  Future<void> _updateStatus(Booking booking, String newStatus) async {
    final db = DatabaseHelper();
    await db.updateBookingStatus(booking.id!, newStatus);
    _loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.flight_takeoff),
            SizedBox(width: 8),
            Text('FlyQuest Admin', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final booking = _bookings[index];
          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booking ID: ${booking.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  Text('User ID: ${booking.toMap(0)['userId']}'), // A bit of a hack to get userId
                  Text('Destination: ${booking.flight.destination}'),
                  Text('Departure: ${booking.departureDate.toLocal().toString().split(' ')[0]} at ${booking.flight.departureTime}'),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status:'),
                      DropdownButton<String>(
                        value: booking.status,
                        items: _statuses.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (String? newStatus) {
                          if (newStatus != null) {
                            _updateStatus(booking, newStatus);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}