
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class FlightResultsScreen extends StatefulWidget {
  final String origin;
  final String destination;
  final DateTime departureDate;

  const FlightResultsScreen({
    super.key,
    required this.origin,
    required this.destination,
    required this.departureDate,
  });

  @override
  _FlightResultsScreenState createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  late List<Map<String, dynamic>> _dates;
  List<Map<String, dynamic>> _flights = [];
  DateTime? _selectedDate;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _dates = _generateDates(widget.departureDate);
    _selectedDate = widget.departureDate;

    final initialDateInfo = _dates.firstWhere(
      (d) {
        final date = d['date'] as DateTime;
        return date.year == widget.departureDate.year &&
               date.month == widget.departureDate.month &&
               date.day == widget.departureDate.day;
      },
      orElse: () => {'price': null},
    );

    if (initialDateInfo['price'] != null) {
      _generateFlights(widget.departureDate);
    }
  }

  List<Map<String, dynamic>> _generateDates(DateTime centerDate) {
    final List<Map<String, dynamic>> dates = [];
    for (int i = -5; i <= 5; i++) {
      final date = centerDate.add(Duration(days: i));
      final bool isAvailable = _random.nextBool();
      final double? price = isAvailable ? (1500 + _random.nextInt(2500)).toDouble() : null;
      dates.add({'date': date, 'price': price});
    }
    return dates;
  }

  void _generateFlights(DateTime date) {
    setState(() {
      _selectedDate = date;
      _flights = List.generate(5, (index) {
        final int startHour = _random.nextInt(20) + 4; // 4 AM to 11 PM
        final int startMinute = _random.nextInt(60);
        final DateTime startTime = DateTime(date.year, date.month, date.day, startHour, startMinute);

        final int durationMinutes = _random.nextInt(60) + 60; // 60 to 120 minutes
        final DateTime endTime = startTime.add(Duration(minutes: durationMinutes));

        final double price = 1500 + _random.nextDouble() * 8000;

        return {
          'startTime': startTime,
          'endTime': endTime,
          'duration': durationMinutes,
          'price': price,
        };
      });
    });
  }

  String _formatDuration(int totalMinutes) {
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;
    return '${hours}H ${minutes}M';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF000080), // Dark Blue
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 30,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.flight_takeoff);
              },
            ),
            const SizedBox(width: 8),
            const Text('FLYQUEST', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Centered the header content
                children: [
                  const Text(
                    'Select your departing flight',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the row items
                    children: [
                      Text(
                        widget.origin,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.airplanemode_active, color: Colors.black87, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        widget.destination,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Calendar
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Text(
                'Dates',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                itemBuilder: (context, index) {
                  final dateInfo = _dates[index];
                  final DateTime date = dateInfo['date'];
                  final double? price = dateInfo['price'];
                  final bool isSelected = _selectedDate != null &&
                      _selectedDate!.day == date.day &&
                      _selectedDate!.month == date.month &&
                      _selectedDate!.year == date.year;

                  return GestureDetector(
                    onTap: () {
                      if (price != null) {
                        _generateFlights(date);
                      } else {
                        setState(() {
                          _selectedDate = date;
                          _flights = [];
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No flights available for this date.')),
                        );
                      }
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade100 : Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: isSelected ? Colors.blue.shade800 : Colors.grey.shade300,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('MMM d').format(date),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.blue.shade900 : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            price != null ? '₱${NumberFormat('#,##0').format(price)}' : 'N/A',
                            style: TextStyle(
                              fontSize: 12,
                              color: price != null ? Colors.green.shade800 : Colors.red.shade700,
                              fontWeight: price != null ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Flights List
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Flights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            Expanded(
              child: _flights.isEmpty
                  ? Center(
                      child: Text(
                        _selectedDate == null
                            ? 'Please select a date to see available flights.'
                            : 'No flights available for this date.',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: _flights.length,
                      itemBuilder: (context, index) {
                        final flight = _flights[index];
                        return Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Top Row: Time and Duration
                                      Row(
                                        children: [
                                          Text(
                                            DateFormat.jm().format(flight['startTime']),
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          const SizedBox(width: 8),
                                          Transform.rotate(
                                            angle: 0.785398, // 45 degrees
                                            child: const Icon(Icons.airplanemode_active, color: Colors.grey, size: 20),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            DateFormat.jm().format(flight['endTime']),
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Bottom Row: Origin and Destination
                                      Row(
                                        children: [
                                          const Icon(Icons.flight_takeoff, color: Colors.grey, size: 20),
                                          const SizedBox(width: 4),
                                          Text(widget.origin, style: const TextStyle(color: Colors.grey)),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.flight_land, color: Colors.grey, size: 20),
                                          const SizedBox(width: 4),
                                          Text(widget.destination, style: const TextStyle(color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Right Side: Duration and Fare
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _formatDuration(flight['duration']),
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'PHP ${NumberFormat('#,##0.00').format(flight['price'])}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF003366)),
                                    ),
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
        ),
      ),
    );
  }
}
