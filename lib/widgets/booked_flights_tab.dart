import 'package:flutter/material.dart';
import 'package:elective3project/models/booking.dart';

class BookedFlightsTab extends StatelessWidget {
  final List<Booking> bookedFlights;
  final Function() onRefresh;

  const BookedFlightsTab({super.key, required this.bookedFlights, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (bookedFlights.isEmpty) {
      return const Center(
        child: Text('You have no booked flights yet.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: bookedFlights.length,
      itemBuilder: (context, index) {
        final booking = bookedFlights[index];
        final flight = booking.flight;
        return GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(context, '/flight_details', arguments: booking);
            onRefresh();
          },
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(flight.destination, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Chip(
                        label: Text(booking.status),
                        backgroundColor: booking.status == 'Cancelled' ? Colors.red : Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text('${booking.tripType} - ${booking.flightClass}'),
                  const SizedBox(height: 8.0),
                  Text('Departure: ${booking.departureDate.toLocal().toString().split(' ')[0]} at ${flight.departureTime}'),
                  if (booking.returnDate != null)
                    Text('Return: ${booking.returnDate!.toLocal().toString().split(' ')[0]}'),
                  const SizedBox(height: 8.0),
                  Text('Passengers: ${booking.adults} Adults, ${booking.children} Children, ${booking.infants} Infants'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
