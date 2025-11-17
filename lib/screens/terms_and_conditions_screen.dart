import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to FlyQuest!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'These terms and conditions outline the rules and regulations for the use of FlyQuest\'s mobile application.',
            ),
            SizedBox(height: 16),
            Text(
              '1. Introduction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'By accessing this app, we assume you accept these terms and conditions. Do not continue to use FlyQuest if you do not agree to all of the terms and conditions stated on this page.',
            ),
            SizedBox(height: 16),
            Text(
              '2. Bookings and Payments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'All flight bookings are subject to availability. Prices are not guaranteed until payment is complete. We accept various payment methods, which are processed through a secure third-party gateway.',
            ),
            SizedBox(height: 16),
            Text(
              '3. Cancellations and Refunds',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Cancellation policies vary depending on the airline and fare bundle selected. Please review the cancellation terms before completing your booking. Refunds, if applicable, will be processed according to the airline\'s policy.',
            ),
            SizedBox(height: 16),
            Text(
              '4. User Accounts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.',
            ),
            SizedBox(height: 16),
            Text(
              '5. Limitation of Liability',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'In no event shall FlyQuest, nor any of its officers, directors, and employees, be held liable for anything arising out of or in any way connected with your use of this app.',
            ),
          ],
        ),
      ),
    );
  }
}
