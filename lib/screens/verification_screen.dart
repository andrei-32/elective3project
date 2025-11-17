import 'package:elective3project/database/database_helper.dart';
import 'package:elective3project/models/user.dart';
import 'package:elective3project/screens/login_screen.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  final User userToRegister;
  final String verificationCode;

  const VerificationScreen({
    super.key,
    required this.userToRegister,
    required this.verificationCode,
  });

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  String _errorMessage = '';

  void _verifyCode() async {
    if (_formKey.currentState!.validate()) {
      if (_codeController.text == widget.verificationCode) {
        // Code is correct, save user to database
        final db = DatabaseHelper();
        await db.insertUser(widget.userToRegister);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification successful! Please log in.')),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid verification code. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'A verification code has been sent to ${widget.userToRegister.email}. Please enter it below.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter the code' : null,
              ),
              const SizedBox(height: 16),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _verifyCode,
                child: const Text('Verify & Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
