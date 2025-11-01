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

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Booking> _bookedFlights = [];
  int? _userId;

  final List<Map<String, String>> _bestOffers = [
    {'name': 'Siargao', 'imageUrl': 'assets/images/siargao.jpg'},
    {'name': 'Palawan', 'imageUrl': 'assets/images/palawan.jpg'},
    {'name': 'Bohol', 'imageUrl': 'assets/images/bohol.png'},
    {'name': 'Boracay', 'imageUrl': 'assets/images/boracay.jpg'},
    {'name': 'Siquijor', 'imageUrl': 'assets/images/siquijor.jpg'},
  ];

  // --- FIXED FILE EXTENSIONS ---
  final List<String> _dealImages = [
    'assets/images/sale1.png', // Corrected from .jpg to .png
    'assets/images/sale2.png', // Corrected from .jpg to .png
  ];

  // Using a getter for _homeTab to properly build the dynamic content
  Widget get _homeTab => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image without Text
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              child: Image.asset(
                'assets/images/intro.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50, color: Colors.red);
                },
              ),
            ),
            const SizedBox(height: 16),

            // Explore Our Best Offers From
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Explore Our Best Offers From',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180, // Increased height for text
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _bestOffers.length,
                itemBuilder: (context, index) {
                  final offer = _bestOffers[index];
                  return Padding(
                    padding: EdgeInsets.only(left: 16.0, right: index == _bestOffers.length - 1 ? 16.0 : 0),
                    child: SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              offer['imageUrl']!,
                              width: 200,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 50, color: Colors.red);
                              },
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            offer['name']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Best Deal for you
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Best Deal for you',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _dealImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 16.0, right: index == _dealImages.length - 1 ? 16.0 : 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        _dealImages[index],
                        width: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                           return const Icon(Icons.broken_image, size: 50, color: Colors.red);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
  final Widget _profileTab = const Center(child: Text('Profile'));

  @override
  void initState() {
    super.initState();
    // We will get the user ID after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is int) {
        _userId = args;
        _loadBookings();
      }
    });
  }

  Future<void> _loadBookings() async {
    if (_userId != null) {
      final db = DatabaseHelper();
      final bookings = await db.getBookings(_userId!);
      if (mounted) {
        setState(() {
          _bookedFlights = bookings;
        });
      }
    }
  }

  Future<void> _bookFlight(Booking booking) async {
    if (_userId != null) {
      final db = DatabaseHelper();
      await db.insertBooking(booking, _userId!);
      await _loadBookings(); // Reload bookings from the database
      if (mounted) {
        setState(() {
          _selectedIndex = 3; // Switch to the "My Bookings" tab
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      _homeTab,
      BookingTab(onBookFlight: _bookFlight),
      const SchedulesTab(),
      BookedFlightsTab(bookedFlights: _bookedFlights, onRefresh: _loadBookings),
      _profileTab,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.flight_takeoff),
            SizedBox(width: 8),
            Text('FlyQuest', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // This is important for more than 3 items
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight),
            label: 'Book Flight',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
