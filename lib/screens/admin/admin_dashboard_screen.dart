import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final authService = AuthService();
  int _selectedIndex = 0;

  Future<void> _updateStatus(String collection, String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection(collection).doc(docId).update({
        'status': newStatus,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated to $newStatus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // NEW: Function to send a reminder
  Future<void> _sendReminder(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Send Reminder to Patients'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., The clinic will be closed on Friday.',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              await FirebaseFirestore.instance.collection('reminders').add({
                'message': controller.text.trim(),
                'sentAt': FieldValue.serverTimestamp(),
              });
              if (context.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reminder sent to all patients!')),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              }
            },
          )
        ],
      ),
      // NEW: Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _sendReminder(context),
        backgroundColor: const Color(0xFF00897B),
        icon: const Icon(Icons.campaign, color: Colors.white),
        label: const Text('Send Reminder', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Stats Row
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
            builder: (context, appointmentSnapshot) {
              return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (context, userSnapshot) {
                    int totalAppointments = appointmentSnapshot.hasData ? appointmentSnapshot.data!.docs.length : 0;
                    int totalUsers = userSnapshot.hasData ? userSnapshot.data!.docs.length : 0;

                    double totalRevenue = 0;
                    int pendingCount = 0;

                    if (appointmentSnapshot.hasData) {
                      for (var doc in appointmentSnapshot.data!.docs) {
                        final data = doc.data() as Map<String, dynamic>;
                        if (data['status'] == 'approved' || data['status'] == 'completed') {
                          totalRevenue += (data['amount'] ?? 0).toDouble();
                        }
                        if (data['status'] == 'pending') {
                          pendingCount++;
                        }
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          _statCard('Users', '$totalUsers', Icons.people, Colors.blue),
                          const SizedBox(width: 12),
                          _statCard('Pending', '$pendingCount', Icons.pending, Colors.orange),
                          const SizedBox(width: 12),
                          _statCard('Revenue', 'R${totalRevenue.toStringAsFixed(0)}', Icons.attach_money, Colors.green),
                        ],
                      ),
                    );
                  }
              );
            },
          ),

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _tabButton(0, 'Appointments', Icons.calendar_today),
                _tabButton(1, 'Medications', Icons.medication),
                _tabButton(2, 'Feedback', Icons.feedback),
              ],
            ),
          ),
          const Divider(),

          // Tab Content
          Expanded(
            child: _selectedIndex == 0
                ? _buildAppointmentsTab()
                : _selectedIndex == 1
                ? _buildMedicationsTab()
                : _buildFeedbackTab(),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(int index, String label, IconData icon) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF00897B) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? const Color(0xFF00897B) : Colors.grey),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF00897B) : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- APPOINTMENTS TAB ---
  Widget _buildAppointmentsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('appointments').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) return const Center(child: Text('No appointments found.'));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final status = data['status'] ?? 'pending';

            return Card(
              child: ListTile(
                leading: Icon(
                  status == 'completed' ? Icons.check_circle :
                  status == 'approved' ? Icons.thumb_up :
                  status == 'cancelled' ? Icons.cancel : Icons.pending,
                  color: status == 'completed' ? Colors.blue :
                  status == 'approved' ? Colors.green :
                  status == 'cancelled' ? Colors.red : Colors.orange,
                ),
                title: Text('${data['service']} - R${data['amount']}'),
                subtitle: Text('${data['date']} at ${data['timeSlot']}\nStatus: ${status.toUpperCase()}'),
                isThreeLine: true,
                trailing: status == 'pending'
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _updateStatus('appointments', doc.id, 'cancelled'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () => _updateStatus('appointments', doc.id, 'approved'),
                    ),
                  ],
                )
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  // --- MEDICATIONS TAB ---
  Widget _buildMedicationsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('medication_requests').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) return const Center(child: Text('No medication requests.'));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final status = data['status'] ?? 'pending';

            return Card(
              child: ListTile(
                leading: const Icon(Icons.medication, color: Colors.purple),
                title: Text(data['medicationName'] ?? 'Medication'),
                subtitle: Text('Notes: ${data['notes']}\nStatus: ${status.toUpperCase()}'),
                isThreeLine: true,
                trailing: status == 'pending'
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _updateStatus('medication_requests', doc.id, 'rejected'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () => _updateStatus('medication_requests', doc.id, 'approved'),
                    ),
                  ],
                )
                    : Chip(
                  label: Text(status.toUpperCase(), style: const TextStyle(fontSize: 10)),
                  backgroundColor: status == 'approved' ? Colors.green.shade100 : Colors.red.shade100,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- FEEDBACK TAB ---
  Widget _buildFeedbackTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('feedback').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) return const Center(child: Text('No feedback received.'));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                leading: const Icon(Icons.feedback, color: Colors.blue),
                title: Text(data['subject'] ?? 'Feedback'),
                subtitle: Text(data['message'] ?? ''),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}