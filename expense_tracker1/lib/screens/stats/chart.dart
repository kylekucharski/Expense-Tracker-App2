import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyChart extends StatelessWidget {
  final double income; // Total income for the user
  final Map<String, double> expenses; // Monthly expenses (key: month, value: amount)

  const MyChart({
    required this.income,
    required this.expenses,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      mainBarData(context),
    );
  }

  BarChartGroupData makeGroupData(
    BuildContext context,
    int x,
    double expense, {
    required double maxIncome,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        // Background bar for income (gray bar)
        BarChartRodData(
          toY: maxIncome,
          color: Colors.grey.shade300,
          width: 20,
        ),
        // Gradient bar for expense
        BarChartRodData(
          toY: expense,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
            transform: const GradientRotation(pi / 4),
          ),
          width: 20,
        ),
      ],
    );
  }

  List<BarChartGroupData> showingGroups(BuildContext context) {
    final sortedExpenses = expenses.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)); // Sort by month

    return List.generate(sortedExpenses.length, (i) {
      final month = sortedExpenses[i];
      return makeGroupData(
        context,
        i,
        month.value,
        maxIncome: income, // Set max income for the gray bar
      );
    });
  }

  BarChartData mainBarData(BuildContext context) {
    return BarChartData(
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: (value, meta) => getBottomTitles(value, meta),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: (value, meta) => getLeftTitles(value, meta),
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
      barGroups: showingGroups(context),
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    final index = value.toInt();
    if (index < expenses.keys.length) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 16,
        child: Text(
          expenses.keys.elementAt(index),
          style: style,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    if (value % 1 == 0) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 0,
        child: Text('${value.toInt()}K', style: style),
      );
    }
    return const SizedBox.shrink();
  }
}
