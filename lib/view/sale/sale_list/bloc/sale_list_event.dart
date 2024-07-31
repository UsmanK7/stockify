abstract class SaleListEvent {}

class SaleListInitialEvent extends SaleListEvent {}

class SaleListThisWeekEvent extends SaleListEvent {}

class SaleListThisMonthEvent extends SaleListEvent {}

class SaleListLastMonthEvent extends SaleListEvent {}

class SaleListThisQuarterEvent extends SaleListEvent {}

class SaleListThisYearEvent extends SaleListEvent {}

class SaleListCustomDate extends SaleListEvent {
  String fastDay;
  String lastDay;
  SaleListCustomDate({required this.fastDay, required this.lastDay});
}

class SaleListDismissEvent extends SaleListEvent {
  String firstDate;
  String lastDate;
  int SaleId;
  SaleListDismissEvent(
      {required this.firstDate, required this.lastDate, required this.SaleId});
}

class SaleListDetailsEvent extends SaleListEvent {
  int SaleId;
  SaleListDetailsEvent({required this.SaleId});
}
