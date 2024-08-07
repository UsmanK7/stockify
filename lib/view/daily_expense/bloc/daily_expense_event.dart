import 'package:okra_distributer/view/daily_expense/model/daily_expense_model.dart';

abstract class DailyExpenseEvent {}

class AddDailyExpenseEvent extends DailyExpenseEvent {
  final DailyExpense dailyExpense;
  AddDailyExpenseEvent({required this.dailyExpense});
}

class DailyExpenseTypeActionEvent extends DailyExpenseEvent {}

class DailyExpenseTypeChangedActionEvent extends DailyExpenseEvent {
  String selectedItem;
  List<ExpenseTypeModel> expenseTypes;
  DailyExpenseTypeChangedActionEvent(
      {required this.selectedItem, required this.expenseTypes});
}

class DailyExpenseListDetailsEvent extends DailyExpenseEvent {
  int SaleId;
  DailyExpenseListDetailsEvent({required this.SaleId});
}
