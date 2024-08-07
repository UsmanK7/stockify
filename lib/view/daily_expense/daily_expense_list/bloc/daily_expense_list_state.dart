
abstract class SaleOrderListState {}

abstract class DailyExpenseListActionState {}

class SaleInitialState extends SaleOrderListState {}

class SuccessState extends SaleOrderListState {
  String firstDate;
  String lastDate;
  final saleList;

  SuccessState(
      {required this.saleList,
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
