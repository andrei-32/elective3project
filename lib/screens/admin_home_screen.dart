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

  Future<void> _changeBookingStatus(Booking booking) async {
    final currentIndex = _statuses.indexOf(booking.status);
    final nextIndex = (currentIndex + 1) % _statuses.length;
    final newStatus = _statuses[nextIndex];
    final db = DatabaseHelper();
    await db.updateBookingStatus(booking.id!, newStatus);
    _loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
                  Text(booking.flight.destination, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  Text('Status: ${booking.status}'),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () => _changeBookingStatus(booking),
                    child: const Text('Change Status'),
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
