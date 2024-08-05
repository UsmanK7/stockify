import 'package:okra_distributer/view/daily_expense/model/daily_expense_model.dart';

abstract class DailyExpenseEvent {}

class AddDailyExpenseEvent extends DailyExpenseEvent {
  final DailyExpense dailyExpense;
  AddDailyExpenseEvent({required this.dailyExpense});
}
