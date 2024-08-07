import 'package:okra_distributer/view/daily_expense/model/daily_expense_model.dart';

abstract class DailyExpenseState {}

abstract class DailyExpenseActionState extends DailyExpenseState {}

class DailyExpenseInitialState extends DailyExpenseState {}

class DailyExpenseAddedState extends DailyExpenseActionState {}

class DailyExpenseLoadingState extends DailyExpenseActionState {}

class DailyExpenseTypeActionState extends DailyExpenseActionState {
  List<ExpenseTypeModel> expenseTypes;
  String? selectedItem;
  
  DailyExpenseTypeActionState({required this.expenseTypes, this.selectedItem});
}

