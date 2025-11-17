import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/user.dart';

class EditProfileScreen extends StatefulWidget {
  final int userId;

  const EditProfileScreen({super.key, required this.userId});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final db = DatabaseHelper();
  late Future<User?> _userFuture;
  bool _hasChanges = false; // Track if any changes were made

  @override
  void initState() {
    super.initState();
    _userFuture = db.getUserById(widget.userId);
  }

  // Refreshes user data and marks changes
  void _refreshUser() {
    setState(() {
      _userFuture = db.getUserById(widget.userId);
      _hasChanges = true;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await db.updateUserField(widget.userId, 'profileImagePath', image.path);
      _refreshUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Pass back a result when the user navigates back
        Navigator.pop(context, _hasChanges);
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Basic Information'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, _hasChanges),
          ),
        ),
        body: FutureBuilder<User?>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('User not found.'));
            }

            final user = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildProfilePictureSection(user),
                const SizedBox(height: 24),
                _buildInfoTile(context, label: 'First Name', value: user.firstName, onEdit: () => _showEditDialog('First Name', 'firstName', user.firstName)),
                _buildInfoTile(context, label: 'Last Name', value: user.lastName, onEdit: () => _showEditDialog('Last Name', 'lastName', user.lastName)),
                _buildInfoTile(context, label: 'Username', value: user.username, isEditable: false),
                _buildInfoTile(context, label: 'Address', value: user.address, onEdit: () => _showEditDialog('Address', 'address', user.address)),
                _buildGenderTile(context, user.gender),
                _buildBirthdayTile(context, user.birthday),
                _buildInfoTile(context, label: 'Email', value: user.email, isEditable: false),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(User user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: user.profileImagePath != null && File(user.profileImagePath!).existsSync()
              ? FileImage(File(user.profileImagePath!))
              : null,
          child: user.profileImagePath == null || !File(user.profileImagePath!).existsSync()
              ? Icon(Icons.person, size: 70, color: Colors.grey.shade600)
              : null,
        ),
        TextButton.icon(
          icon: const Icon(Icons.camera_alt),
          label: const Text('Change Profile Picture'),
          onPressed: _pickImage,
        ),
      ],
    );
  }

   Widget _buildInfoTile(BuildContext context, {required String label, required String value, bool isEditable = true, VoidCallback? onEdit}) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: Theme.of(context).textTheme.titleMedium),
      trailing: isEditable ? IconButton(icon: const Icon(Icons.edit, color: Colors.grey), onPressed: onEdit) : null,
    );
  }

  Widget _buildGenderTile(BuildContext context, String currentGender) {
    return ListTile(
      title: const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(currentGender, style: Theme.of(context).textTheme.titleMedium),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Colors.grey),
        onPressed: () => _showGenderEditDialog(currentGender),
      ),
    );
  }

  Widget _buildBirthdayTile(BuildContext context, DateTime birthday) {
    final value = DateFormat.yMMMMd().format(birthday);
    return ListTile(
      title: const Text('Birthday', style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: Theme.of(context).textTheme.titleMedium),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Colors.grey),
        onPressed: () async {
          final newDate = await showDatePicker(
            context: context,
            initialDate: birthday,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (newDate != null) {
            await db.updateUserField(widget.userId, 'birthday', newDate.toIso8601String());
            _refreshUser();
          }
        },
      ),
    );
  }

  void _showEditDialog(String fieldLabel, String dbColumn, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $fieldLabel'),
          content: TextField(controller: controller, autofocus: true, decoration: InputDecoration(labelText: fieldLabel)),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final newValue = controller.text;
                if (newValue.isNotEmpty) {
                  await db.updateUserField(widget.userId, dbColumn, newValue);
                  Navigator.of(context).pop();
                  _refreshUser();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showGenderEditDialog(String currentGender) {
    String? selectedGender = currentGender;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Gender'),
          content: DropdownButton<String>(
            value: selectedGender,
            isExpanded: true,
            items: ['Male', 'Female', 'Other'].map((gender) => DropdownMenuItem(value: gender, child: Text(gender))).toList(),
            onChanged: (value) {
              if (value != null) {
                selectedGender = value;
              }
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (selectedGender != null) {
                  await db.updateUserField(widget.userId, 'gender', selectedGender!);
                  Navigator.of(context).pop();
                  _refreshUser();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
