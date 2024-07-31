import 'package:okra_distributer/view/sale/sale_list/model/sale_list_details_model.dart';
import 'package:okra_distributer/view/sale/sale_list/model/sale_list_model.dart';

abstract class SaleListState {}

abstract class SaleListActionState {}

class SaleInitialState extends SaleListState {}

class SuccessState extends SaleListState {
  String firstDate;
  String lastDate;
  List<SaleListModel> saleList;

  SuccessState(
      {required this.saleList,
      required this.firstDate,
      required this.lastDate});
}

class SinkStatusIsOne extends SaleListActionState {}

class SaleListDetailsState extends SaleListState {
  List<Map<String, dynamic>> products;
  SaleWithCustomer saleWithCustomer;
  SaleListDetailsState(
      {required this.saleWithCustomer, required this.products});
}
