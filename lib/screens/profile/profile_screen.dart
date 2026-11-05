import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _isSubmitting = false;

  // State for the settings toggle
  bool _remindersEnabled = true;

  Future<void> _submitFeedback() async {
    if (_subjectCtrl.text.trim().isEmpty ||
        _messageCtrl.text.trim().isEmpty) {
      _snack('Please fill in all fields');
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await _firestoreService.submitFeedback(
        subject: _subjectCtrl.text.trim(),
        message: _messageCtrl.text.trim(),
      );
      _subjectCtrl.clear();
      _messageCtrl.clear();
      _snack('Feedback submitted. Thank you!');
    } catch (e) {
      _snack('Failed to submit feedback: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile / Support')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // User Profile Card
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF00897B),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(user?.displayName ?? 'Patient'),
                subtitle: Text(user?.email ?? ''),
              ),
            ),
            const SizedBox(height: 24),

            // Settings Section
            const Text('Settings',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined,
                    color: Color(0xFF00897B)),
                title: const Text('Appointment Reminders'),
                subtitle: const Text('Receive reminders before your visit'),
                value: _remindersEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _remindersEnabled = value;
                  });
                  _snack(value ? 'Reminders enabled' : 'Reminders disabled');
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.language, color: Color(0xFF00897B)),
                title: const Text('Language'),
                subtitle: const Text('English (South Africa)'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Select Language'),
                      content: const Text(
                          'Currently only English (South Africa) is available.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Feedback Section
            const Text('Submit Feedback or Complaint',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _subjectCtrl,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitFeedback,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SUBMIT FEEDBACK'),
              ),
            ),
            const SizedBox(height: 24),
            const Card(
              child: ListTile(
                leading: Icon(Icons.help_outline, color: Color(0xFF00897B)),
                title: Text('Help & Support'),
                subtitle: Text('support@medicareconnect.co.za\n+27 12 345 6789'),
                isThreeLine: true,
              ),
            ),
            const SizedBox(height: 12),
            const Card(
              child: ListTile(
                leading: Icon(Icons.info_outline, color: Color(0xFF00897B)),
                title: Text('App Version'),
                subtitle: Text('1.0.0'),
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'LOGOUT',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  await _authService.signOut();
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginScreen()),
                        (route) => false,
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }
}