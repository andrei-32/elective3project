import 'package:elective3project/database/database_helper.dart';
import 'package:elective3project/models/user.dart';
import 'package:elective3project/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  final int? userId;
  const ProfileTab({super.key, required this.userId});

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
      final user = await db.getUser(widget.userId!);
      if (mounted) {
        setState(() {
          _user = user;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define colors from your theme to ensure consistency
    final Color primaryColor = Theme.of(context).primaryColor;

    // This function handles the navigation to the edit profile screen.
    void navigateToEditProfile() {
      if (widget.userId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(userId: widget.userId!),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User not logged in properly.')),
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Section: ACCOUNT
        _buildSectionHeader(context, 'ACCOUNT'),
        _buildProfileCard(context, onTap: navigateToEditProfile),
        _buildListTile(
          context,
          icon: Icons.person_outline,
          title: 'Basic Information',
          subtitle: 'Manage your account details',
          onTap: navigateToEditProfile,
        ),
        _buildListTile(
          context,
          icon: Icons.flight_takeoff,
          title: 'My Bookings',
          subtitle: 'View flight status and history',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Functionality to switch tabs is coming soon!')),
            );
          },
        ),
        const Divider(height: 32.0),

        // Section: INFORMATION
        _buildSectionHeader(context, 'INFORMATION'),
        _buildListTile(
          context,
          icon: Icons.calendar_today,
          title: 'Philippine Holidays',
          onTap: () {
            Navigator.pushNamed(context, '/holidays', arguments: widget.userId);
          },
        ),
        _buildListTile(
          context,
          icon: Icons.article_outlined,
          title: 'News and Events',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigate to News and Events')),
            );
          },
        ),
        _buildListTile(
          context,
          icon: Icons.headset_mic_outlined,
          title: 'Contact Us',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigate to Contact Us')),
            );
          },
        ),
        const Divider(height: 32.0),

        // Section: FAQ & RESOURCES
        _buildSectionHeader(context, 'FAQ & RESOURCES'),
        _buildListTile(
          context,
          icon: Icons.description_outlined,
          title: 'Terms and Conditions',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigate to Terms and Conditions')),
            );
          },
        ),
        _buildListTile(
          context,
          icon: Icons.quiz_outlined,
          title: 'FAQs',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigate to FAQs')),
            );
          },
        ),
        _buildListTile(
          context,
          icon: Icons.settings_outlined,
          title: 'Settings',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigate to Settings')),
            );
          },
        ),
      ],
    );
  }

  // Helper widget to build section headers
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  // Helper widget for the main profile card
  Widget _buildProfileCard(BuildContext context, {required VoidCallback onTap}) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(
            Icons.person,
            size: 32,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          _user != null ? _user!.username : 'Loading...',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_user != null ? _user!.email : '...'),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
        onTap: onTap,
      ),
    );
  }

  // Helper widget to build reusable list tiles for menu items
  Widget _buildListTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? subtitle,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      onTap: onTap,
      dense: subtitle == null,
    );
  }
}
