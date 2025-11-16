
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Profile'),
            subtitle: const Text('Basic information and account management'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('My Bookings'),
            onTap: () {},
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Information and FAQ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Contact Us'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Information'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Terms and Conditions'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('FAQS'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
