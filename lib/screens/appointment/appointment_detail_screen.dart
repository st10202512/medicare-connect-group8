import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;

  const AppointmentDetailScreen({
    super.key,
    required this.docId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Details')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _row('Service', data['service'] ?? ''),
                      _row('Date', data['date'] ?? ''),
                      _row('Time', data['timeSlot'] ?? ''),
                      _row('Reason', data['reason'] ?? ''),
                      _row('Status', (data['status'] ?? '').toString().toUpperCase()),
                      _row('Amount',
                          'R${(data['amount'] ?? 0).toStringAsFixed(2)}'),
                      if (data['prescription'] != null && data['prescription'].toString().isNotEmpty) ...[
                        const Divider(),
                        const Text(
                          'Doctor\'s Prescription',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00897B),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            data['prescription'],
                            style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if ((data['status'] ?? '') != 'cancelled' && (data['status'] ?? '') != 'completed')
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text(
                      'Cancel Appointment',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Cancel Appointment?'),
                          content: const Text(
                              'Are you sure you want to cancel this appointment?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('No'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await FirestoreService()
                            .cancelAppointment(docId);
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}