import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../booking/booking_screen.dart';
import '../profile/profile_screen.dart';
import '../appointment/appointment_detail_screen.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  int _currentIndex = 0;

  Future<void> _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _dashboard(),
      _appointmentsList(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: const Color(0xFF00897B),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // NEW: Reminder banner widget
  Widget _reminderBanner() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reminders')
          .orderBy('sentAt', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink(); // Hide if no reminders
        }

        final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final message = data['message'] ?? '';

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1), // Light teal background
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF00897B)),
          ),
          child: Row(
            children: [
              const Icon(Icons.campaign, color: Color(0xFF00897B), size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Clinic Announcement',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00897B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(message, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dashboard() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName =
        user?.displayName ?? user?.email?.split('@').first ?? 'Patient';

    return Scaffold(
      appBar: AppBar(
        title: const Text('MediCare Connect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _reminderBanner(), // <-- ADDED HERE
            Text(
              'Welcome, $displayName',
              style:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('What would you like to do today?'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _actionCard(
                    icon: Icons.calendar_today,
                    label: 'Book\nAppointment',
                    color: const Color(0xFF00897B),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BookingScreen()),
                      );
                      if (mounted) setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionCard(
                    icon: Icons.medication,
                    label: 'Medication\nRequest',
                    color: Colors.orange,
                    onTap: _showMedicationDialog,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _actionCard(
                    icon: Icons.event_note,
                    label: 'My\nAppointments',
                    color: Colors.blue,
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionCard(
                    icon: Icons.feedback_outlined,
                    label: 'Feedback\n& Support',
                    color: Colors.purple,
                    onTap: () => setState(() => _currentIndex = 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Next Appointment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _nextAppointment(),
          ],
        ),
      ),
    );
  }

  Widget _nextAppointment() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getUserAppointments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Card(
            color: const Color(0xFFFFEBEE),
            child: ListTile(
              leading: const Icon(Icons.error_outline, color: Colors.red),
              title: const Text('Could not load appointments'),
              subtitle: Text(
                snapshot.error.toString(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('No upcoming appointments'),
              subtitle: Text('Tap "Book Appointment" to schedule one'),
            ),
          );
        }
        final doc = snapshot.data!.docs.first;
        final data = doc.data() as Map<String, dynamic>;
        return Card(
          child: ListTile(
            leading: const Icon(Icons.event, color: Color(0xFF00897B)),
            title: Text(data['service'] ?? 'Appointment'),
            subtitle: Text('${data['date']} at ${data['timeSlot']}'),
            trailing: _statusChip(data['status'] ?? 'pending'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AppointmentDetailScreen(
                  docId: doc.id,
                  data: data,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _appointmentsList() {
    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getUserAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Error loading appointments',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No appointments yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, i) {
              final doc = snapshot.data!.docs[i];
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.event, color: Color(0xFF00897B)),
                  title: Text(data['service'] ?? ''),
                  subtitle: Text('${data['date']} at ${data['timeSlot']}'),
                  trailing: _statusChip(data['status'] ?? 'pending'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentDetailScreen(
                        docId: doc.id,
                        data: data,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Handles the 3-stage workflow statuses
  Widget _statusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'approved':
        color = Colors.green;
        break;
      case 'completed':
        color = Colors.blue;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default: // pending
        color = Colors.orange;
    }
    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMedicationDialog() {
    final nameCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Medication Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Medication name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Additional notes',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Medication name is required')),
                );
                return;
              }
              try {
                await _firestoreService.submitMedicationRequest(
                  medicationName: nameCtrl.text.trim(),
                  notes: notesCtrl.text.trim(),
                );
                if (!mounted) return;
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                      Text('Medication request submitted successfully')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed: $e')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}