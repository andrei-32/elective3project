import 'package:flutter/material.dart';
import 'package:elective3project/widgets/booking_tab.dart';
import 'package:elective3project/widgets/schedules_tab.dart';
import 'package:elective3project/widgets/booked_flights_tab.dart';
import 'package:elective3project/models/booking.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Booking> _bookedFlights = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _bookFlight(Booking booking) {
    setState(() {
      _bookedFlights.add(booking);
    });
    _tabController.animateTo(2); // Switch to the "My Bookings" tab
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Booking'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Book Flight', icon: Icon(Icons.flight)),
            Tab(text: 'Schedules', icon: Icon(Icons.schedule)),
            Tab(text: 'My Bookings', icon: Icon(Icons.bookmark)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BookingTab(onBookFlight: _bookFlight),
          const SchedulesTab(),
          BookedFlightsTab(bookedFlights: _bookedFlights),
        ],
      ),
    );
  }
}
