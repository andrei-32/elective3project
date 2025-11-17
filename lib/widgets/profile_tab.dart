import 'dart:io';
import 'package:elective3project/database/database_helper.dart';
import 'package:elective3project/models/user.dart';
import 'package:elective3project/screens/contact_us_screen.dart';
import 'package:elective3project/screens/edit_profile_screen.dart';
import 'package:elective3project/screens/faq_screen.dart';
import 'package:elective3project/screens/login_screen.dart';
import 'package:elective3project/screens/terms_and_conditions_screen.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  final int? userId;
  final VoidCallback onMyBookingsTapped;

  const ProfileTab({
    super.key, 
    required this.userId,
    required this.onMyBookingsTapped
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (widget.userId != null) {
      final db = DatabaseHelper();
      final user = await db.getUserById(widget.userId!);
      if (mounted) {
        setState(() {
          _user = user;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void navigateToEditProfile() async {
      if (widget.userId != null) {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(userId: widget.userId!),
          ),
        );

        // If the result is true, it means changes were made, so refresh the user data.
        if (result == true) {
          _loadUserData();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User not logged in properly.')),
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionHeader(context, 'ACCOUNT'),
        _buildProfileCard(context, onTap: navigateToEditProfile),
        _buildListTile(context, icon: Icons.person_outline, title: 'Basic Information', subtitle: 'Manage your account details', onTap: navigateToEditProfile),
        _buildListTile(context, icon: Icons.flight_takeoff, title: 'My Bookings', subtitle: 'View flight status and history', onTap: widget.onMyBookingsTapped),
        const Divider(height: 32.0),
        _buildSectionHeader(context, 'INFORMATION'),
        _buildListTile(context, icon: Icons.calendar_today, title: 'Philippine Holidays', onTap: () => Navigator.pushNamed(context, '/holidays', arguments: widget.userId)),
        _buildListTile(context, icon: Icons.headset_mic_outlined, title: 'Contact Us', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsScreen()))),
        const Divider(height: 32.0),
        _buildSectionHeader(context, 'FAQ & RESOURCES'),
        _buildListTile(context, icon: Icons.description_outlined, title: 'Terms and Conditions', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen()))),
        _buildListTile(context, icon: Icons.quiz_outlined, title: 'FAQs', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FaqScreen()))),
        _buildListTile(context, icon: Icons.settings_outlined, title: 'Settings', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigate to Settings')))),
        const Divider(height: 32.0),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: <Widget>[
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
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
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
    );
  }

  Widget _buildProfileCard(BuildContext context, {required VoidCallback onTap}) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: _user?.profileImagePath != null && File(_user!.profileImagePath!).existsSync()
              ? FileImage(File(_user!.profileImagePath!))
              : null,
          child: _user?.profileImagePath == null || !File(_user!.profileImagePath!).existsSync()
              ? Icon(Icons.person, size: 32, color: Colors.grey.shade600)
              : null,
        ),
        title: Text(_user != null ? '${_user!.firstName} ${_user!.lastName}' : 'Loading...', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(_user != null ? _user!.email : '...'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
        onTap: onTap,
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String title, String? subtitle, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      onTap: onTap,
      dense: subtitle == null,
    );
  }
}
