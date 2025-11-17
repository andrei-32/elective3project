import 'dart:convert';
import 'package:elective3project/database/database_helper.dart';
import 'package:elective3project/models/booking.dart';
import 'package:elective3project/models/user.dart';
import 'package:elective3project/screens/add_user_screen.dart';
import 'package:elective3project/screens/edit_profile_screen.dart';
import 'package:elective3project/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final dbHelper = DatabaseHelper();

  // Data for Dashboard
  double _totalRevenue = 0;
  int _totalBookings = 0;
  int _totalUsers = 0;

  // Data for Bookings & Users Tabs
  List<Booking> _bookings = [];
  List<User> _users = [];
  final List<String> _statuses = [
    'Scheduled', 'Confirmed', 'On Time', 'Delayed', 'Cancelled', 'Rescheduled',
    'Check-in Open', 'Check-in Closed', 'Boarding Soon', 'Boarding', 'Gate Closed'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    await _loadDashboardData();
    await _loadBookings();
    await _loadUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    final revenue = await dbHelper.getTotalRevenue();
    final bookings = await dbHelper.getTotalBookings();
    final users = await dbHelper.getTotalUsers();
    if (mounted) {
      setState(() {
        _totalRevenue = revenue;
        _totalBookings = bookings;
        _totalUsers = users;
      });
    }
  }

  Future<void> _loadUsers() async {
    final users = await dbHelper.getAllUsers();
    if (mounted) {
      setState(() {
        _users = users;
      });
    }
  }

  Future<void> _loadBookings() async {
    final bookings = await dbHelper.getAllBookings();
    if (mounted) {
      setState(() {
        _bookings = bookings;
      });
    }
  }

  Future<void> _updateStatus(Booking booking, String newStatus) async {
    await dbHelper.updateBookingStatus(booking.id!, newStatus);
    _loadBookings();
  }

  Future<void> _deleteUser(int userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await dbHelper.deleteUser(userId);
      _loadAllData(); // Refresh all data
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out from the admin panel?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlyQuest Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout, 
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.book_online), text: 'Bookings'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildBookingsTab(),
          _buildUsersTab(),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _loadAllData,
      child: GridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: [
          _buildStatCard('Total Revenue', '₱${NumberFormat('#,##0.00').format(_totalRevenue)}', Icons.attach_money, Colors.green),
          _buildStatCard('Total Bookings', _totalBookings.toString(), Icons.flight_takeoff, Colors.blue),
          _buildStatCard('Registered Users', _totalUsers.toString(), Icons.people, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsTab() {
    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final booking = _bookings[index];
          final departureDetails = json.decode(booking.departureFlightDetails);
          final departureTime = DateTime.parse(departureDetails['startTime']);

          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ref: ${booking.bookingReference}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  Text('Passenger: ${booking.guestFirstName} ${booking.guestLastName}'),
                  Text('Route: ${booking.origin} to ${booking.destination}'),
                  Text('Departure: ${DateFormat.yMMMd().format(booking.departureDate)} at ${DateFormat.jm().format(departureTime)}'),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status:'),
                      DropdownButton<String>(
                        value: booking.status,
                        items: _statuses.map((String status) => DropdownMenuItem<String>(value: status, child: Text(status))).toList(),
                        onChanged: (newStatus) => _updateStatus(booking, newStatus!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildUsersTab() {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadUsers,
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final user = _users[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: CircleAvatar(child: Text(user.id.toString())),
                title: Text('${user.firstName} ${user.lastName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('@${user.username} | ${user.email}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Edit User',
                      onPressed: () async {
                        final result = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(userId: user.id!),
                          ),
                        );
                        if (result == true) _loadAllData();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete User',
                      onPressed: () => _deleteUser(user.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const AddUserScreen()),
          );
          if (result == true) _loadAllData();
        },
        child: const Icon(Icons.add),
        tooltip: 'Add User',
      ),
    );
  }
}
