class ExpenseData{

  //list of All expenses
  List<ExpenseItem> overallExpenseList = [];

  //get expense list
  List<ExpenseItem> getExpenseList(){
    return overallExpenseList;
  }

  //add expense to list
  void addNewExpense(ExpenseItem expense){
    overallExpenseList.add(newExpense);
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
      if (getDayName (today.substract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.substract(Duration(days: i));
      }
    }
    return startOfWeek!;

  }

  /*
  convert overall list of expenses into a daily expense summary
  e.g.
  overallExpenseList =  
  [

  [food, 2026/01/30, $20.0],
  [drinks, 2026/01/30, $10.0],
  [food, 2026/02/31, $30.0],

  ]

  ->

  DailyExpenseSummary = 
  [
    [2026/01/30: $30.0],
    [2026/02/31: $30.0],
  ]

  */

  Map<String,double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      //date (yyyymmdd) : amountTotalForDay
    };
  }
}