import 'package:elective3project/database/database_helper.dart';
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
  List<Booking> _bookedFlights = [];
  int? _userId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // We will get the user ID after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userId = ModalRoute.of(context)!.settings.arguments as int?;
      _loadBookings();
    });
  }

  Future<void> _loadBookings() async {
    if (_userId != null) {
      final db = DatabaseHelper();
      final bookings = await db.getBookings(_userId!);
      setState(() {
        _bookedFlights = bookings;
      });
    }
  }

  Future<void> _bookFlight(Booking booking) async {
    if (_userId != null) {
      final db = DatabaseHelper();
      await db.insertBooking(booking, _userId!);
      _loadBookings(); // Reload bookings from the database
      _tabController.animateTo(2); // Switch to the "My Bookings" tab
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          BookedFlightsTab(bookedFlights: _bookedFlights, onRefresh: _loadBookings),
        ],
      ),
    );
  }
}
