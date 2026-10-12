import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../widgets/custom_button.dart';
import '../home/home_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String service;
  final String date;
  final String timeSlot;
  final String reason;
  final double amount;

  const PaymentScreen({
    super.key,
    required this.service,
    required this.date,
    required this.timeSlot,
    required this.reason,
    required this.amount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _firestoreService = FirestoreService();
  String _method = 'Card';
  bool _isProcessing = false;

  Future<void> _pay() async {
    setState(() => _isProcessing = true);

    // Simulate gateway processing
    await Future.delayed(const Duration(seconds: 2));

    try {
      final docId = await _firestoreService.createAppointment(
        service: widget.service,
        date: widget.date,
        timeSlot: widget.timeSlot,
        reason: widget.reason,
        status: 'confirmed',
        amount: widget.amount,
      );

      if (!mounted) return;
      _showSuccessDialog(docId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showSuccessDialog(String docId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Booking Confirmed'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service: ${widget.service}'),
            Text('Date: ${widget.date}'),
            Text('Time: ${widget.timeSlot}'),
            Text('Amount paid: R${widget.amount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text(
              'Reference: ${docId.substring(0, 8).toUpperCase()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const Text(
              'A confirmation email has been sent to your registered address.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
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
                      const Text(
                        'Appointment Summary',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Divider(),
                      _row('Service', widget.service),
                      _row('Date', widget.date),
                      _row('Time', widget.timeSlot),
                      _row('Reason', widget.reason),
                      const Divider(),
                      _row('Total',
                          'R${widget.amount.toStringAsFixed(2)}',
                          bold: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Payment Method',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile<String>(
                title: const Text('Credit / Debit Card'),
                value: 'Card',
                groupValue: _method,
                onChanged: (v) => setState(() => _method = v!),
              ),
              RadioListTile<String>(
                title: const Text('EFT / Bank Transfer'),
                value: 'EFT',
                groupValue: _method,
                onChanged: (v) => setState(() => _method = v!),
              ),
              const Card(
                color: Color(0xFFFFF3E0),
                child: ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.orange),
                  title: Text('Sandbox Mode'),
                  subtitle: Text(
                      'This is a simulated payment for academic demonstration'),
                ),
              ),
              const Spacer(),
              CustomButton(
                label: 'PAY R${widget.amount.toStringAsFixed(2)}',
                isLoading: _isProcessing,
                onPressed: _pay,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}