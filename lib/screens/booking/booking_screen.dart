import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../payment/payment_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonCtrl = TextEditingController();
  String _service = 'Consultation';
  String _date = '';
  String _time = '';

  final List<String> _services = [
    'Consultation',
    'Chronic Care',
    'Vaccination',
    'Prescription Collection',
    'Follow-up Visit',
  ];

  final List<String> _timeSlots = [
    '08:00', '09:00', '10:00', '11:00', '12:00',
    '14:00', '15:00', '16:00', '17:00',
  ];

  final Map<String, double> _prices = {
    'Consultation': 350.00,
    'Chronic Care': 420.00,
    'Vaccination': 180.00,
    'Prescription Collection': 100.00,
    'Follow-up Visit': 250.00,
  };

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() {
        _date = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    if (_date.isEmpty) {
      _snack('Please select a date');
      return;
    }
    if (_time.isEmpty) {
      _snack('Please select a time slot');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          service: _service,
          date: _date,
          timeSlot: _time,
          reason: _reasonCtrl.text.trim(),
          amount: _prices[_service]!,
        ),
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel('Service'),
                DropdownButtonFormField<String>(
                  value: _service,
                  decoration:
                  const InputDecoration(border: OutlineInputBorder()),
                  items: _services
                      .map((s) =>
                      DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _service = v!),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fee: R${_prices[_service]!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF00897B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const _SectionLabel('Date'),
                InkWell(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_date.isEmpty ? 'Select a date' : _date),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const _SectionLabel('Time Slot'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _timeSlots.map((slot) {
                    final isSelected = _time == slot;
                    return ChoiceChip(
                      label: Text(slot),
                      selected: isSelected,
                      selectedColor: const Color(0xFF00897B),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      onSelected: (_) => setState(() => _time = slot),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const _SectionLabel('Reason for Visit'),
                TextFormField(
                  controller: _reasonCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Briefly describe your symptoms or reason',
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Reason is required'
                      : null,
                ),
                const SizedBox(height: 28),
                CustomButton(
                  label: 'CONTINUE TO PAYMENT',
                  onPressed: _continue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style:
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}