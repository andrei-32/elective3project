import 'package:elective3project/database/database_helper.dart';
import 'package:elective3project/widgets/summary_flights_tab.dart';
import 'package:flutter/material.dart';
import 'package:elective3project/widgets/booking_tab.dart';
import 'package:elective3project/widgets/schedules_tab.dart';
import 'package:elective3project/widgets/booked_flights_tab.dart';
import 'package:elective3project/models/booking.dart';
import 'package:elective3project/widgets/profile_tab.dart'; // Import the new ProfileTab

// This is the StatefulWidget declaration.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// This is the State class where all the logic resides.
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Booking> _bookedFlights = [];
  int? _userId; // This will store the logged-in user's ID.
  String? _initialDestination; // To hold the destination from the home screen

  final List<Map<String, String>> _bestOffers = [
    {'name': 'Siargao', 'imageUrl': 'assets/images/siargao.jpg'},
    {'name': 'Palawan', 'imageUrl': 'assets/images/palawan.jpg'},
    {'name': 'Bohol', 'imageUrl': 'assets/images/bohol.png'},
    {'name': 'Boracay', 'imageUrl': 'assets/images/boracay.jpg'},
    {'name': 'Siquijor', 'imageUrl': 'assets/images/siquijor.jpg'},
  ];

  final List<String> _dealImages = [
    'assets/images/sale1.png',
    'assets/images/sale2.png',
  ];

  // Navigate to the booking tab with a pre-selected destination
  void _navigateToBooking(String destination) {
    setState(() {
      _initialDestination = destination;
      _selectedIndex = 1; // Index of the BookingTab
    });
  }

  // Callback to switch tabs from another tab
  void _switchTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

<<<<<<< HEAD
  // This is the home tab UI, wrapped in a getter for cleanliness.
  Widget get _homeTab => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
          child: Image.asset(
            'assets/images/intro.jpg',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Explore Our Best Offers From',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _bestOffers.length,
            itemBuilder: (context, index) {
              final offer = _bestOffers[index];
              return Padding(
                padding: EdgeInsets.only(left: 16.0, right: index == _bestOffers.length - 1 ? 16.0 : 0),
                child: SizedBox(
                  width: 200,
                  child: GestureDetector(
                    onTap: () => _navigateToBooking(offer['name']!),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            offer['imageUrl']!,
                            width: 200,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Text(
                            offer['name']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              shadows: [Shadow(blurRadius: 10.0, color: Colors.black)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
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
                    height: 150,
                    fit: BoxFit.cover,
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
=======
  final Widget _profileTab = const Center(child: Text('Profile2'));
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    // This ensures we get the arguments (like userId) after the first frame is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if arguments were passed to this screen (e.g., from login).
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is int) {
        if (mounted) {
          setState(() {
            _userId = args;
            _loadBookings(); // Load bookings for this user.
          });
        }
      }
    });
=======
    // TODO: This should be replaced by a proper user session/login system
    // For now, we hardcode the user ID to 1 to match the one used in payment_screen.
    _userId = 1; 
    _loadBookings(); // Load bookings for the default user
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
  }

  // Fetches bookings from the database using the user ID.
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

  // Handles tapping on the bottom navigation bar items.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _initialDestination = null; // Reset destination when manually changing tabs
    });
    // If the 'My Bookings' tab is selected (index 3), refresh the bookings list.
    if (index == 3) {
      _loadBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    // Define your widget options list directly inside the build method.
    // This ensures they receive the updated `_userId`.
    final List<Widget> _widgetOptions = <Widget>[
=======
    final List<Widget> widgetOptions = <Widget>[
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
      _homeTab,
      // *** CHANGE: Pass userId to BookingTab ***
      BookingTab(initialDestination: _initialDestination, userId: _userId),
      const SchedulesTab(),
      BookedFlightsTab(bookedFlights: _bookedFlights, onRefresh: _loadBookings),
<<<<<<< HEAD
      // *** CHANGE: Pass userId to ProfileTab ***
      ProfileTab(userId: _userId),
=======
      SummaryFlightsTab(bookedFlights: _bookedFlights, onRefresh: _loadBookings), //added new tab for summary of flights - Nov. 12, 2025
      _profileTab,
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(_selectedIndex),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.png'),
        ),
        automaticallyImplyLeading: false, // Prevents a back button from appearing
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.flight), label: 'Book Flight'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedules'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'My Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Summary Flights'), //added new buttons for summary of flights - Nov. 12, 2025
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Helper method to get the correct AppBar title for each tab.
  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'FLYQUEST';
      case 1:
        return 'BOOK A FLIGHT';
      case 2:
        return 'FLIGHT SCHEDULES';
      case 3:
        return 'MY BOOKINGS';
      case 4:
        return 'PROFILE & SETTINGS';
      default:
        return 'FLYQUEST';
    }
  }
}
