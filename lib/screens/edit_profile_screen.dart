import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _userFuture = db.getUserById(widget.userId);
  }

  // Refreshes user data after an edit
  void _refreshUser() {
    setState(() {
      _userFuture = db.getUserById(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Basic Information'),
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
              _buildProfilePictureSection(),
              const SizedBox(height: 24),
              _buildInfoTile(
                context,
                label: 'Name',
                value: user.username, // Assuming username is the user's full name
                onEdit: () => _showEditDialog('Name', 'username', user.username),
              ),
              _buildInfoTile(
                context,
                label: 'Address',
                value: user.address ?? 'Not set',
                onEdit: () => _showEditDialog('Address', 'address', user.address ?? ''),
              ),
              _buildInfoTile(
                context,
                label: 'Gender',
                value: user.gender ?? 'Not set',
                onEdit: () => _showEditDialog('Gender', 'gender', user.gender ?? ''),
              ),
              _buildBirthdayTile(context, user.birthday),
              _buildInfoTile(
                context,
                label: 'Email',
                value: user.email,
                isEditable: false, // Email is not editable
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    // TODO: Implement actual image picking and uploading logic
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          child: const Icon(Icons.person, size: 70, color: Colors.white),
        ),
        TextButton.icon(
          icon: const Icon(Icons.camera_alt),
          label: const Text('Change Profile Picture'),
          onPressed: () {
            // Placeholder for image picker functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image upload functionality coming soon!')), 
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoTile(
      BuildContext context, {
        required String label,
        required String value,
        bool isEditable = true,
        VoidCallback? onEdit,
      }) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: Theme.of(context).textTheme.titleMedium),
      trailing: isEditable
          ? IconButton(
        icon: const Icon(Icons.edit, color: Colors.grey),
        onPressed: onEdit,
      )
          : null,
    );
  }

  Widget _buildBirthdayTile(BuildContext context, DateTime? birthday) {
    final value = birthday != null ? DateFormat.yMMMMd().format(birthday) : 'Not set';
    return ListTile(
      title: const Text('Birthday', style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: Theme.of(context).textTheme.titleMedium),
      trailing: IconButton(
        icon: const Icon(Icons.edit, color: Colors.grey),
        onPressed: () async {
          final newDate = await showDatePicker(
            context: context,
            initialDate: birthday ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (newDate != null) {
            await db.updateUserField(widget.userId, 'birthday', newDate.toIso8601String());
            _refreshUser(); // Refresh the UI
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
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: fieldLabel,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newValue = controller.text;
                if (newValue.isNotEmpty) {
                  // Update the database
                  await db.updateUserField(widget.userId, dbColumn, newValue);
                  Navigator.of(context).pop();
                  _refreshUser(); // Refresh the UI to show the new value
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
