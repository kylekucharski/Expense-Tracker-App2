import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  final List<Expense> expenses;
  final double initialIncome;
  final ValueChanged<double> onIncomeUpdate;

  const MainScreen(
    this.expenses, {
    required this.initialIncome,
    required this.onIncomeUpdate,
    Key? key,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double _income = 0.0;

  @override
  void initState() {
    super.initState();
    _income = widget.initialIncome;
  }

  double _calculateTotalExpenses() {
    return widget.expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  void _updateIncome() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController incomeController =
            TextEditingController(text: _income.toStringAsFixed(2));
        return AlertDialog(
          title: const Text("Update Income"),
          content: TextField(
            controller: incomeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Enter your income",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _income = double.tryParse(incomeController.text) ?? _income;
                  widget.onIncomeUpdate(_income);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalExpenses = _calculateTotalExpenses();
    final balance = _income - totalExpenses;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Column(
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow[700],
                            ),
                          ),
                          Icon(
                            CupertinoIcons.person_fill,
                            color: Colors.yellow[800],
                          )
                        ],
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome!",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          Text(
                            "John Doe", // Replace with user name if available
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {}, // Placeholder for settings functionality
                    icon: const Icon(CupertinoIcons.settings),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Total Balance Card
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                    transform: const GradientRotation(pi / 4),
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.grey.shade300,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Main Content in Card
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total Balance',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '\$ $balance', // Display balance (income - expenses)
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Income Info
                              _infoRow(
                                icon: CupertinoIcons.arrow_down,
                                color: Colors.greenAccent,
                                label: "Income",
                                value: '\$ $_income',
                              ),
                              // Expenses Info
                              _infoRow(
                                icon: CupertinoIcons.arrow_down,
                                color: Colors.red,
                                label: "Expenses",
                                value: '\$ $totalExpenses',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Update Income Button (Positioned)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        onPressed: _updateIncome,
                        icon: const Icon(
                          CupertinoIcons.pencil,
                          color: Colors.white,
                        ),
                        tooltip: 'Update Income',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Transactions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {}, // Placeholder for "View All" functionality
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Transactions List
              Expanded(
                child: ListView.builder(
                  itemCount: widget.expenses.length,
                  itemBuilder: (context, int i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color(widget
                                              .expenses[i].category.color),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/${widget.expenses[i].category.icon}.png',
                                        scale: 2,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    widget.expenses[i].category.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "\$${widget.expenses[i].amount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MM/dd/yyyy').format(
                                        widget.expenses[i].date),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: Colors.white30,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 12,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
