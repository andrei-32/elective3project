import 'package:elective3project/models/booking.dart';
import 'package:elective3project/models/flight.dart';
import 'package:elective3project/widgets/destination_search_screen.dart';
import 'package:elective3project/widgets/passenger_counter.dart';
import 'package:flutter/material.dart';

class BookingTab extends StatefulWidget {
  final Function(Booking) onBookFlight;
  final String? initialDestination;

  const BookingTab({
    super.key,
    required this.onBookFlight,
    this.initialDestination,
  });

  @override
  State<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
  final _formKey = GlobalKey<FormState>();
  String _tripType = 'one way';
  String? _selectedIslandGroup;
  String? _selectedDestination;
  DateTime? _departureDate;
  DateTime? _returnDate;
  int _adults = 1;
  int _children = 0;
  int _infants = 0;
  String _flightClass = 'economy';

  final Map<String, List<String>> _destinations = {
    'Luzon': [
      'Manila', 'Clark', 'Subic', 'Baguio', 'Basco', 'Laoag',
      'Tuguegarao', 'Cauayan', 'Vigan', 'Naga', 'Legazpi',
      'Virac', 'Marinduque', 'Masbate', 'Tablas', 'San Jose',
      'Busuanga', 'El Nido', 'Cuyo', 'Palawan', 'PuertoPrincesa'
    ],
    'Visayas': [
      'Cebu', 'Bacolod', 'Iloilo', 'Kalibo', 'Caticlan',
      'Roxas', 'Tacloban', 'Ormoc', 'Bohol', 'Dumaguete',
      'Catarman', 'Biliran', 'Maasin', 'Bantayan'
    ],
    'Mindanao': [
      'Davao', 'GenSan', 'Cdo', 'Butuan', 'Surigao', 'Siargao',
      'Tandag', 'Dipolog', 'Pagadian', 'Ozamiz', 'Cotabato',
      'Zamboanga', 'Jolo', 'TawiTawi', 'Camiguin'
    ]
  };

  List<String> _currentCities = [];

  final List<String> _tripTypes = ['one way', 'round trip', 'multi city'];
  final List<String> _flightClasses = ['economy', 'premium economy', 'business', 'first class'];

  @override
  void initState() {
    super.initState();
    // Sort destinations alphabetically
    for (var key in _destinations.keys) {
      _destinations[key]!.sort();
    }
    if (widget.initialDestination != null) {
      _setInitialDestination(widget.initialDestination!);
    }
  }

  @override
  void didUpdateWidget(BookingTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDestination != null &&
        widget.initialDestination != oldWidget.initialDestination) {
      _setInitialDestination(widget.initialDestination!);
    }
  }

  void _setInitialDestination(String destination) {
    // Special mappings for popular spots to their nearest airport
    final Map<String, String> destinationMap = {
      'Boracay': 'Kalibo',
      'Siquijor': 'Bohol',
      // Direct mappings for clarity
      'Siargao': 'Siargao',
      'Palawan': 'Palawan',
      'Bohol': 'Bohol',
    };

    String finalDestination = destinationMap[destination] ?? destination;
    
    String? group;
    // Find which island group the finalDestination belongs to
    for (var entry in _destinations.entries) {
      if (entry.value.contains(finalDestination)) {
        group = entry.key;
        break;
      }
    }

    // If a group is found, update the state
    if (group != null) {
      setState(() {
        _selectedIslandGroup = group;
        _currentCities = _destinations[group]!;
        _selectedDestination = finalDestination;
      });
    }
  }


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

  Future<void> _selectDestination(BuildContext context) async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DestinationSearchScreen(destinations: _currentCities),
      ),
    );

    if (selected != null) {
      setState(() {
        _selectedDestination = selected;
      });
    }
  }

  void _onBookFlight() {
    if (_formKey.currentState!.validate()) {
      final flight = Flight(
        destination: _selectedDestination!,
        departureTime: 'TBA', // Placeholder
        arrivalTime: 'TBA', // Placeholder
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
                  value: _selectedIslandGroup,
                  decoration: const InputDecoration(labelText: 'Island Group', prefixIcon: Icon(Icons.map)),
                  items: _destinations.keys.map((group) => DropdownMenuItem(value: group, child: Text(group))).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedIslandGroup = value;
                      _currentCities = _destinations[value] ?? [];
                      _currentCities.sort(); // Ensure it's sorted
                      _selectedDestination = null; // Reset destination when group changes
                    });
                  },
                  validator: (value) => value == null ? 'Please select an island group' : null,
                  hint: const Text('Select an Island Group'),
                ),
                if (_selectedIslandGroup != null) ...[
                  const SizedBox(height: 16.0),
                  InkWell(
                    onTap: () => _selectDestination(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Destination',
                        prefixIcon: Icon(Icons.flight_takeoff),
                      ),
                      child: Text(
                        _selectedDestination ?? 'Select a destination',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
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
