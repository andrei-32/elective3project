import 'package:elective3project/screens/guest_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewFlightScreen extends StatelessWidget {
  final Map<String, dynamic> departureFlight;
  final Map<String, dynamic>? returnFlight;
  final String selectedBundle;
  final double bundlePrice;
  final String origin;
  final String destination;
  final String tripType;
  final DateTime departureDate;
  final DateTime? returnDate;

  const ReviewFlightScreen({
    Key? key,
    required this.departureFlight,
    this.returnFlight,
    required this.selectedBundle,
    required this.bundlePrice,
    required this.origin,
    required this.destination,
    required this.tripType,
    required this.departureDate,
    this.returnDate,
  }) : super(key: key);

  Widget _buildFlightCard(BuildContext context, String title, Map<String, dynamic> flight, DateTime date, String flightOrigin, String flightDestination) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMMM d, y').format(date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(flightOrigin, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Icon(Icons.flight, color: Colors.blue),
                Text(flightDestination, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat.jm().format(flight['startTime']), style: TextStyle(color: Colors.grey[600])),
                Text(DateFormat.jm().format(flight['endTime']), style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const Divider(height: 24),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    const Text('Flight Price:'),
                    Text('PHP ${flight['price'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBundleCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bundle for all flights', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectedBundle, style: const TextStyle(fontSize: 16)),
                if (bundlePrice > 0)
                  Text('+PHP ${bundlePrice.toStringAsFixed(0)}/guest', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                if (bundlePrice == 0)
                  const Text('Included', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalFlightPrice = departureFlight['price'];
    if (returnFlight != null) {
      totalFlightPrice += returnFlight!['price'];
    }
    final double totalPrice = totalFlightPrice + bundlePrice;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Your Flight'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFlightCard(context, 'Your departing flight', departureFlight, departureDate, origin, destination),
            if (returnFlight != null)
              _buildFlightCard(context, 'Your returning flight', returnFlight!, returnDate!, destination, origin),
            const SizedBox(height: 16),
            _buildBundleCard(context),
             const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Price', style: Theme.of(context).textTheme.headlineSmall),
                    Text('PHP ${totalPrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuestDetailsScreen(
                        departureFlight: departureFlight,
                        returnFlight: returnFlight,
                        selectedBundle: selectedBundle,
                        bundlePrice: bundlePrice,
                        origin: origin,
                        destination: destination,
                        departureDate: departureDate,
                        returnDate: returnDate,
                        tripType: tripType,
                      ),
                    ),
                  );
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
