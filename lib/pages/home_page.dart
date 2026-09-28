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
  final newExpenseAmountController = TextEditingController();

  //add new expense
   void addNewExpense() {
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
    //create expense item
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: double.tryParse(newExpenseAmountController.text) ?? 0.0,
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
    newExpenseAmountController.clear();
   }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child ) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.getAllExpenseList().length,
          itemBuilder: (context, index) => ListTile(
            title: Text(value.getAllExpenseList()[index].name),
            subtitle: Text(value.getAllExpenseList()[index].dateTime.toString()),
            trailing: Text(value.getAllExpenseList()[index].amount.toString()),
          ),
        ),
      ),
    );
  }
}