import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would send this data to a backend server or email service.
      final String subject = _subjectController.text;
      final String message = _messageController.text;

      // Simulate sending
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the form
      _subjectController.clear();
      _messageController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactInfo(context),
            const Divider(height: 48.0),
            _buildFeedbackForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Get in Touch',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Have questions or feedback? We\'d love to hear from you. Reach out to us through any of the methods below.',
        ),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: const Text('Email Support'),
          subtitle: const Text('support@flyquest.com'),
          onTap: () { /* TODO: Implement email launching */ },
        ),
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: const Text('Phone Support'),
          subtitle: const Text('+1 (800) 555-1234'),
          onTap: () { /* TODO: Implement phone launching */ },
        ),
      ],
    );
  }

  Widget _buildFeedbackForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send Us a Message',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _subjectController,
            decoration: const InputDecoration(
              labelText: 'Subject',
              border: OutlineInputBorder(),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Please enter a subject' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _messageController,
            decoration: const InputDecoration(
              labelText: 'Your Message',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 5,
            validator: (value) => (value == null || value.isEmpty) ? 'Please enter your message' : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Submit Feedback'),
            ),
          ),
        ],
      ),
    );
  }
}
