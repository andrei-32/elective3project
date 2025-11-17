import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          FaqItem(
            question: 'How do I book a flight?',
            answer:
                'To book a flight, go to the "Book Flight" tab, select your origin, destination, and dates, and search for available flights. Choose your preferred flight and bundle, then proceed to payment.',
          ),
          FaqItem(
            question: 'What payment methods are accepted?',
            answer:
                'We accept major credit cards (Visa, MasterCard), e-wallets (GCash, PayMaya), and direct bank transfers. All payments are processed securely.',
          ),
          FaqItem(
            question: 'Can I cancel my booking?',
            answer:
                'Yes, you can cancel your booking through the "My Bookings" tab. Please note that cancellation policies and fees may apply depending on the fare bundle you purchased.',
          ),
          FaqItem(
            question: 'How do I check my flight status?',
            answer:
                'You can check the real-time status of your flight in the "Schedules" tab. The status (e.g., On Time, Delayed, Cancelled) will be displayed next to your flight details.',
          ),
          FaqItem(
            question: 'How do I edit my profile information?',
            answer:
                'You can update your personal details by going to the "Profile" tab and tapping on "Basic Information." From there, you can edit your name, address, and other details.',
          ),
          FaqItem(
            question: 'Can I book for more than 9 people?',
            answer:
                'For group bookings of more than 9 people, please contact our customer support through the "Contact Us" section. We will be happy to assist you with your travel needs.',
          ),
        ],
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const FaqItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}
