import 'package:elective3project/database/database_helper.dart';
import 'package:elective3project/models/user.dart';
<<<<<<< HEAD
=======
import 'package:elective3project/services/email_service.dart';
import 'package:elective3project/screens/password_reset_screen.dart';
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final db = DatabaseHelper();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final username = _usernameController.text;
      final password = _passwordController.text;

      // *** THIS IS THE FIX ***
      // Changed db.getUser(...) to the correct method name: db.getUserByCredentials(...)
      final User? user = await db.getUserByCredentials(username, password);

      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        // Handle admin login
        if (user.username == 'admin' && user.password == 'admin123') {
          Navigator.pushReplacementNamed(context, '/admin_home');
        } else {
          // Handle regular user login
          // Pass the user ID to the home screen so other screens can use it
          Navigator.pushReplacementNamed(context, '/home', arguments: user.id);
        }
      } else {
        // Show error message if login fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid username or password.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
                  'Enter your email address to receive a password reset code.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
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
                  // Close dialog first
                  if (mounted) Navigator.pop(context);
                  // Then handle reset
                  await _handlePasswordReset(emailController.text.trim());
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
  Future<void> _handlePasswordReset(String email) async {
    final db = DatabaseHelper();
    // Find user by email instead of username
    final allUsers = await db.getAllUsers();
    User? user;
    for (var u in allUsers) {
      if (u.email == email) {
        user = u;
        break;
      }
    }

    if (!mounted) return;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email address not found in our system'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Generate reset code
    String resetCode = EmailService.generateResetCode();

    // Send email with reset link
    final emailResult = await EmailService.sendPasswordResetEmail(
      user.email,
      user.username,
      resetCode,
    );

    if (!mounted) return;

    if (emailResult['success'] == true) {
      // Navigate to password reset screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              PasswordResetScreen(email: user!.email, resetCode: resetCode),
        ),
      );
    } else {
      final errorMessage =
          emailResult['error'] ?? 'Failed to generate reset code.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
=======
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
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/images/logo.png', height: 120),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to FlyQuest',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
<<<<<<< HEAD
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/registration');
                      },
                      child: const Text('Sign Up'),
=======
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
>>>>>>> 7a216ea75d2d1eb69f01744958c44f4881f3d2d0
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
