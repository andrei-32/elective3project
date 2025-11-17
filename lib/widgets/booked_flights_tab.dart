import 'package:elective3project/models/booking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookedFlightsTab extends StatelessWidget {
  final List<Booking> bookedFlights;
  final Future<void> Function() onRefresh;

  const BookedFlightsTab({
    super.key,
    required this.bookedFlights,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (bookedFlights.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'You have no booked flights yet.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Book a new flight to see it here.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: bookedFlights.length,
        itemBuilder: (context, index) {
          final booking = bookedFlights[index];
          return _buildBookingCard(context, booking);
        },
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    final departureTime = DateTime.parse(booking.departureFlight['startTime']);
    final arrivalTime = DateTime.parse(booking.departureFlight['endTime']);

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () => _showBookingDetails(context, booking),
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.origin,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.flight, color: Colors.blue),
                  Text(
                    booking.destination,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat.yMMMd().format(booking.departureDate)),
                  Text(booking.status, style: TextStyle(color: _getStatusColor(booking.status), fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimeColumn('Departs', DateFormat.jm().format(departureTime)),
                  _buildTimeColumn('Arrives', DateFormat.jm().format(arrivalTime)),
                  _buildTimeColumn('Passenger', '${booking.guestFirstName} ${booking.guestLastName}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  void _showBookingDetails(BuildContext context, Booking booking) {
    final departureTime = DateTime.parse(booking.departureFlight['startTime']);
    final arrivalTime = DateTime.parse(booking.departureFlight['endTime']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Center(child: Text('Booking Details')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Passenger', '${booking.guestFirstName} ${booking.guestLastName}'),
                _buildDetailRow('From', booking.origin),
                _buildDetailRow('To', booking.destination),
                _buildDetailRow('Departure', '${DateFormat.yMMMd().format(booking.departureDate)} at ${DateFormat.jm().format(departureTime)}'),
                _buildDetailRow('Arrival', DateFormat.jm().format(arrivalTime)),
                _buildDetailRow('Class', booking.flightClass),
                _buildDetailRow('Bundle', booking.selectedBundle),
                const Divider(height: 32.0),
                _buildDetailRow('Booking Ref', booking.bookingReference, isBold: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
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
