abstract class DailyExpenseListEvent {}

class DailyExpenseListInitialEvent extends DailyExpenseListEvent {}

class DailyExpenseListThisWeekEvent extends DailyExpenseListEvent {}

class DailyExpenseListThisMonthEvent extends DailyExpenseListEvent {}

class DailyExpenseListLastMonthEvent extends DailyExpenseListEvent {}

class DailyExpenseListThisQuarterEvent extends DailyExpenseListEvent {}

class DailyExpenseListThisYearEvent extends DailyExpenseListEvent {}

class DailyExpenseListCustomDate extends DailyExpenseListEvent {
  String fastDay;
  String lastDay;
  DailyExpenseListCustomDate({required this.fastDay, required this.lastDay});
}

class DailyExpenseListDismissEvent extends DailyExpenseListEvent {
  String firstDate;
  String lastDate;
  int SaleId;
  DailyExpenseListDismissEvent(
      {required this.firstDate, required this.lastDate, required this.SaleId});
}

class DailyExpenseListDetailsEvent extends DailyExpenseListEvent {
  int SaleId;
  DailyExpenseListDetailsEvent({required this.SaleId});
}
