import 'package:flutter/material.dart';
import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:expense_tracker/data/hive_database.dart';

class ExpenseData extends ChangeNotifier {
  // list of All expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expense list sorted by date (newest first)
  List<ExpenseItem> getAllExpenseList() {
    overallExpenseList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return overallExpenseList;
  }

  // prepare data to display from Hive database
  final db = HiveDatabase();

  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
      overallExpenseList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    }
  }

  // add new expense and sort
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    overallExpenseList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // delete expense 
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // get weekday from dateTime object
  String getDayName(DateTime dateTime) {
    switch(dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // get the date for the start of the week
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = expense.amount;

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }
}