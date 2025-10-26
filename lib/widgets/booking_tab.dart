import 'package:flutter/material.dart';
import 'package:elective3project/models/flight.dart';
import 'package:elective3project/models/booking.dart';
import 'package:elective3project/widgets/passenger_counter.dart';

class BookingTab extends StatefulWidget {
  final Function(Booking) onBookFlight;

  const BookingTab({super.key, required this.onBookFlight});

  @override
  State<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
  final _formKey = GlobalKey<FormState>();
  String _tripType = 'one way';
  String? _selectedDestination;
  DateTime? _departureDate;
  DateTime? _returnDate;
  int _adults = 1;
  int _children = 0;
  int _infants = 0;
  String _flightClass = 'economy';

  final List<String> _destinations = ['Japan', 'South Korea', 'Singapore', 'Thailand'];
  final List<String> _tripTypes = ['one way', 'round trip', 'multi city'];
  final List<String> _flightClasses = ['economy', 'premium economy', 'business', 'first class'];
  final Map<String, Map<String, String>> _flightTimes = {
    'Japan': {'departure': '10:00 AM', 'arrival': '03:00 PM'},
    'South Korea': {'departure': '12:00 PM', 'arrival': '05:00 PM'},
    'Singapore': {'departure': '02:00 PM', 'arrival': '07:00 PM'},
    'Thailand': {'departure': '04:00 PM', 'arrival': '09:00 PM'},
  };

  Future<void> _selectDate(BuildContext context, {bool isDeparture = true}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isDeparture ? _departureDate : _returnDate) ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _departureDate = picked;
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _onBookFlight() {
    if (_formKey.currentState!.validate()) {
      final flight = Flight(
        destination: _selectedDestination!,
        departureTime: _flightTimes[_selectedDestination!]!['departure']!,
        arrivalTime: _flightTimes[_selectedDestination!]!['arrival']!,
      );

      final booking = Booking(
        flight: flight,
        tripType: _tripType,
        departureDate: _departureDate!,
        returnDate: _returnDate,
        adults: _adults,
        children: _children,
        infants: _infants,
        flightClass: _flightClass,
      );
      widget.onBookFlight(booking);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Flight to ${_selectedDestination!} booked!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Book Your Flight', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24.0),
                DropdownButtonFormField<String>(
                  value: _tripType,
                  decoration: const InputDecoration(labelText: 'Trip Type', prefixIcon: Icon(Icons.compare_arrows)),
                  items: _tripTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  onChanged: (value) => setState(() => _tripType = value!),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _selectedDestination,
                  decoration: const InputDecoration(labelText: 'Destination', prefixIcon: Icon(Icons.flight_takeoff)),
                  items: _destinations.map((dest) => DropdownMenuItem(value: dest, child: Text(dest))).toList(),
                  onChanged: (value) => setState(() => _selectedDestination = value),
                  validator: (value) => value == null ? 'Please select a destination' : null,
                  hint: const Text('Select a destination'),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, isDeparture: true),
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Departure Date', prefixIcon: Icon(Icons.calendar_today)),
                          child: Text(_departureDate != null ? '${_departureDate!.toLocal()}'.split(' ')[0] : 'Select Date'),
                        ),
                      ),
                    ),
                    if (_tripType == 'round trip') ...[
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, isDeparture: false),
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'Return Date', prefixIcon: Icon(Icons.calendar_today)),
                            child: Text(_returnDate != null ? '${_returnDate!.toLocal()}'.split(' ')[0] : 'Select Date'),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24.0),
                const Text('Passengers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                PassengerCounter(label: 'Adults', count: _adults, onChanged: (count) => setState(() => _adults = count >= 1 ? count : 1)),
                PassengerCounter(label: 'Children', count: _children, onChanged: (count) => setState(() => _children = count >= 0 ? count : 0)),
                PassengerCounter(label: 'Infants', count: _infants, onChanged: (count) => setState(() => _infants = count >= 0 ? count : 0)),
                const SizedBox(height: 24.0),
                DropdownButtonFormField<String>(
                  value: _flightClass,
                  decoration: const InputDecoration(labelText: 'Class', prefixIcon: Icon(Icons.airline_seat_recline_normal)),
                  items: _flightClasses.map((fClass) => DropdownMenuItem(value: fClass, child: Text(fClass))).toList(),
                  onChanged: (value) => setState(() => _flightClass = value!),
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: _onBookFlight, child: const Text('Book Flight')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
