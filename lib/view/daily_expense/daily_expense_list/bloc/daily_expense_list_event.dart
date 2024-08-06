abstract class SaleOrderListEvent {}

class SaleOrderListInitialEvent extends SaleOrderListEvent {}

class SaleOrderListThisWeekEvent extends SaleOrderListEvent {}

class SaleOrderListThisMonthEvent extends SaleOrderListEvent {}

class SaleOrderListLastMonthEvent extends SaleOrderListEvent {}

class SaleOrderListThisQuarterEvent extends SaleOrderListEvent {}

class SaleOrderListThisYearEvent extends SaleOrderListEvent {}

class SaleOrderListCustomDate extends SaleOrderListEvent {
  String fastDay;
  String lastDay;
  SaleOrderListCustomDate({required this.fastDay, required this.lastDay});
}

class SaleOrderListDismissEvent extends SaleOrderListEvent {
  String firstDate;
  String lastDate;
  int SaleId;
  SaleOrderListDismissEvent(
      {required this.firstDate, required this.lastDate, required this.SaleId});
}

class SaleOrderListDetailsEvent extends SaleOrderListEvent {
  int SaleId;
  SaleOrderListDetailsEvent({required this.SaleId});
}
