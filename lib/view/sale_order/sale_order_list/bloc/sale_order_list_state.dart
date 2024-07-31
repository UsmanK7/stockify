import 'package:okra_distributer/view/sale_order/sale_order_list/model/sale_order_list_details_model.dart';
import 'package:okra_distributer/view/sale_order/sale_order_list/model/sale_order_list_model.dart';

abstract class SaleOrderListState {}

abstract class SaleOrderListActionState {}

class SaleInitialState extends SaleOrderListState {}

class SuccessState extends SaleOrderListState {
  String firstDate;
  String lastDate;
  List<SaleOrderListModel> saleList;

  SuccessState(
      {required this.saleList,
      required this.firstDate,
      required this.lastDate});
}

class SinkStatusIsOne extends SaleOrderListActionState {}

class SaleListDetailsState extends SaleOrderListState {
  List<Map<String, dynamic>> products;
  SaleWithCustomer saleWithCustomer;
  SaleListDetailsState(
      {required this.saleWithCustomer, required this.products});
}
