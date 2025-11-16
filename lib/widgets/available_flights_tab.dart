import 'dart:math';
import 'package:elective3project/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AvailableFlightsTab extends StatefulWidget {
  const AvailableFlightsTab({super.key});

  @override
  State<AvailableFlightsTab> createState() => _AvailableFlightsTabState();
}

class _AvailableFlightsTabState extends State<AvailableFlightsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // State for upcoming flights
  String? _selectedUpcomingDestination;
  List<Map<String, dynamic>> _upcomingFlights = [];
  bool _isUpcomingLoading = false;

  // State for past flights
  String? _selectedPastDestination;
  List<Map<String, dynamic>> _pastFlights = [];
  bool _isPastLoading = false;

  final Random _random = Random();
  final dbHelper = DatabaseHelper();

  final Map<String, List<String>> _destinations = const {
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- Upcoming Flights Logic ---
  Future<void> _loadUpcomingFlights(String destination) async {
    if (!mounted) return;
    setState(() {
      _isUpcomingLoading = true;
      _upcomingFlights = [];
      _selectedUpcomingDestination = destination;
    });

    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);

    // Generate flights starting from the current time
    _upcomingFlights = List.generate(5, (index) {
      final startHour = _random.nextInt(24 - now.hour) + now.hour; // From now until end of day
      final startMinute = _random.nextInt(60);
      final startTime = DateTime(date.year, date.month, date.day, startHour, startMinute);
      final durationMinutes = _random.nextInt(60) + 60;
      final endTime = startTime.add(Duration(minutes: durationMinutes));
      final double price = 1500 + _random.nextDouble() * 8000;
      return {'startTime': startTime, 'endTime': endTime, 'duration': durationMinutes, 'price': price};
    });

    if (mounted) setState(() => _isUpcomingLoading = false);
  }

  // --- Past Flights Logic ---
  Future<void> _loadPastFlights(String destination) async {
    if (!mounted) return;
    setState(() {
      _isPastLoading = true;
      _pastFlights = [];
      _selectedPastDestination = destination;
    });

    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);

    // Generate flights that have already departed today
    _pastFlights = List.generate(5, (index) {
      final startHour = _random.nextInt(now.hour > 0 ? now.hour : 1);
      final startMinute = _random.nextInt(60);
      final startTime = DateTime(date.year, date.month, date.day, startHour, startMinute);
      final durationMinutes = _random.nextInt(60) + 60;
      final endTime = startTime.add(Duration(minutes: durationMinutes));
      final double price = 1200 + _random.nextDouble() * 6000; // Slightly cheaper for past
      return {'startTime': startTime, 'endTime': endTime, 'duration': durationMinutes, 'price': price};
    });

    if (mounted) setState(() => _isPastLoading = false);
  }

  String _formatDuration(int totalMinutes) {
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;
    return '${hours}H ${minutes}M';
  }

  // --- UI Building ---
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming Flights'),
            Tab(text: 'Past Flights'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildUpcomingView(),
              _buildPastView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingView() {
    if (_isUpcomingLoading) return const Center(child: CircularProgressIndicator());
    if (_selectedUpcomingDestination != null) return _buildFlightList(_upcomingFlights, _selectedUpcomingDestination!, true);
    return _buildDestinationList(true);
  }

  Widget _buildPastView() {
    if (_isPastLoading) return const Center(child: CircularProgressIndicator());
    if (_selectedPastDestination != null) return _buildFlightList(_pastFlights, _selectedPastDestination!, false);
    return _buildDestinationList(false);
  }

  Widget _buildDestinationList(bool isUpcoming) {
    return ListView(
      children: _destinations.keys.map((group) {
        return ExpansionTile(
          title: Text(group, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          children: _destinations[group]!.map((destination) {
            return ListTile(
              title: Text(destination),
              onTap: () => isUpcoming ? _loadUpcomingFlights(destination) : _loadPastFlights(destination),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildFlightList(List<Map<String, dynamic>> flights, String destination, bool isUpcoming) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    if (isUpcoming) {
                      _selectedUpcomingDestination = null;
                    } else {
                      _selectedPastDestination = null;
                    }
                  });
                },
              ),
              Text('Flights to $destination', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: flights.length,
            itemBuilder: (context, index) {
              final flight = flights[index];
              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(DateFormat.jm().format(flight['startTime']), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(width: 8), Transform.rotate(angle: 0.785398, child: const Icon(Icons.airplanemode_active, color: Colors.grey, size: 20)), const SizedBox(width: 8),
                              Text(DateFormat.jm().format(flight['endTime']), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ]),
                            const SizedBox(height: 8),
                            Row(children: [
                              const Icon(Icons.flight_takeoff, color: Colors.grey, size: 20), const SizedBox(width: 4), const Text('Manila', style: TextStyle(color: Colors.grey)), const SizedBox(width: 8),
                              const Icon(Icons.flight_land, color: Colors.grey, size: 20), const SizedBox(width: 4), Text(destination, style: const TextStyle(color: Colors.grey)),
                            ]),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(_formatDuration(flight['duration']), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 8),
                          Text('PHP ${NumberFormat('#,##0.00').format(flight['price'])}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF003366))),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
