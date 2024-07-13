import 'package:okra_distributer/view/daily_expense/model/daily_expense_model.dart';

abstract class SaleOrderListState {}

abstract class DailyExpenseListActionState {}

class SaleInitialState extends SaleOrderListState {}

class LoadingState extends SaleOrderListState {}

class SuccessState extends SaleOrderListState {
  String firstDate;
  String lastDate;
  final saleList;
  List<ExpenseTypeModel> expenseTypes;
  String? selectedItem;

  SuccessState(
      {required this.saleList,
      required this.expenseTypes,
      this.selectedItem,
      required this.firstDate,
      required this.lastDate});
}

class SinkStatusIsOne extends DailyExpenseListActionState {}

class SaleListDetailsState extends SaleOrderListState {
  final daily_expense_list;

  SaleListDetailsState({
    required this.daily_expense_list,
  });
}

class DailyExpenseTypeActionState extends SaleOrderListState {
  List<ExpenseTypeModel> expenseTypes;
  String? selectedItem;
  DailyExpenseTypeActionState({required this.expenseTypes, this.selectedItem});
}
