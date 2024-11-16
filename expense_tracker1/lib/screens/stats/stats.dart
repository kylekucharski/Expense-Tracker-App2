import 'package:expense_tracker1/serivces/firestore_service.dart';
import 'package:flutter/material.dart';
import 'chart.dart';

class StatScreen extends StatelessWidget {
  const StatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return FutureBuilder<Map<String, dynamic>>(
      future: firestoreService.getMonthlyData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        }

        final data = snapshot.data!;
        final Map<String, double> monthlyExpenses =
            (data['expenses'] ?? {}).cast<String, double>();
        final double income = (data['income'] ?? 0.0) as double;

        if (monthlyExpenses.isEmpty || income <= 0) {
          return const Center(child: Text("No data available to display"));
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                    child: MyChart(
                      income: income,
                      expenses: monthlyExpenses,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
