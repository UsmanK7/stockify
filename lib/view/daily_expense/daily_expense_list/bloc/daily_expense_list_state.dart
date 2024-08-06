import 'package:okra_distributer/view/daily_expense/daily_expense_list/model/daily_expense_list_model.dart';
import 'package:okra_distributer/view/sale_order/sale_order_list/model/sale_order_list_details_model.dart';

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
  List<Map<String, dynamic>> products;
  SaleWithCustomer saleWithCustomer;
  SaleListDetailsState(
      {required this.saleWithCustomer, required this.products});
}
