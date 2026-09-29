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
  String selectedMonth = 'March'; // Default month filter from reference

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        // Calculate category totals dynamically from your provider data
        Map<String, double> categoryTotals = {};
        for (var item in value.getAllExpenseList()) {
          categoryTotals.update(item.name, (sum) => sum + item.amount, ifAbsent: () => item.amount);
        }

        double totalBalance = categoryTotals.values.fold(0.0, (sum, amt) => sum + amt);

        // Define a list of colors for the pie chart slices
        final List<Color> pieColors = [
          const Color(0xFF5C73F2), // Blue
          const Color(0xFFFF7675), // Coral/Red
          const Color(0xFFFFEaa7), // Yellow/Orange
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
                        items: ['January', 'February', 'March', 'April', 'May', 'June']
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
                const Text(
                  'Expense by Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
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
                      ? const SizedBox(
                          height: 200,
                          child: Center(
                            child: Text('No data available for pie chart', style: TextStyle(color: Colors.grey)),
                          ),
                        )
                      : SizedBox(
                          height: 220,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: categoryTotals.entries.map((entry) {
                                final double percentage = totalBalance > 0 ? (entry.value / totalBalance) * 100 : 0.0;
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

                // Weekly Progress Section (matching the reference layout)
                const Text(
                  'Weekly Progress',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Column(
                    children: [
                      // Sub-bars layout or summary tracker
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildProgressColumn('Drink Water', 0.8, const Color(0xFF55E6C1)),
                          _buildProgressColumn('Exercise', 0.6, const Color(0xFF786FA6)),
                          _buildProgressColumn('Read', 0.4, const Color(0xFFF8A5C2)),
                          _buildProgressColumn('Savings', 0.3, const Color(0xFFF3a683)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget for weekly progress individual bars
  Widget _buildProgressColumn(String label, double progress, Color color) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
      ],
    );
  }
}