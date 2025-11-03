import 'package:elective3project/screens/flight_results_screen.dart';
import 'package:elective3project/widgets/passenger_counter.dart';
import 'package:flutter/material.dart';

class BookingTab extends StatefulWidget {
  final String? initialDestination;

  const BookingTab({
    super.key,
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
  DateTime _departureDate = DateTime.now();
  DateTime? _returnDate;
  int _adults = 1;
  int _children = 0;
  int _infants = 0;
  String _flightClass = 'economy';

  final Map<String, List<String>> _destinations = {
    'Luzon': [
      'Clark', 'Subic', 'Baguio', 'Basco', 'Laoag',
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

  final List<String> _tripTypes = ['one way', 'round trip', 'multi city'];
  final List<String> _flightClasses = ['economy', 'premium economy', 'business', 'first class'];

  @override
  void initState() {
    super.initState();
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
    final Map<String, String> destinationMap = {
      'Boracay': 'Kalibo',
      'Siquijor': 'Bohol',
      'Siargao': 'Siargao',
      'Palawan': 'Palawan',
      'Bohol': 'Bohol',
    };

    String finalDestination = destinationMap[destination] ?? destination;
    
    String? group;
    for (var entry in _destinations.entries) {
      if (entry.value.contains(finalDestination)) {
        group = entry.key;
        break;
      }
    }

    if (group != null) {
      setState(() {
        _selectedIslandGroup = group;
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

  Future<void> _selectDestinationDialog(BuildContext context) async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String? tempSelectedGroup;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(tempSelectedGroup == null ? 'Select Island Group' : 'Select Destination'),
              content: SizedBox(
                width: double.maxFinite,
                child: tempSelectedGroup == null
                    ? ListView(
                        shrinkWrap: true,
                        children: _destinations.keys.map((group) {
                          return ListTile(
                            title: Text(group),
                            onTap: () {
                              setState(() {
                                tempSelectedGroup = group;
                              });
                            },
                          );
                        }).toList(),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: _destinations[tempSelectedGroup!]!.map((destination) {
                          return ListTile(
                            title: Text(destination),
                            onTap: () {
                              Navigator.of(context).pop(destination);
                            },
                          );
                        }).toList(),
                      ),
              ),
              actions: [
                if (tempSelectedGroup != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        tempSelectedGroup = null;
                      });
                    },
                    child: const Text('Back'),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedDestination = result;
        for (var entry in _destinations.entries) {
          if (entry.value.contains(result)) {
            _selectedIslandGroup = entry.key;
            break;
          }
        }
      });
    }
  }

  void _searchFlights() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDestination == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a destination.')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlightResultsScreen(
            origin: 'Manila',
            destination: _selectedDestination!,
            departureDate: _departureDate,
          ),
        ),
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
                const Text('Search Your Flight', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24.0),
                DropdownButtonFormField<String>(
                  value: _tripType,
                  decoration: const InputDecoration(labelText: 'Trip Type', prefixIcon: Icon(Icons.compare_arrows), border: OutlineInputBorder()),
                  items: _tripTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  onChanged: (value) => setState(() => _tripType = value!),
                ),
                const SizedBox(height: 16.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('FROM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                          const SizedBox(height: 8),
                          InputDecorator(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.flight_takeoff),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                            ),
                            child: const Text('Manila', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectDestinationDialog(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.flight_land),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              ),
                              child: Text(
                                _selectedDestination ?? 'Select Destination',
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, isDeparture: true),
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Departure Date', prefixIcon: Icon(Icons.calendar_today), border: OutlineInputBorder()),
                          child: Text('${_departureDate.toLocal()}'.split(' ')[0]),
                        ),
                      ),
                    ),
                    if (_tripType == 'round trip') ...[
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, isDeparture: false),
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'Return Date', prefixIcon: Icon(Icons.calendar_today), border: OutlineInputBorder()),
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
                  decoration: const InputDecoration(labelText: 'Class', prefixIcon: Icon(Icons.airline_seat_recline_normal), border: OutlineInputBorder()),
                  items: _flightClasses.map((fClass) => DropdownMenuItem(value: fClass, child: Text(fClass))).toList(),
                  onChanged: (value) => setState(() => _flightClass = value!),
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: _searchFlights, child: const Text('Search Flights')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
