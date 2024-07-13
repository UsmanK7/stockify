import 'package:okra_distributer/view/daily_expense/model/daily_expense_model.dart';

abstract class SaleOrderListEvent {}

class SaleOrderListInitialEvent extends SaleOrderListEvent {}

class SaleOrderListThisWeekEvent extends SaleOrderListEvent {
  List<ExpenseTypeModel> expenseTypes;
  String? selectedItem;
  SaleOrderListThisWeekEvent({required this.expenseTypes, this.selectedItem});
}

class SaleOrderListThisMonthEvent extends SaleOrderListEvent {
  List<ExpenseTypeModel> expenseTypes;
  String? selectedItem;
  SaleOrderListThisMonthEvent({required this.expenseTypes, this.selectedItem});
}

class SaleOrderListLastMonthEvent extends SaleOrderListEvent {
  List<ExpenseTypeModel> expenseTypes;
  String? selectedItem;
  SaleOrderListLastMonthEvent({required this.expenseTypes, this.selectedItem});
}

class SaleOrderListThisQuarterEvent extends SaleOrderListEvent {
  List<ExpenseTypeModel> expenseTypes;
  String? selectedItem;
  SaleOrderListThisQuarterEvent(
      {required this.expenseTypes, this.selectedItem});
}

class SaleOrderListThisYearEvent extends SaleOrderListEvent {
  List<ExpenseTypeModel> expenseTypes;
  String? selectedItem;
  SaleOrderListThisYearEvent({required this.expenseTypes, this.selectedItem});
}

class SaleOrderListCustomDate extends SaleOrderListEvent {
  List<ExpenseTypeModel> expenseTypes;
  String? selectedItem;
  String fastDay;
  String lastDay;
  SaleOrderListCustomDate(
      {required this.fastDay,
      required this.lastDay,
      required this.expenseTypes,
      this.selectedItem});
}

// class SaleOrderListDismissEvent extends SaleOrderListEvent {
//   String firstDate;
//   String lastDate;
//   int SaleId;
//   SaleOrderListDismissEvent(
//       {required this.firstDate, required this.lastDate, required this.SaleId});
// }

class SaleOrderListDetailsEvent extends SaleOrderListEvent {
  int SaleId;
  SaleOrderListDetailsEvent({required this.SaleId});
}

class DailyExpenseTypeActionEvent extends SaleOrderListEvent {}

class DailyExpenseTypeDropdownChangeEvent extends SaleOrderListEvent {
  int iExpenseTypeID;
  String FilterState;
  List<ExpenseTypeModel> expenseTypes;
  String? fastDay;
  String? selectedItem;
  String? lastDay;
  DailyExpenseTypeDropdownChangeEvent(
      {required this.iExpenseTypeID,
      this.fastDay,
      required this.expenseTypes,
      this.lastDay,
      this.selectedItem,
      required this.FilterState});
}

class DailyExpenseListSyncEvent extends SaleOrderListEvent {
  List<int> iDailyExpenseID;
  String firstDate;
  List<ExpenseTypeModel> expenseTypes;
  String lastDate;
  final selectedItem;

  DailyExpenseListSyncEvent(
      {required this.iDailyExpenseID,
      required this.firstDate,
      required this.selectedItem,
      required this.expenseTypes,
      required this.lastDate});
}
