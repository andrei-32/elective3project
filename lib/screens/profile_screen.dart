import 'package:flutter/material.dart';
import 'my_calendar_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define colors from your theme to ensure consistency
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color onSecondaryColor = Theme.of(context).colorScheme.onSecondary;
    final Color goldColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section: ACCOUNT
          _buildSectionHeader(context, 'ACCOUNT'),
          _buildProfileCard(context),
          _buildListTile(
            context,
            icon: Icons.person_outline,
            title: 'Basic Information',
            subtitle: 'Manage your account details',
            onTap: () {
              // TODO: Navigate to a dedicated screen for account management
            },
          ),
          _buildListTile(
            context,
            icon: Icons.flight_takeoff,
            title: 'My Bookings',
            subtitle: 'View flight status and history',
            onTap: () {
              // TODO: Navigate to a screen showing the user's bookings
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
              Navigator.pushNamed(context, '/holidays');
            },
          ),
          _buildListTile(
            context,
            icon: Icons.article_outlined,
            title: 'News and Events',
            onTap: () {
              // TODO: Navigate to a news/events screen
            },
          ),
          _buildListTile(
            context,
            icon: Icons.headset_mic_outlined,
            title: 'Contact Us',
            onTap: () {
              // TODO: Navigate to a contact information screen
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
              // TODO: Show terms and conditions
            },
          ),
          _buildListTile(
            context,
            icon: Icons.quiz_outlined,
            title: 'FAQs',
            onTap: () {
              // TODO: Navigate to an FAQ screen
            },
          ),
          _buildListTile(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              // TODO: Navigate to an app settings screen
            },
          ),
        ],
      ),
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
  Widget _buildProfileCard(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(
            Icons.person,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: const Text(
          'Selvin Crisostomo', // TODO: Replace with dynamic user name
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('selvin.crisostomo@example.com'), // TODO: Replace with dynamic user email
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
        onTap: () {
          // TODO: Navigate to the detailed profile view screen
        },
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
