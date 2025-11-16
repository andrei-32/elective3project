import 'package:elective3project/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final int? userId;
  const ProfileTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Define colors from your theme to ensure consistency
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color goldColor = Theme.of(context).colorScheme.secondary;

    // This function handles the navigation to the edit profile screen.
    // It also checks if the userId is valid before navigating.
    void navigateToEditProfile() {
      if (userId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(userId: userId!),
          ),
        );
      } else {
        // Show an error if the user ID is somehow null
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User not logged in properly.')),
        );
      }
    }

    // We use a ListView to ensure the content is scrollable on smaller screens
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Section: ACCOUNT
        _buildSectionHeader(context, 'ACCOUNT'),
        // *** CHANGE 1: The main profile card now also navigates to the edit screen. ***
        _buildProfileCard(context, onTap: navigateToEditProfile),
        // *** CHANGE 2: The "Basic Information" tile now navigates to the edit screen. ***
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
            // This functionality would require a callback to the home screen
            // to switch the bottom navigation bar index.
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
            // This correctly navigates to your MyCalendarScreen
            Navigator.pushNamed(context, '/holidays', arguments: userId);
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
    // TODO: This data should be fetched dynamically from the database in the future
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
        title: const Text(
          'Selvin Crisostomo', // This should be replaced with dynamic user name
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('selvin.crisostomo@example.com'), // This should be replaced with dynamic user email
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
        onTap: onTap, // Use the passed-in onTap function
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
