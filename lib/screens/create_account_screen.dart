import 'dart:math';
import 'package:elective3project/database/database_helper.dart';
import 'package:elective3project/models/user.dart';
import 'package:elective3project/screens/login_screen.dart';
import 'package:elective3project/screens/verification_screen.dart';
import 'package:elective3project/services/email_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  DateTime? _selectedDob;
  String? _selectedGender;
  bool _isPasswordVisible = false;
  bool _isCreatingAccount = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _createAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isCreatingAccount = true);

      final newUser = User(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text, // In a real app, hash this!
        address: _addressController.text,
        gender: _selectedGender!,
        birthday: _selectedDob!,
      );

      final verificationCode = (100000 + Random().nextInt(900000)).toString();

      final emailResult = await EmailService.sendVerificationEmail(
        newUser.email,
        newUser.username,
        verificationCode,
      );

      setState(() => _isCreatingAccount = false);

      if (emailResult['success']) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationScreen(
                userToRegister: newUser,
                verificationCode: verificationCode,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send verification email: ${emailResult['error']}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 48.0),
                _buildCreateAccountForm(),
                const SizedBox(height: 24.0),
                _buildCreateAccountButton(),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png', 
          height: 100,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.flight_takeoff, size: 100, color: Colors.blue);
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Join FLYQUEST',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000080),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create an account to get started',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Please enter your first name' : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: 'Last Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Please enter your last name' : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Please enter a username' : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => (value == null || !value.contains('@')) ? 'Please enter a valid email' : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
            validator: (value) => (value == null || value.length < 6) ? 'Password must be at least 6 characters' : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            validator: (value) => (value != _passwordController.text) ? 'Passwords do not match' : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            validator: (value) => (value == null || value.isEmpty) ? 'Please enter your address' : null,
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            items: ['Male', 'Female', 'Other'].map((gender) => DropdownMenuItem(value: gender, child: Text(gender))).toList(),
            onChanged: (value) => setState(() => _selectedGender = value),
            validator: (value) => (value == null) ? 'Please select your gender' : null,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _dobController,
            decoration: InputDecoration(
              labelText: 'Date of Birth',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() {
                  _selectedDob = date;
                  _dobController.text = DateFormat.yMMMMd().format(date);
                });
              }
            },
            validator: (value) => (value == null || value.isEmpty) ? 'Please select your date of birth' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return ElevatedButton(
      onPressed: _isCreatingAccount ? null : _createAccount,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: const Color(0xFF000080),
      ),
      child: _isCreatingAccount
          ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
          : const Text(
              'CREATE ACCOUNT',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
    );
  }

  Widget _buildLoginLink() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account?"),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Log In',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF000080),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
