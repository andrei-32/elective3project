import 'package:elective3project/database/database_helper.dart';
import 'package:elective3project/services/email_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Shows the forgot password dialog
  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter your username to receive a password reset code.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await _handlePasswordReset(emailController.text.trim());
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('Send Reset Code'),
            ),
          ],
        );
      },
    );
  }

  /// Handles the password reset process
  Future<void> _handlePasswordReset(String username) async {
    final db = DatabaseHelper();
    final user = await db.getUserByUsername(username);

    if (!mounted) return;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username not found'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Sending reset code to your email...'),
            ],
          ),
        );
      },
    );

    // Generate reset code
    String resetCode = EmailService.generateResetCode();

    // Send email
    bool emailSent = await EmailService.sendPasswordResetEmail(
      user.email,
      user.username,
      resetCode,
    );

    if (!mounted) return;
    Navigator.pop(context); // Close loading dialog

    if (emailSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reset code sent to ${user.email}. Please check your email.',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to send reset email. Please check email configuration.',
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 30,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.flight_takeoff);
              },
            ),
            const SizedBox(width: 8),
            const Text(
              'FLYQUEST',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 80.0,
                      errorBuilder: (context, error, stackTrace) {
                        return const FlutterLogo(size: 80.0);
                      },
                    ),
                    const SizedBox(height: 32.0),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_usernameController.text == 'admin' &&
                              _passwordController.text == 'admin') {
                            Navigator.pushReplacementNamed(
                              context,
                              '/admin_home',
                            );
                          } else {
                            final db = DatabaseHelper();
                            final user = await db.getUser(
                              _usernameController.text,
                              _passwordController.text,
                            );
                            if (!mounted) return;
                            if (user != null) {
                              Navigator.pushReplacementNamed(
                                context,
                                '/home',
                                arguments: user.id,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid username or password'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Color(0xFF000080)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/registration');
                          },
                          child: const Text('Sign Up'),
                        ),
                        TextButton(
                          onPressed: _showForgotPasswordDialog,
                          child: const Text('Forgot Password?'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
