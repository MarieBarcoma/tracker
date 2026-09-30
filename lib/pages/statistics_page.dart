import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/data/expense_data.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  // Default to September
  String selectedMonth = 'September'; 

  // Map month names to their corresponding calendar numbers (1-12)
  final Map<String, int> monthMap = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        int targetMonthNumber = monthMap[selectedMonth] ?? 9;

        // Filter transactions for the selected month
        var filteredExpenses = value.getAllExpenseList().where((item) {
          return item.dateTime.month == targetMonthNumber;
        }).toList();

        // Calculate category totals for the pie chart
        Map<String, double> categoryTotals = {};
        for (var item in filteredExpenses) {
          categoryTotals.update(item.name, (sum) => sum + item.amount, ifAbsent: () => item.amount);
        }

        double monthTotalBalance = categoryTotals.values.fold(0.0, (sum, amt) => sum + amt);

        // Define distinct colors for the pie chart slices
        final List<Color> pieColors = [
          const Color(0xFF5C73F2), // Blue
          const Color(0xFFFF7675), // Coral/Red
          const Color(0xFFFFEAA7), // Yellow/Orange
          const Color(0xFF00B894), // Teal
          const Color(0xFFA29BFE), // Purple
        ];

        int colorIndex = 0;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                // Top Row with Back Button
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3436)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Title "Statistics"
                const Text(
                  'Statistics',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 20),

                // Month Dropdown Filter
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMonth,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2D3436)),
                        items: monthMap.keys
                            .map((month) => DropdownMenuItem(
                                  value: month,
                                  child: Text(month, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D3436))),
                                ))
                            .toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedMonth = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Expense by Category Card with Pie Chart
                Text(
                  'Expense by Category ($selectedMonth)',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: categoryTotals.isEmpty
                      ? SizedBox(
                          height: 200,
                          child: Center(
                            child: Text('No data available for $selectedMonth', style: const TextStyle(color: Colors.grey)),
                          ),
                        )
                      : SizedBox(
                          height: 220,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: categoryTotals.entries.map((entry) {
                                final double percentage = monthTotalBalance > 0 ? (entry.value / monthTotalBalance) * 100 : 0.0;
                                final Color currentColor = pieColors[colorIndex % pieColors.length];
                                colorIndex++;

                                return PieChartSectionData(
                                  color: currentColor,
                                  value: entry.value,
                                  title: '${percentage.toStringAsFixed(0)}%',
                                  radius: 70,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 30),

                // Monthly Recorded Data Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$selectedMonth Transactions',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
                    ),
                    Text(
                      'Total: \$${monthTotalBalance.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF5C73F2)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                filteredExpenses.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'No expenses recorded for $selectedMonth',
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredExpenses.length,
                        itemBuilder: (context, index) {
                          final expense = filteredExpenses[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF5C73F2).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.receipt_long, color: Color(0xFF5C73F2), size: 20),
                                    ),
                                    const SizedBox(width: 14),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          expense.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color(0xFF2D3436),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${expense.dateTime.day} / ${expense.dateTime.month} / ${expense.dateTime.year}',
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  '\$${expense.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF2D3436),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}