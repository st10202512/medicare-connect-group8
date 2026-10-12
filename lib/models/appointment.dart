import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String service;
  final String date;
  final String timeSlot;
  final String reason;
  final String status;
  final double amount;

  Appointment({
    required this.id,
    required this.service,
    required this.date,
    required this.timeSlot,
    required this.reason,
    required this.status,
    required this.amount,
  });

  factory Appointment.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment(
      id: doc.id,
      service: data['service'] ?? '',
      date: data['date'] ?? '',
      timeSlot: data['timeSlot'] ?? '',
      reason: data['reason'] ?? '',
      status: data['status'] ?? 'pending',
      amount: (data['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'service': service,
      'date': date,
      'timeSlot': timeSlot,
      'reason': reason,
      'status': status,
      'amount': amount,
    };
  }
}