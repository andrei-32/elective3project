import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GuestDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> departureFlight;
  final Map<String, dynamic>? returnFlight;
  final String selectedBundle;
  final double bundlePrice;
  final String origin;
  final String destination;
    final DateTime departureDate;
  final DateTime? returnDate;


  const GuestDetailsScreen({
    Key? key,
    required this.departureFlight,
    this.returnFlight,
    required this.selectedBundle,
    required this.bundlePrice,
    required this.origin,
    required this.destination,
    required this.departureDate,
    this.returnDate,

  }) : super(key: key);

  @override
  _GuestDetailsScreenState createState() => _GuestDetailsScreenState();
}

class _GuestDetailsScreenState extends State<GuestDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Widget _buildFlightSummaryCard(String title, Map<String, dynamic> flight, DateTime date) {
    final departureTime = flight['startTime'] ;
    final arrivalTime = flight['endTime'];
    final price = flight['price'] as double;

    final totalPrice = price + widget.bundlePrice;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(DateFormat('MMMM d, y').format(date)),
             const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  '${DateFormat.jm().format(departureTime)} - ${DateFormat.jm().format(arrivalTime)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('PHP ${price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double totalFlightPrice = widget.departureFlight['price'];
    if (widget.returnFlight != null) {
      totalFlightPrice += widget.returnFlight!['price'];
    }
    final double totalPrice = totalFlightPrice + widget.bundlePrice;

    return Scaffold(
      appBar: AppBar(title: const Text('Guest Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Booking Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildFlightSummaryCard('Departure: ${widget.origin} to ${widget.destination}', widget.departureFlight, widget.departureDate),
                if (widget.returnFlight != null)
                  _buildFlightSummaryCard('Return: ${widget.destination} to ${widget.origin}', widget.returnFlight!, widget.returnDate!),
                const SizedBox(height: 16),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Bundle', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.selectedBundle, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Price', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      'PHP ${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Passenger Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: 'Contact Number', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your contact number' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your address' : null,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Booking Confirmed'),
                    content: const Text('Your flight has been successfully booked!'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Text('Book Now'),
        ),
      ),
    );
  }
}
