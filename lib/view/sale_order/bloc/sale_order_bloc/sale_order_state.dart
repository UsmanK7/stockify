abstract class SaleOrderState {
  SaleOrderState();
}

abstract class SaleOrderActionState extends SaleOrderState {
  SaleOrderActionState();
}

class SaleInitialState extends SaleOrderState {}

class SaleLoadingState extends SaleOrderState {}

class SaleLoadedState extends SaleOrderState {}

class SaleSuccessState extends SaleOrderState {
  List<String> items;
  final selectedItem;
  SaleSuccessState({
    required this.items,
    required this.selectedItem,
  });
}

class ProductSelectedState extends SaleOrderState {
  List<String> units;
  List<int> units_number;
  int product_index;
  List<bool> unitBool;
  final selectedUnit;
  ProductSelectedState({
    required this.units,
    required this.product_index,
    required this.unitBool,
    required this.units_number,
    required this.selectedUnit,
  });
}

class SaleUnitSelectedState extends SaleOrderState {
  double price;
  String sSaleStatus;
  String sSaleType;
  double total_price;
  int unit_type;
  String StockQTY;
  SaleUnitSelectedState(
      {required this.price,
      required this.unit_type,
      required this.sSaleStatus,
      required this.sSaleType,
      required this.StockQTY,
      required this.total_price});
}

class BonusQuantityChangeState extends SaleOrderState {
  String newValue;
  BonusQuantityChangeState({required this.newValue});
}

class RefreshState extends SaleOrderState {}

class FormAddingLoadingState extends SaleOrderState {}

class FormAddingLoadingPrintState extends SaleOrderState {}

class FormAddedState extends SaleOrderActionState {}
class FormAddedPrintState extends SaleOrderActionState {}

class FormErrorState extends SaleOrderState {}
