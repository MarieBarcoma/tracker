
import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //text controller
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  //add new expense
   void addNewExpense() {
    TextEditingController? newExpenseAmountController;
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Expense name",
              ),
            ),

            Row(
              children: [
                //dollars
                Expanded(
                  child: TextField(
                    controller: newExpenseDollarController,
                  ),
                ),
              
                //cents
                Expanded(
                  child: TextField (
                    controller: newExpenseCentsController,
                  ),
                ),
              ],
            ),

            //expense amount
            TextField(
              controller: newExpenseAmountController,
            ),
          ],
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: save,
            child: Text('Save'),
          ),

          //cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancel'), 
          ),
        ] 
      ),
    );
   }

   //save
   void save(){
    // put dollars and cents together
    String amount = '${newExpenseDollarController.text}.${newExpenseCentsController.text}';


    //create expense item
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: double.parse(amount),
      dateTime: DateTime.now(),
    ); //ExpenseItem
    //add the new expense
    Provider.of<ExpenseData>(context, listen:false).addNewExpense(newExpense);

    Navigator.pop(context);
    clear();
   }

   //cancel
   void cancel(){
    Navigator.pop(context);
    clear();
   }

   //clear controllers
   void clear() {
    newExpenseNameController.clear();
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
   }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child ) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
        body: ListView(children: [
          //weekly summary
          ExpenseSummary(startOfWeek: value.startOfWeekDate()),

          const SizedBox(height: 20),

          //expense List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value.getAllExpenseList().length,
            itemBuilder: (context, index) => ExpenseTile(
              name: value.getAllExpenseList()[index].name,
              amount: value.getAllExpenseList()[index].amount.toString(),
              dateTime: value.getAllExpenseList()[index].dateTime,
            ), //ExpenseTile
          )
        ]),
      ),
    );
  }
}