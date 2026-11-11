import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  // ---------- Users ----------
  Future<void> saveUserProfile({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    await _db.collection('users').doc(_uid).set({
      'uid': _uid,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': 'patient',
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final doc = await _db.collection('users').doc(_uid).get();
    return doc.data();
  }

  // ---------- Appointments ----------
  Future<String> createAppointment({
    required String service,
    required String date,
    required String timeSlot,
    required String reason,
    required String status,
    required double amount,
  }) async {
    final doc = await _db.collection('appointments').add({
      'userId': _uid,
      'service': service,
      'date': date,
      'timeSlot': timeSlot,
      'reason': reason,
      'status': 'pending', // <-- UPDATED: Always starts as pending
      'amount': amount,
      'prescription': '', // <-- NEW: Empty prescription field
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Stream<QuerySnapshot> getUserAppointments() {
    return _db
        .collection('appointments')
        .where('userId', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> cancelAppointment(String docId) async {
    await _db.collection('appointments').doc(docId).update({
      'status': 'cancelled',
    });
  }

  // ---------- Medication ----------
  Future<void> submitMedicationRequest({
    required String medicationName,
    required String notes,
  }) async {
    await _db.collection('medication_requests').add({
      'userId': _uid,
      'medicationName': medicationName,
      'notes': notes,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getUserMedicationRequests() {
    return _db
        .collection('medication_requests')
        .where('userId', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ---------- Feedback ----------
  Future<void> submitFeedback({
    required String subject,
    required String message,
  }) async {
    await _db.collection('feedback').add({
      'userId': _uid,
      'subject': subject,
      'message': message,
      'status': 'new',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}