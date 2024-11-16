import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current user ID from Firebase Authentication
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  /// Fetch user's income and monthly expenses
  Future<Map<String, dynamic>> getMonthlyData() async {
    if (_userId == null) throw Exception("User not logged in");

    // Fetch user document
    final userDoc = await _firestore.collection('users').doc(_userId).get();
    final double income = userDoc.data()?['income'] ?? 0.0;

    // Fetch all expenses for the user
    final expensesSnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('expenses')
        .get();

    // Organize expenses by month
    final Map<String, double> monthlyExpenses = {};
    for (final doc in expensesSnapshot.docs) {
      final DateTime date = (doc['date'] as Timestamp).toDate();
      final String month = date.month.toString().padLeft(2, '0'); // e.g., '01'
      monthlyExpenses[month] = (monthlyExpenses[month] ?? 0) + doc['amount'];
    }

    return {
      'income': income,
      'expenses': monthlyExpenses,
    };
  }

  /// Add a new expense
  Future<void> addExpense(Map<String, dynamic> expense) async {
    if (_userId == null) throw Exception("User not logged in");

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('expenses')
        .add(expense);
  }
}
