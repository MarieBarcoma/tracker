import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:expense_tracker/models/expense_item.dart';

class ExpenseData{

  //list of All expenses
  List<ExpenseItem> overallExpenseList = [];

  ExpenseItem? get newExpense => null;

  //get expense list
  List<ExpenseItem> getExpenseList(){
    return overallExpenseList;
  }

  //add expense to list
  void addNewExpense(ExpenseItem expense){
    overallExpenseList.add(expense);
  }

  //delete expense from list
  void deleteExpense(ExpenseItem expense){
    overallExpenseList.remove(expense);
  }

  //get weekday from dateTime object
  String getDayName(DateTime dateTime){
    switch(dateTime.weekday){
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

  //get the date for the start of the week
  DateTime startOfWeekDate(){
    DateTime? startOfWeek;

    //get todays date
    DateTime today = DateTime.now();

    //go backwards from today to find sunday
    for (int i = 0; i <7; i++){
      if (getDayName (today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;

  }

  /*
  convert overall list of expenses into a daily expense summary
  e.g.
  overallExpenseList =  
  [

  [ food, 2026/01/30, $10 ],
  [ hat, 2026/01/30, $15 ]
  [ drinks, 2026/01/31, $1 ],
  [ food, 2026/02/01, $5 ],
  [ food, 2026/02/01, $6 ],
  [ food, 2026/02/03, $7 ],
  [ food, 2026/02/05, $10 ],
  [ food, 2026/02/05, $11 ],

  ]

  ->

  DailyExpenseSummary = 
  [
    [ 20260130: $25 ],
    [ 02260131: $1 ],
    [20260201: $11 ],
    [20260203: $7 ],
    [20260205: $21],

  ]

  */

  Map<String,double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      //date (yyyymmdd) : amountTotalForDay
    };

    for (var expense in overallExpenseList){
      String date = convertDateTimeToString(expense.dateTime);
      double amount = expense.amount;

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      }else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }
}