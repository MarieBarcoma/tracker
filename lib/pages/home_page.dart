import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:expense_tracker/pages/welcome_page.dart';
import 'package:expense_tracker/pages/statistics_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();
  
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    selectedDate = DateTime.now();

    showDialog(
      context: context, 
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: const [
              Icon(Icons.account_balance_wallet, color: Color(0xFF141518)),
              SizedBox(width: 8),
              Text('Add Expense', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newExpenseNameController,
                decoration: InputDecoration(
                  hintText: "Category (e.g., Food)",
                  prefixIcon: const Icon(Icons.category, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: newExpenseDollarController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Dollars",
                        prefixIcon: const Icon(Icons.attach_money, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: newExpenseCentsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Cents",
                        prefixIcon: const Icon(Icons.monetization_on, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setStateDialog(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            "${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}",
                            style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF2D3436)),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: cancel,
              child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF141518),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: save,
              child: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void deleteExpense(ExpenseItem expense){
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save(){
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseDollarController.text.isNotEmpty &&
        newExpenseCentsController.text.isNotEmpty) {
      
      String amount = '${newExpenseDollarController.text}.${newExpenseCentsController.text}';
      
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text, 
        amount: double.tryParse(amount) ?? 0.0,
        dateTime: selectedDate,
      );

      Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    }
  
    Navigator.pop(context);
    clear();
  }

  void cancel(){
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        double totalBalance = value.getAllExpenseList().fold(0.0, (sum, item) => sum + item.amount);
        
        DateTime startOfWeek = value.startOfWeekDate();
        DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));

        var currentWeekExpenses = value.getAllExpenseList().where((item) {
          return item.dateTime.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
                 item.dateTime.isBefore(endOfWeek);
        }).toList();

        double currentWeekTotal = currentWeekExpenses.fold(0.0, (sum, item) => sum + item.amount);

        Map<String, double> categoryTotals = {};
        for (var item in currentWeekExpenses) {
          categoryTotals.update(item.name, (sum) => sum + item.amount, ifAbsent: () => item.amount);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                // Top Greeting & Notification Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Good Morning!',
                          style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Marie Barcoma',
                          style: TextStyle(color: Color(0xFF141518), fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF141518), size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Styled Credit Card Balance Box matching reference[cite: 8]
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1C20),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${totalBalance.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Balance',
                                style: TextStyle(color: Colors.white60, fontSize: 13),
                              ),
                            ],
                          ),
                          // Three dots options icon
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.more_horiz, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Progress bar tracker inside card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.65,
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF7675)),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Card details bottom row (Card numbers + Mastercard)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '* * * *    * * * *    4 0 2',
                            style: TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 2),
                          ),
                          // Mastercard overlapping circles logo
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEB001B),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(-8, 0),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Transactions / Summary status cards row matching reference[cite: 8]
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00B894).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_upward, color: Color(0xFF00B894), size: 18),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('+24%', style: TextStyle(color: Color(0xFF00B894), fontWeight: FontWeight.bold, fontSize: 14)),
                                SizedBox(height: 2),
                                Text('Income', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF7675).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_downward, color: Color(0xFFFF7675), size: 18),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('-42%', style: TextStyle(color: Color(0xFFFF7675), fontWeight: FontWeight.bold, fontSize: 14)),
                                SizedBox(height: 2),
                                Text('Expense', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Expense by Category Graph (Current Week Only)
                const Text(
                  'Expense by Category (This Week)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF141518)),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: categoryTotals.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text('No weekly category data available', style: TextStyle(color: Colors.grey)),
                          ),
                        )
                      : Column(
                          children: categoryTotals.entries.map((entry) {
                            double percentage = currentWeekTotal > 0 ? (entry.value / currentWeekTotal) : 0.0;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF141518))),
                                      Text('\$${entry.value.toStringAsFixed(2)} (${(percentage * 100).toStringAsFixed(0)}%)', 
                                        style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: percentage,
                                      backgroundColor: Colors.grey[100],
                                      color: const Color(0xFF141518),
                                      minHeight: 10,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ),

                const SizedBox(height: 25),

                // Add Expense Action Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: addNewExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF141518),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    child: const Text(
                      '+ Add Expense',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Recent Transactions Header & List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Transactions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF141518)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See all', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                value.getAllExpenseList().isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: Text('No transactions yet', style: TextStyle(color: Colors.grey[500], fontSize: 15)),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.getAllExpenseList().length,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3)),
                            ],
                          ),
                          child: ExpenseTile(
                            name: value.getAllExpenseList()[index].name,
                            amount: value.getAllExpenseList()[index].amount.toStringAsFixed(2),
                            dateTime: value.getAllExpenseList()[index].dateTime,
                            deleteTapped: (p0) => 
                              deleteExpense(value.getAllExpenseList()[index]),
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          // Bottom Navigation Bar matching reference[cite: 8]
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home_filled, color: Color(0xFF141518), size: 26),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.account_balance_wallet_outlined, color: Colors.grey, size: 26),
                  onPressed: () {},
                ),
                // Floating Action Center Plus Button
                GestureDetector(
                  onTap: addNewExpense,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF141518),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.bar_chart_rounded, color: Colors.grey, size: 26),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StatisticsPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline_rounded, color: Colors.grey, size: 26),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const WelcomePage()),
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